import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sprout/firestore.dart';
import 'package:sprout/plant_info.dart';

class PlantDisplay extends StatefulWidget {
  final String searchKey;
  const PlantDisplay(this.searchKey, {super.key});

  @override
  State<PlantDisplay> createState() => _PlantDisplayState();
}

class _PlantDisplayState extends State<PlantDisplay> {
  final _plants = PlantList.instance.getPlants();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _plants,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data!.where((element) {
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
            return Flexible(
                child: ListView.builder(
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Tile(list[index]);
              },
            ));
          }
          return const SizedBox.shrink();
        });
  }
}

class Tile extends StatelessWidget {
  final Map<String, dynamic> plant;
  const Tile(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        // leading: Text(index.toString(), style: _biggerFont),
        title: Text(
            plant["Common name"]?[0] ??
                plant["Latin name"] ??
                plant["Other names"][0] ??
                "No Name",
            style: const TextStyle(fontSize: 18.0)),
      ),
      InkWell(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PlantInfo(plant);
              })),
          child: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Row(
                children: [
                  Expanded(
                    child: Image.network(
                        plant["img"] ??
                            "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",
                        fit: BoxFit.cover),
                  )
                ],
              )))
    ]);
  }
}
