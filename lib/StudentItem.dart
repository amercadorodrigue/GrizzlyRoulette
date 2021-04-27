//Angel Mercado
//ITEC 4550
//5/3/2021

import 'package:flutter/material.dart';
//Student class that also builds the widgets for ListView
class StudentItem  {
  final String name;
  bool hidden;

  StudentItem(this.name, this.hidden);

  Widget buildTitle(BuildContext context) => Text(name, style: TextStyle( fontSize: 35));
  Widget buildIcon(BuildContext context) => Icon(Icons.visibility_off);
}
