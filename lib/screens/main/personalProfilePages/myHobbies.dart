import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/seach_Bar/easy_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHobbies extends StatefulWidget {
  const MyHobbies({Key? key}) : super(key: key);

  @override
  State<MyHobbies> createState() => _MyHobbiesState();
}

class _MyHobbiesState extends State<MyHobbies> {
  List hobbieList = [];
  bool isLoading = true;
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    getAllHobbies().then((value) {});
  }

  Future getAllHobbies() async {
    setState(() {
      isLoading = true;
    });
    await FirestoreHelper.getUserData().then((value) {
      setState(() {
        hobbieList = value.hobbies;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
          searchBackgroundColor: Colors.grey,
          title: const Text('Add New Hobbie'),
          onSearch: (value) => setState(() => searchValue = value),
          asyncSuggestions: (value) async {
            return await [
              'Fishing',
              'Automobilism',
              'Powerlifting',
              'Roller skating',
              'Figure skating',
              'Rugby',
              'Darts',
              'Football',
              'Barre',
              'Tai chi',
              'Stretching',
              'Bowling',
              'Ice hockey',
              'Surfing',
              'Tennis',
              'Baseball',
              'Gymnastics',
              'Rock climbing',
              'Dancing',
              'Gardening',
              'Karate',
            ];
          },
          onSuggestionTap: (value) async {
            await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('CAUTION'),
                      content: Text(value + " will add your profile."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            value = "";
                          },
                          child: const Text('Decline'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirestoreHelper.addHobbieListItem(searchValue)
                                .then((value) {
                              if (value == true) {
                                Fluttertoast.showToast(
                                    msg: "Hobbie added successfully");
                                getAllHobbies()
                                    .then((value) => Navigator.pop(context));
                              } else {
                                Fluttertoast.showToast(msg: "Error occured!");
                                getAllHobbies()
                                    .then((value) => Navigator.pop(context));
                              }
                            });
                          },
                          child: const Text('Accept'),
                        ),
                      ],
                    ));
          },
        ),
        body: Column(
          children: <Widget>[
            hobbieList.length != 0
                ? Expanded(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Colors.blueGrey,
                              strokeWidth: 2,
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async => getAllHobbies(),
                            child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: hobbieList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Container(
                                        height: 50,
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              hobbieList[index]
                                                          .toString()
                                                          .length >=
                                                      20
                                                  ? '${hobbieList[index]}'
                                                      .substring(0, 20)
                                                  : hobbieList[index],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  FirestoreHelper
                                                          .removeHobbieListItem(
                                                              hobbieList[index])
                                                      .then((value) async {
                                                    await hobbieList
                                                        .remove(index);
                                                    await getAllHobbies()
                                                        .then((value) => null);
                                                  });
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        )),
                                  );
                                }),
                          ))
                : Expanded(
                    child: Center(
                    child:
                        Text("There is no hobbie please add from seach bar."),
                  )),
          ],
        ));
  }
}
