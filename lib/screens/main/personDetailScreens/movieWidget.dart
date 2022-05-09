import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MovieWidget extends StatefulWidget {
  const MovieWidget({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<MovieWidget> createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  bool isLoading = true;
  List _savedMovies = [];
  final tmdbWithCustomLogs = TMDB(ApiKeys(MOVIE_API, 'apiReadAccessTokenv4'),
      defaultLanguage: 'tr-TR');

  Future getAllMovie() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        _savedMovies.clear();
      });
    }

    widget.userData.MovieList.forEach((element) async {
      await tmdbWithCustomLogs.v3.movies
          .getDetails(int.parse(element))
          .then((value) {
        if (mounted) {
          setState(() {
            _savedMovies.add(value);
          });
        }
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    if (mounted) {
      getAllMovie();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                child: Text(
                  "Movie List",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.textFaded,
                  ),
                ),
              ),
              isLoading
                  ? (Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.deepPurple,
                        highlightColor: Colors.white,
                        child: Image.asset(
                          "assets/images/seffaf_renkli.png",
                          height: 50,
                        ),
                      ),
                    ))
                  : _savedMovies.length != 0
                      ? (Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 4),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _savedMovies.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 1, 8, 2),
                                  child: SizedBox(
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: _SpotifyCard(
                                            savedMovies: _savedMovies[index])),
                                  ),
                                );
                              },
                            ),
                          ),
                        ))
                      : (Center(
                          child: Text(
                            "There is no added movie.",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: AppColors.textFaded,
                            ),
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotifyCard extends StatelessWidget {
  const _SpotifyCard({
    Key? key,
    required this.savedMovies,
  }) : super(key: key);

  final dynamic savedMovies;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            child: Image(
              image: CachedNetworkImageProvider(savedMovies['poster_path'] !=
                      null
                  ? ("https://image.tmdb.org/t/p/w500" +
                          savedMovies['poster_path'].toString())
                      .toString()
                  : "https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/404.png?alt=media&token=c524408f-e435-4eac-a102-adce5b5a64ee"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                savedMovies['title'].length >= 15
                    ? savedMovies['title'].substring(0, 15)
                    : savedMovies['title'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
