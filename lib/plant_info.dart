import 'package:flutter/material.dart';

class PlantInfo extends StatelessWidget {
  final Map<String, dynamic> plant;
  const PlantInfo(this.plant, {super.key});

  RichText makeText(String title, String info) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(fontSize: 20, color: Colors.black),
            children: <TextSpan>[
          TextSpan(
              text: "$title ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: info)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    String name = plant["Common name"]?[0] ??
        plant["Latin name"] ??
        plant["Other names"][0] ??
        "No Name";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Column(
                  children: [
                    Text(name, style: const TextStyle(fontSize: 50)),
                    Image.network(plant["img"] ??
                        "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns="),
                    SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            makeText("Temperature(F):",
                                "${plant['Temperature min']?['F'] ?? 'Unavailable'} - ${plant['Temperature max']?['F'] ?? 'Unavailable'}"),
                            makeText("Watering:",
                                "${plant['Watering'] ?? 'Unavailable'}"),
                            makeText("Growth:",
                                "${plant['Growth'] ?? 'Unavailable'}"),
                            makeText("Pot Diameter(cm):",
                                "${plant['Pot diameter (cm)']?['cm'] ?? 'Unavailable'}"),
                            makeText("Height(cm):",
                                "${plant['Height potential']?['cm'] ?? 'Unavailable'}"),
                            makeText("Ideal Light:",
                                "${plant['Light ideal'] ?? 'Unavailable'}"),
                          ],
                        ))
                  ],
                )))));
  }
}
