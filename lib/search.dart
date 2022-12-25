import 'package:flutter/material.dart';
import 'package:sprout/firestore.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _suggestions = PlantList.instance.getSuggestions();

  @override
  Widget build(BuildContext context) {
    PlantList.instance
        .getSuggestions()
        .then((res) => debugPrint(res.toString()));
    return FutureBuilder(
        future: _suggestions,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return Autocomplete<String>(optionsBuilder: (TextEditingValue val) {
              if (val.text == '') return [];
              return snapshot.data!.where((name) =>
                  name.toLowerCase().contains(val.text.toLowerCase()));
            });
          }
          return const SizedBox.shrink();
        });
  }
}
