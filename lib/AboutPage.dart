//Angel Mercado
//ITEC 4550
//5/3/2021

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//About page with Creator information
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Grizzly Roulette';
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image(image: AssetImage("assets/bbuildingwavy.jpg")),
              Text("Created By Angel Mercado", style: TextStyle(fontSize: 25)),
              Text("Created for ITEC 4550", style: TextStyle(fontSize: 20)),
              Container(
                width: 250.0,
                height: 450.0,
                child: Image(image: AssetImage("assets/angel_jacket.jpg")),
              ),
              Text("05/03/2021"),
              Text("Presented for by and something something I cannot read")
            ],
          ),
        ));
  }

}
