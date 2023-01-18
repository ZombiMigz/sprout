import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DB {
  static DB? _instance;

  static DB get instance {
    if (_instance == null) {
      _instance = DB();
      return _instance!;
    }
    return _instance!;
  }

  List<Map<String, dynamic>>? _plantCache;

  Future<List<String>> getSuggestions() async {
    final plants = await getPlants();
    List<String> suggestions = [];
    add(Map<String, dynamic> plant, String key) {
      if (!plant.containsKey(key)) return;
      if (plant[key] is List<dynamic>) {
        for (var name in plant[key]) {
          if (name is String) suggestions.add(name);
        }
      }
      if (plant[key] is String) suggestions.add(plant[key]);
    }

    for (var plant in plants) {
      add(plant, "Common name");
      add(plant, "Latin name");
      add(plant, "Other names");
    }
    return suggestions;
  }

  Future<List<Map<String, dynamic>>> getPlants() async {
    if (_plantCache != null) return _plantCache!;
    final query = await FirebaseFirestore.instance.collection("plants").get();

    var list = await Future.wait(query.docs.map((q) async {
      var plant = q.data();
      plant["likes"] = (await FirebaseFirestore.instance
              .collection("favorites")
              .where("plantId", isEqualTo: q.reference.id)
              .get())
          .docs
          .length;
      return plant;
    }).toList());

    list.sort((a, b) {
      return (a["Common name"]?[0] ??
              a["Latin name"] ??
              a["Other names"][0] ??
              "ZZZ")
          .compareTo((b["Common name"]?[0] ??
              b["Latin name"] ??
              b["Other names"][0] ??
              "ZZZ"));
    });
    return list;
  }

  Future<Set<String>> getFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return {};
    final items = (await FirebaseFirestore.instance
            .collection("favorites")
            .where("userId", isEqualTo: uid)
            .get())
        .docs
        .map((e) {
      return e.data()["plantId"] as String;
    }).toList();
    debugPrint(items.toString());
    return <String>{...items};
  }

  Future<void> like(String plantId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    var like = await FirebaseFirestore.instance
        .collection("favorites")
        .where("userId", isEqualTo: uid)
        .where("plantId", isEqualTo: plantId)
        .limit(1)
        .get();
    if (like.docs.length == 1) {
      await FirebaseFirestore.instance
          .collection("favorites")
          .doc(like.docs[0].id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("favorites")
          .add({"plantId": plantId, "userId": uid});
    }
    return;
  }
}
