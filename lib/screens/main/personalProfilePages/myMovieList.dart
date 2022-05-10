import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/widgets/seach_Bar/easy_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youtube_metadata/youtube_metadata.dart';
import 'package:flutter/src/widgets/image.dart' as imagess;
import 'package:tmdb_api/tmdb_api.dart';

class MovieInfo {
  final String id;
  final String title;
  final String imageUrl;

  MovieInfo(
    this.id,
    this.title,
    this.imageUrl,
  );
}

class myMovieList extends StatefulWidget {
  const myMovieList({Key? key}) : super(key: key);

  @override
  State<myMovieList> createState() => _myMovieListState();
}

class _myMovieListState extends State<myMovieList> {
  //394fa7228e1dfa390c0d581873d61b1b
  bool isLoaded = false;
  final tmdbWithCustomLogs = TMDB(
      ApiKeys('394fa7228e1dfa390c0d581873d61b1b', 'apiReadAccessTokenv4'),
      defaultLanguage: 'tr-TR');

  List _seachedMovieList = [];
  List<String> _movieNames = [];
  List _savedMovies = [];
  Future seachMovie(query) async {
    await tmdbWithCustomLogs.v3.search.queryMovies(query).then((value) {
      setState(() {
        _seachedMovieList = value['results'];
      });
    });
  }

  Future getAllMovie() async {
    setState(() {
      isLoaded = false;
      _savedMovies.clear();
    });
    FirestoreHelper.getUserData().then((value) {
      value.MovieList.forEach((element) async {
        await tmdbWithCustomLogs.v3.movies
            .getDetails(int.parse(element))
            .then((value) {
          print(value);
          setState(() {
            _savedMovies.add(value);
          });
        });
      });
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  void initState() {
    getAllMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
          searchBackgroundColor: Colors.grey,
          title: Text(AppLocalizations.of(context)!.addmovielink),
          isFloating: false,
          asyncSuggestions: (value) async {
            return await _movieNames;
          },
          onSearch: (value) {
            seachMovie(value).then((value) {
              setState(() {
                _movieNames.clear();
              });
              _seachedMovieList.forEach((element) {
                setState(() {
                  _movieNames.add(element['title']);
                });
              });
            });
          },
          searchHintText: AppLocalizations.of(context)!.addspotify,
          onSuggestionTap: (value) async {
            print(_movieNames.indexOf(value));
            print(_seachedMovieList[_movieNames.indexOf(value)]);
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
                            FirestoreHelper.addMovieListItem(_seachedMovieList[
                                        _movieNames.indexOf(value)]['id']
                                    .toString())
                                .then((value) {
                              if (value == true) {
                                Fluttertoast.showToast(
                                    msg: "Added successfully");
                              } else {
                                Fluttertoast.showToast(msg: "Error occured!");
                              }
                              getAllMovie();
                              Navigator.pop(context);
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
                    onRefresh: () async => getAllMovie(),
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _savedMovies.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                                height: 150,
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        height: 300,
                                        width: 100,
                                        child: imagess.Image(
                                          image: CachedNetworkImageProvider(
                                              _savedMovies[index]
                                                          ['poster_path'] !=
                                                      null
                                                  ? ("https://image.tmdb.org/t/p/w500" +
                                                          _savedMovies[index][
                                                                  'poster_path']
                                                              .toString())
                                                      .toString()
                                                  : "https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/404.png?alt=media&token=c524408f-e435-4eac-a102-adce5b5a64ee"),
                                        )),
                                    Text(
                                      _savedMovies[index]['title']
                                                  .toString()
                                                  .length >=
                                              15
                                          ? _savedMovies[index]['title']
                                              .toString()
                                              .substring(0, 15)
                                          : _savedMovies[index]['title']
                                              .toString(),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          FirestoreHelper.removeMovieListItem(
                                                  _savedMovies[index]['id']
                                                      .toString())
                                              .then((value) => getAllMovie());
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )),
                          );
                        }),
                  ))
                : (Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.deepPurple,
                      highlightColor: Colors.white,
                      child: Image.asset(
                        "assets/images/seffaf_renkli.png",
                        height: 50,
                      ),
                    ),
                  ))
          ],
        ));
  }
}
