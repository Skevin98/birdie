import 'dart:convert';
import 'dart:io';

import 'package:birdie/classes/Bird.dart';
import 'package:birdie/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Bird bird = Bird(1,"Low Concern",
    //     "Anatidae","Black-bellied Whistling-Duck","Anseriformes","51",
    //     "Dendrocygna autumnalis",[
    //       "https://images.unsplash.com/photo-1643650997626-0124dbb98261",
    //       "https://images.unsplash.com/photo-1644610901347-b05ec91bb9b2",
    //       "https://images.unsplash.com/photo-1641995171363-9bc67bfb1b7c"
    //     ]);
    return MaterialApp(
        title: "Birdie",
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: HexColor("#658864"),
            foregroundColor: Colors.white,
            centerTitle: true,
            titleTextStyle: GoogleFonts.manrope(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        home: const BirdList());
  }
}

class BirdList extends StatefulWidget {
  const BirdList({Key? key}) : super(key: key);

  @override
  State<BirdList> createState() => _BirdListState();
}

class _BirdListState extends State<BirdList> {
  String name = "";
  final nameController = TextEditingController();
  Future<Iterable<Bird>> getBirds = Future(() => []);

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getBirds = _getBirds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Birdie"),
      ),
      body: FutureBuilder(
          future: getBirds,
          builder:
              (BuildContext context, AsyncSnapshot<Iterable<Bird>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: snapshot.data!.length,
                    itemExtent: 100,
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    itemBuilder: (context, i) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          leading:
                              snapshot.data!.elementAt(i).images!.isNotEmpty
                                  ? Image.network(
                                      snapshot.data!.elementAt(i).images![0],
                                      height: 200,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "images/unavailable.png",
                                      height: 200,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                          title: Text(
                            snapshot.data!.elementAt(i).name,
                            style: GoogleFonts.manrope(
                              textStyle: const TextStyle(),
                            ),
                          ),
                          subtitle:
                              snapshot.data!.elementAt(i).sciName!.isNotEmpty
                                  ? Text(
                                      snapshot.data!.elementAt(i).sciName!,
                                      style: GoogleFonts.manrope(
                                        textStyle: const TextStyle(),
                                      ),
                                    )
                                  : const Text("no scientific name."),
                          trailing: const Icon(Icons.more_horiz_rounded),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return Detail(
                                    bird: snapshot.data!.elementAt(i));
                              }),
                            );
                          },
                        ),
                      );
                    }),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Center(
                  child: Text("${snapshot.error}"),
                ),
              ];
            } else {
              children = <Widget>[
                const Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ];
            }
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "Avec Birdie, Les oiseaux n'auront plus aucun secret pour vous !",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              style: GoogleFonts.manrope(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Recherche par mot clé',
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  getBirds =
                                      _getBirds(name: nameController.text);
                                });

                                print("query : ${nameController.text}");
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => HexColor("#658864")),
                              ),
                              child: Text(
                                "Rechercher !",
                                style: GoogleFonts.manrope(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Expanded(child: children.first),
                  ]),
            );
          }),
    );
  }
}

Future<Iterable<Bird>> _getBirds({name = ''}) async {
  List<Bird> birds = <Bird>[];
  final response = await http.get(
      Uri.parse('https://nuthatch.lastelm.software/birds?name=$name'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        'API-Key': 'd5a1922a-b762-43de-9f73-c9dde787dcdc',
      });

  final responseJson = jsonDecode(response.body);

  for (var i in responseJson) {
    birds.add(Bird.fromJson(i));
  }

  return birds.take(15);
}
