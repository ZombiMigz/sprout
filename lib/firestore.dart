import 'package:cloud_firestore/cloud_firestore.dart';

class PlantList {
  static PlantList? _instance;

  static PlantList get instance {
    if (_instance == null) {
      _instance = PlantList();
      return _instance!;
    }
    return _instance!;
  }

  List<Map<String, dynamic>>? _plantCache;

  Future<List<Map<String, dynamic>>> getPlants() async {
    if (_plantCache != null) return _plantCache!;
    final query = await FirebaseFirestore.instance.collection("plants").get();

    var list = query.docs.map((q) {
      return q.data();
    }).toList();
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
}
