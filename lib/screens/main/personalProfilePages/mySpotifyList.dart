import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/widgets/seach_Bar/easy_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spotify_metadata/spotify_metadata.dart' as apii;
import 'package:flutter/src/widgets/image.dart' as imagess;

class mySpotifyList extends StatefulWidget {
  const mySpotifyList({Key? key}) : super(key: key);

  @override
  State<mySpotifyList> createState() => _mySpotifyListState();
}

class _mySpotifyListState extends State<mySpotifyList> {
  List<String> spotifyLists = [];
  List<String> spotifyListUrls = [];
  bool isLoaded = false;
  List<apii.SpotifyMetadata> metaData = [];

  final spotify = SpotifyApi(SpotifyApiCredentials(
      "ab4a68d305144e308412a55e70396c92", "76353d3d6dea40a79c8738acf69849c2"));

  Future<List<String>> seachSpotifyMusic(String query) async {
    List<dynamic> search = [];
    setState(() {
      spotifyLists = [];
      spotifyListUrls = [];
    });
    try {
      search =
          await spotify.search.get(query.length != 0 ? query : "").first(3);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    if (search != null) {
      search.forEach((pages) async {
        if (pages != null) {
          await pages.items!.forEach((item) {
            if (item is TrackSimple) {
              //print(item.previewUrl.toString());
              if (mounted) {
                setState(() {
                  spotifyLists.add(item.name.toString());
                  spotifyListUrls.add(
                      "https://open.spotify.com/track/" + item.id.toString());
                });
              }
            }
          });
        }
      });
    }
    print(spotifyLists.length);
    print(spotifyListUrls.length);
    return spotifyLists;
  }

  Future<List<String>> seachSpotifyMusicc(String query) async {
    return spotifyLists;
  }

  List spotifyLinkss = [];
  Future getAllSpotifyList() async {
    setState(() {
      spotifyLinkss.clear();
      metaData.clear();
      isLoaded = false;
    });
    await FirestoreHelper.getUserData().then((value) async {
      setState(() {
        spotifyLinkss = value.SpotifyList;
      });
    }).then((value) {
      spotifyLinkss.forEach((element) async {
        apii.SpotifyApi.getData(element).then((value) {
          setState(() {
            metaData.add(value);
          });
        });
      });
    });
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    getAllSpotifyList().then((all) {
      return null;
    });
    super.initState();
  }

  Future addItemToList(String url) async {
    try {
      await FirestoreHelper.addSpotifyListItem(url).then(
        (value) {
          if (value == true) {
            Fluttertoast.showToast(msg: "Music added!");
          } else {
            Fluttertoast.showToast(msg: "Music not added!");
          }
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Please select valid link!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
          searchBackgroundColor: Colors.grey,
          title: Text(AppLocalizations.of(context)!.addspotify),
          isFloating: false,
          onSearch: (value) {
            seachSpotifyMusic(value).then((value) => null);
          },
          asyncSuggestions: (value) async {
            return await spotifyLists;
          },
          searchHintText: AppLocalizations.of(context)!.addspotify,
          suggestionsElevation: 50,
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
                            addItemToList(spotifyListUrls[
                                    spotifyLists.indexOf(value)])
                                .then((value) {
                              setState(() {
                                isLoaded = false;
                              });
                              if (value == true) {
                                getAllSpotifyList().then((value) {
                                  Navigator.pop(context);
                                });
                              } else {
                                getAllSpotifyList().then((value) {
                                  Navigator.pop(context);
                                });
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
            SizedBox(
              height: 10,
            ),
            isLoaded
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: metaData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                                height: 50,
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 80,
                                      child: imagess.Image(
                                          image: CachedNetworkImageProvider(
                                              metaData[index].thumbnailUrl)),
                                    ),
                                    Text(
                                      metaData[index].title.length >= 20
                                          ? metaData[index]
                                              .title
                                              .substring(0, 20)
                                          : metaData[index].title,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          FirestoreHelper.removeSpotifyListItem(
                                                  spotifyLinkss[index])
                                              .then((value) {
                                            setState(() {
                                              isLoaded = false;
                                            });
                                            value
                                                ? getAllSpotifyList()
                                                    .then((value) => null)
                                                : (print("false"));
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )),
                          );
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
