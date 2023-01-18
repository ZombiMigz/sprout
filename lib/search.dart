import 'package:flutter/material.dart';
import 'package:sprout/firestore.dart';

class Search extends StatefulWidget {
  final String searchKey;
  final Function setSearchKey;
  final bool sortFavorites;
  final Function toggleSort;
  const Search(
      this.searchKey, this.setSearchKey, this.sortFavorites, this.toggleSort,
      {super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _suggestions = DB.instance.getSuggestions();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _suggestions,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  Expanded(
                      child: Autocomplete<String>(
                    fieldViewBuilder: ((context, textEditingController,
                            focusNode, onFieldSubmitted) =>
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Search Here...'),
                          onChanged: (value) => widget.setSearchKey(value),
                        )),
                    initialValue: TextEditingValue(text: widget.searchKey),
                    optionsBuilder: (TextEditingValue val) {
                      if (val.text == '') return [];
                      return snapshot.data!.where((name) =>
                          name.toLowerCase().contains(val.text.toLowerCase()));
                    },
                  )),
                  IconButton(
                      onPressed: () => widget.toggleSort(),
                      icon: widget.sortFavorites
                          ? const Icon(Icons.favorite_rounded)
                          : const Icon(Icons.sort_by_alpha))
                ]));
          }
          return const SizedBox.shrink();
        });
  }
}
