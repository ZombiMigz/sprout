import 'package:flutter/material.dart';
import 'package:sprout/plant_display.dart';
import 'package:sprout/search.dart';

class Plants extends StatefulWidget {
  final bool favoritesOnly;
  const Plants(this.favoritesOnly, {super.key});

  @override
  State<Plants> createState() => _PlantsState();
}

class _PlantsState extends State<Plants> {
  String _searchKey = "";
  bool _sortFavorites = false;
  setSearchKey(String key) {
    debugPrint(key);
    setState(() {
      _searchKey = key;
    });
  }

  void toggleSort() {
    setState(() => _sortFavorites = !_sortFavorites);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Search(_searchKey, setSearchKey, _sortFavorites, toggleSort),
      PlantDisplay(_searchKey, widget.favoritesOnly, _sortFavorites)
    ]);
  }
}
