import 'package:flutter/material.dart';

class heroView extends StatelessWidget {
  const heroView({super.key, required this.hero});
  final Map hero;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: const Color(0x00000000),
              foregroundColor: const Color(0xffffffff),
              child: const Icon(
                Icons.arrow_back,
                size: 38,
              ),
            ),
            body: Scrollbar(
                child: ListView(
              children: <Widget>[
                Image.network(
                  hero["heroimage"]["results"][0]["fileUrl"],
                  fit: BoxFit.cover,
                ),
                Container(
                    height: 70,
                    alignment: Alignment.center,
                    //color: Colors.amber[600],
                    child: Text(hero["longTitle"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))),
                Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    //color: Colors.amber[600],
                    child: Text(hero["description"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ))),
              ],
            ))));
  }
}
