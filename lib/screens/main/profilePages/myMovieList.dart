import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class myMovieList extends StatefulWidget {
  const myMovieList({Key? key}) : super(key: key);

  @override
  State<myMovieList> createState() => _myMovieListState();
}

class _myMovieListState extends State<myMovieList> {
  List movieList = [];

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirestoreHelper.getUserData().then((value) {
      setState(() {
        movieList = value.MovieList;
      });
    });
  }

  void addItemToList() async {
    nameController.text.length != 0
        ? await FirestoreHelper.addMovieListItem(nameController.text).then(
            (value) {
              if (value == true) {
                setState(() {
                  movieList.insert(0, nameController.text);
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
          title: Text('My Movie List'),
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
                    itemCount: movieList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                movieList[index].toString().length >= 20
                                    ? '${movieList[index]}'.substring(0, 20)
                                    : movieList[index],
                                style: TextStyle(fontSize: 18),
                              ),
                              TextButton(
                                child: Text(
                                  ' Remove',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  FirestoreHelper.removeMovieListItem(
                                          movieList[index])
                                      .then((value) {
                                    value
                                        ? FirestoreHelper.getUserData()
                                            .then((value) {
                                            setState(() {
                                              movieList = value.SpotifyList;
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
