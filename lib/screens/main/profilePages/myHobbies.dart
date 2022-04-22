import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHobbies extends StatefulWidget {
  const MyHobbies({Key? key}) : super(key: key);

  @override
  State<MyHobbies> createState() => _MyHobbiesState();
}

class _MyHobbiesState extends State<MyHobbies> {
  List hobbieList = [];

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirestoreHelper.getUserData().then((value) {
      setState(() {
        hobbieList = value.hobbies;
      });
    });
  }

  void addItemToList() async {
    nameController.text.length != 0
        ? await FirestoreHelper.addHobbieListItem(nameController.text).then(
            (value) {
              if (value == true) {
                setState(() {
                  hobbieList.insert(0, nameController.text);
                  nameController.text = "";
                });
              } else {}
            },
          )
        : (print("object"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Hobbie List'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                        controller: nameController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Add Spotify Link",
                        )),
                  ),
                  GestureDetector(
                      onTap: () {
                        addItemToList();
                      },
                      child: const Card(
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                Icons.add,
                              )))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: hobbieList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                hobbieList[index].toString().length >= 20
                                    ? '${hobbieList[index]}'.substring(0, 20)
                                    : hobbieList[index],
                                style: TextStyle(fontSize: 18),
                              ),
                              TextButton(
                                child: Text(
                                  ' Remove',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  FirestoreHelper.removeHobbieListItem(
                                          hobbieList[index])
                                      .then((value) {
                                    value
                                        ? FirestoreHelper.getUserData()
                                            .then((value) {
                                            setState(() {
                                              hobbieList = value.SpotifyList;
                                            });
                                          })
                                        : (print("false"));
                                  });
                                },
                              ),
                            ],
                          ));
                    })),
          ],
        ));
  }
}
