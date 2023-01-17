import 'package:flutter/material.dart';
import 'package:sprout/plant_display.dart';
import 'package:sprout/search.dart';

class Plants extends StatefulWidget {
  const Plants({super.key});

  @override
  State<Plants> createState() => _PlantsState();
}

class _PlantsState extends State<Plants> {
  String _searchKey = "";
  setSearchKey(String key) {
    debugPrint(key);
    setState(() {
      _searchKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [Search(_searchKey, setSearchKey), PlantDisplay(_searchKey)]);
  }
}
