import 'package:birdie/classes/Bird.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.bird});
  final Bird bird;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A propos de ${widget.bird.name}"),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.bird.images!.isNotEmpty
                  ? widget.bird.images![0]
                  : "images/unavailable.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            bottom: 240,
            left: 5,
            width: 400,
            height: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: HexColor("#658864").withOpacity(0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ordre : ${widget.bird.order}",
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Nom courant : ${widget.bird.name}",
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 5,
            bottom: 40,
            height: 200,
            width: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: HexColor("#B7B78A").withOpacity(0.6),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Nom scientifique : ${widget.bird.sciName}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Famille : ${widget.bird.family}",
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 5,
            height: 200,
            width: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: HexColor("#DDDDDD").withOpacity(0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Taille max : ${widget.bird.lengthMax ?? "Taille max inconnu"}",
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Statut : ${widget.bird.status}",
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            width: 400,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => HexColor("#658864")),
              ),
              child: const Text("Retour"),
            ),
          ),
        ],
      ),
    );
  }
}
