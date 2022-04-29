import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class mySpotifyList extends StatefulWidget {
  const mySpotifyList({Key? key}) : super(key: key);

  @override
  State<mySpotifyList> createState() => _mySpotifyListState();
}

class _mySpotifyListState extends State<mySpotifyList> {
  List spotifyLists = [];
  List<SpotifyMetadata> metaData = [];
  bool isLoaded = false;

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirestoreHelper.getUserData().then((value) {
      setState(() {
        spotifyLists = value.SpotifyList;
      });
    }).whenComplete(() => getSpotifyInfo().then((value) {
          setState(() {
            isLoaded = true;
          });
        }));
  }

  Future getSpotifyInfo() async {
    spotifyLists.forEach((element) async {
      print("object");
      SpotifyApi.getData(element).then((value) {
        setState(() {
          metaData.add(value);
        });
      });
    });
  }

  void addItemToList() async {
    nameController.text.length != 0
        ? nameController.text.contains("spotify.com/track/")
            ? await FirestoreHelper.addSpotifyListItem(nameController.text)
                .then(
                (value) {
                  if (value == true) {
                    setState(() {
                      spotifyLists.insert(0, nameController.text);
                      nameController.text = "";
                    });
                  } else {}
                },
              )
            : Fluttertoast.showToast(msg: "Please add valid link!")
        : (print("object"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.spotifylist),
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
                          hintText: AppLocalizations.of(context)!.addspotify,
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
            isLoaded
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: metaData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              height: 50,
                              margin: EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        metaData[index].thumbnailUrl),
                                  ),
                                  Text(
                                    metaData[index].title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextButton(
                                    child: Text(
                                      AppLocalizations.of(context)!.remove,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onPressed: () {
                                      FirestoreHelper.removeSpotifyListItem(
                                              spotifyLists[index])
                                          .then((value) {
                                        value
                                            ? FirestoreHelper.getUserData()
                                                .then((value) {
                                                setState(() {
                                                  spotifyLists =
                                                      value.SpotifyList;
                                                });
                                              })
                                            : (print("false"));
                                      });
                                    },
                                  ),
                                ],
                              ));
                        }))
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blueGrey,
                      strokeWidth: 2,
                    ),
                  ),
          ],
        ));
  }
}
