//Angel Mercado
//ITEC 4550
//5/3/2021

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grizzly_roulette/StudentItem.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage>{

  StudentItem student;

  @override
  Widget build(BuildContext context) {
    final title = 'Add Student Name';
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, right: 20.0,),
              child: GestureDetector(
                onTap: () {
                  //pop(student) passes the data to HomePage
                  print("passing Student: $student of name ${student.name}");
                  Navigator.of(context).pop(student);
                },
                child: Text("ADD", style: TextStyle(
                  fontSize: 20,
                ),),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String value) {
                  //data to be passed to homePage
                  student = StudentItem(value, false);
                },
                style: TextStyle(
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                ),
              ),
            ],
          ),
        ));
  }
}
