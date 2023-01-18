import 'package:flutter/material.dart';
import 'package:sprout/firestore.dart';
import 'package:sprout/plant_info.dart';

class PlantDisplay extends StatefulWidget {
  final String searchKey;
  final bool favoritesOnly;
  final bool sortFavorites;
  const PlantDisplay(this.searchKey, this.favoritesOnly, this.sortFavorites,
      {super.key});

  @override
  State<PlantDisplay> createState() => _PlantDisplayState();
}

class _PlantDisplayState extends State<PlantDisplay> {
  var _plants = DB.instance.getPlants();
  Set<String> _favorites = {};

  Future<void> updateFavorites() async {
    await DB.instance.getFavorites().then(
      (favorites) {
        setState(() => _favorites = favorites);
        setState(() => _plants = DB.instance.getPlants());
      },
    );
    return;
  }

  @override
  void initState() {
    updateFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _plants,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data!.where((element) {
              if (widget.favoritesOnly && !_favorites.contains(element["id"])) {
                return false;
              }
              return (element["Common name"] != null &&
                      element["Common name"][0]
                          .toString()
                          .toLowerCase()
                          .contains(widget.searchKey)) ||
                  (element["Latin name"] != null &&
                      element["Latin name"]
                          .toString()
                          .toLowerCase()
                          .contains(widget.searchKey)) ||
                  (element["Other names"] != null &&
                      element["Other names"][0]
                          .toString()
                          .toLowerCase()
                          .contains(widget.searchKey));
            }).toList();
            if (widget.sortFavorites) {
              list.sort((a, b) {
                return b["likes"] - a["likes"];
              });
            }
            return Flexible(
                child: ListView.builder(
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Tile(list[index], _favorites.contains(list[index]["id"]),
                    updateFavorites);
              },
            ));
          }
          return const SizedBox.shrink();
        });
  }
}

class Tile extends StatefulWidget {
  final Map<String, dynamic> plant;
  bool liked;
  final Function updateFavorites;
  Tile(this.plant, this.liked, this.updateFavorites, {super.key});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  void like() async {
    setState(() {
      widget.plant["likes"] += widget.liked ? -1 : 1;
      widget.liked = !widget.liked;
    });

    await DB.instance.like(widget.plant["id"]);
    await widget.updateFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Text(
              widget.plant["Common name"]?[0] ??
                  widget.plant["Latin name"] ??
                  widget.plant["Other names"][0] ??
                  "No Name",
              style: const TextStyle(fontSize: 18.0)),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.arrow_right,
              size: 35,
            ),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlantInfo(widget.plant);
            })),
          ),
        ],
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 5,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            InkWell(
                onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PlantInfo(widget.plant);
                    })),
                child: Image.network(
                    widget.plant["img"] ??
                        "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",
                    fit: BoxFit.cover)),
            Positioned(
              bottom: 15,
              left: 15, //give the values according to your requirement
              child: InkWell(
                  onTap: like,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.favorite,
                          color: widget.liked ? Colors.red : Colors.white,
                          size: 50),
                      Center(
                          child: Text("${widget.plant["likes"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                    ],
                  )),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20)
    ]);
  }
}
