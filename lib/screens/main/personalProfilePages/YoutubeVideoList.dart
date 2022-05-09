import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/seach_Bar/easy_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youtube_metadata/youtube_metadata.dart';
import 'package:flutter/src/widgets/image.dart' as imagess;

class myYoutubeList extends StatefulWidget {
  const myYoutubeList({Key? key}) : super(key: key);

  @override
  State<myYoutubeList> createState() => _myYoutubeListState();
}

class _myYoutubeListState extends State<myYoutubeList> {
  bool isLoaded = false;
  YoutubeAPI youtube = YoutubeAPI(YOUTUBE_API_KEY);
  List<YouTubeVideo> videoResult = [];
  List<String> _youtubeLinks = [];
  List<MetaDataModel> _savedVideoResult = [];
  List _savedYoutubeLinks = [];

  @override
  void initState() {
    getAllYoutubeList();
    super.initState();
  }

  Future getAllYoutubeList() async {
    setState(() {
      isLoaded = false;
      _savedVideoResult.clear();
      _savedYoutubeLinks.clear();
    });
    await FirestoreHelper.getUserData().then((value) {
      setState(() {
        _savedYoutubeLinks = value.myYoutubeVideo;
      });
    }).whenComplete(() => getYoutubeInfo().then((value) {
          setState(() {
            isLoaded = true;
          });
        }));
  }

  Future getYoutubeInfo() async {
    _savedYoutubeLinks.forEach((element) async {
      YoutubeMetaData.getData(element).then((value) {
        setState(() {
          _savedVideoResult.add(value);
        });
      });
    });
  }

  Future<void> callAPI(String query) async {
    youtube.regionCode = 'TR';
    videoResult = await youtube.search(query,
        order: 'relevance', videoDuration: 'any', regionCode: 'TR');
    videoResult = await youtube.nextPage();
    videoResult.forEach((element) {
      if (mounted) {
        setState(() {
          _youtubeLinks.add(element.title);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
          searchBackgroundColor: Colors.grey,
          title: Text(AppLocalizations.of(context)!.addYoutubeLink),
          isFloating: false,
          onSearch: (value) {
            callAPI(value).then((value) => null);
          },
          asyncSuggestions: (value) async {
            return _youtubeLinks;
          },
          searchHintText: AppLocalizations.of(context)!.addspotify,
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
                            await FirestoreHelper.addYoutubeListItem(
                                    videoResult[_youtubeLinks.indexOf(value)]
                                        .url
                                        .toString())
                                .then((value) {
                              if (value) {
                                getAllYoutubeList();
                                Navigator.pop(context);
                              } else {
                                getAllYoutubeList();
                                Fluttertoast.showToast(
                                    msg: "Error video not added");
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
            isLoaded
                ? Expanded(
                    child: RefreshIndicator(
                    onRefresh: () async => getAllYoutubeList(),
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _savedVideoResult.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                                height: 50,
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 100,
                                      child: imagess.Image(
                                          image: CachedNetworkImageProvider(
                                              _savedVideoResult[index]
                                                  .thumbnailUrl
                                                  .toString())),
                                    ),
                                    Text(
                                      _savedVideoResult[index]
                                                  .title
                                                  .toString()
                                                  .length >=
                                              15
                                          ? _savedVideoResult[index]
                                              .title
                                              .toString()
                                              .substring(0, 15)
                                          : _savedVideoResult[index]
                                              .title
                                              .toString(),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          FirestoreHelper.removeYoutubeListItem(
                                                  _savedVideoResult[index]
                                                      .url
                                                      .toString())
                                              .then((value) {
                                            setState(() {
                                              _savedVideoResult.remove(index);
                                              _savedYoutubeLinks.remove(index);
                                              isLoaded = false;
                                            });
                                            value
                                                ? getAllYoutubeList()
                                                : (print("false"));
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )),
                          );
                        }),
                  ))
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
