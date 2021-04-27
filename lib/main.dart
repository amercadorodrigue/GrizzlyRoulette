//Angel Mercado
//ITEC 4550
//5/3/2021

import 'package:flutter/material.dart';
import 'package:grizzly_roulette/AboutPage.dart';
import 'package:grizzly_roulette/AddPage.dart';
import 'package:grizzly_roulette/StudentItem.dart';
import 'package:grizzly_roulette/Storage.dart';

import 'dart:math';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final List<StudentItem> items;

  MyApp({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Grizzly Roulette';

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(title: title));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //used when selecting a name from StudentList randomly
  Random _randomizer = new Random();
  List<StudentItem> _students;
  String _nameSelected;
  Storage storage;
  final title = 'Grizzly Roulette';

  @override
  void initState() {
    super.initState();
    storage = new Storage();
    _students = [];
    _populateStudents();
    _nameSelected = "";
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _populateStudents() async {
    print("Populating list from txt file for the first time after install");
    List<StudentItem> _studentsFromText = await storage.readStudents();
    if (_studentsFromText != null) {
      setState(() {
        _students = _studentsFromText;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("APP_STATE: $state");

    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      var _studentsFromText = await storage.readStudents();
      setState(() {
        _students = _studentsFromText;
      });
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      storage.writeStudents(_students);
    } else if (state == AppLifecycleState.paused) {
      // user quit our app temporally
      storage.writeStudents(_students);
      // }else if(state == AppLifecycleState.suspending){
      //   // app suspended
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          //Menu on the right with settings and about page
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == "Settings") {
                print("Settings pressed");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Settings coming soon...'),
                    action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          // Code to execute.
                        })));
              } else if (value == "About") {
                print("About page pressed");
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new AboutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Settings', 'About'}.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(fontSize: 20),
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            //LongPress on Image populates with students in class
            GestureDetector(
              child: Image(image: AssetImage('assets/bbuildingwavy.jpg')),
              onLongPress: () {
                _generateClassStudents();
              },
            ),

           //Where name selected is displayed
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
              width: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Text(
                _nameSelected,
                style: TextStyle(fontSize: 45),
              ),
            ),
            //ListView is populated here expanding on the remaining of the screen
            Expanded(
              child: Container(
                child: ListView.separated(
                    // Let the ListView know how many items it needs to build.
                    itemCount: _students.length,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.

                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      //Allows the listItems to be removed on swipe left
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        key: UniqueKey(),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          setState(() {
                            _students.removeAt(index);
                          });
                        },
                        //Actual list Items building
                        child: ListTile(
                          title: _students[index].buildTitle(context),
                          trailing: _students[index].hidden
                              ? _students[index].buildIcon(context)
                              : Icon(null),
                          onTap: () {
                            //Method to switch between hidden bool and display icon
                            return _itemSelected(
                                _students[index], context, index);
                          },
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      //Left drawer on main page with options
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Edit List', style: TextStyle(fontSize: 20)),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('Add Name', style: TextStyle(fontSize: 20)),
              onTap: () {
                _addPage();
              },
            ),
            ListTile(
              title: Text('Sort', style: TextStyle(fontSize: 20)),
              onTap: () {
                _sort();
              },
            ),
            ListTile(
              title: Text('Shuffle', style: TextStyle(fontSize: 20)),
              onTap: () {
                _shuffle();
              },
            ),
            ListTile(
              title: Text('Clear', style: TextStyle(fontSize: 20)),
              onTap: () {
                _clearList();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      //button that selects randomly or displays snackbar if no names are on list
      floatingActionButton: FloatingActionButton(
        tooltip: 'Select',
        child: Icon(Icons.sync),
        onPressed: () {
          print("FAB was pressed");
          if (_students.length == 0) {
            setState(() {
              _nameSelected = "";
            });
            return ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                content: const Text('No names on list'),
                action: SnackBarAction(label: 'Dismiss', onPressed: () {})));
          } else {
            _selectStudent();
          }
        },
      ),
    );
  }

  //sorting names on list
  _sort() {
    print("Sort pressed");
    Navigator.pop(context);
    setState(() {
      _students.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    });
  }

  //clears list
  _clearList() {
    print("clear list pressed");
    setState(() {
      _nameSelected = "";
      _students = [];
    });
  }

  //shuffles the list
  _shuffle() {
    print("shuffle pressed");
    Navigator.pop(context);
    setState(() {
      _students.shuffle();
    });
  }

  //takes you to add page and passes data to be added to _students
  Future _addPage() async {
    print('adding ... ');
    Navigator.pop(context);
    StudentItem _data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new AddPage()),
    );
    if (_data == null) {
      return;
    }
    print("Added: ${_data.name}");
    setState(() {
      _students.add(_data);
      _nameSelected = "";
    });
    storage.writeStudents(_students);
  }

  //demo purposes. Adds class names to list
  _generateClassStudents() {
    var _classStudents = [
      "Adhul",
      "Angel",
      "Boji",
      "Carina",
      "David",
      "Dustin",
      "Flaka",
      "Isabelle",
      "Isaiah",
      "Jabree",
      "Jared",
      "Josue",
      "Matthew",
      "Migwi",
      "Nga",
      "Omar",
      "Robert",
      "Taylor"
    ];
    _clearList();
    print("Generating Class Students List...");
    for (var name in _classStudents) {
      setState(() {
        _students.add(StudentItem(name, false));
      });
    }
  }

  //method that selects students that are not hidden
  _selectStudent() {
    setState(() {
      _nameSelected = "";
    });
    StudentItem student = _students[_randomizer.nextInt(_students.length)];
    //if the student is hiddent it goes through the list multiple times to try to find a name that's not hidden
    if (student.hidden) {
      for (int i = 0; i < pow(_students.length, 3); i++) {
        student = _students[_randomizer.nextInt(_students.length)];
        //if it find a name that is not hidden it stops the loop
        if (!student.hidden) {
          break;
        }
      }
    }

    //if it cannot find a name that is not hidden it returns a SnackBar
    if (student.hidden) {
      return ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: const Text('All names are hidden.'),
          action: SnackBarAction(label: 'Dismiss', onPressed: () {})));
    }

    //Name selected text is populated with the student selected name
    String name = student.name;
    print("$name is selected!");
    setState(() {
      _nameSelected = name;
    });
  }

  //Switches between hidden bool and displays icon
  Widget _itemSelected(StudentItem item, BuildContext context, int index) {
    if (item.hidden == true) {
      setState(() {
        _students[index].hidden = false;
      });
    } else {
      setState(() {
        _students[index].hidden = true;
      });
      print(item.name + " changed to hidden:  ${item.hidden} ");
      return item.buildIcon(context);
    }
    print(item.name + " changed to hidden:  ${item.hidden} ");
    return Icon(null);
  }
}
