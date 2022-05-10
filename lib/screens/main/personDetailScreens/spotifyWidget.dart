import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpotifyCard extends StatefulWidget {
  const SpotifyCard({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<SpotifyCard> createState() => _SpotifyCardState();
}

class _SpotifyCardState extends State<SpotifyCard> {
  List<SpotifyMetadata> metaData = [];
  bool isLoading = true;
  @override
  void initState() {
    if (mounted) {
      spotifyList().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    metaData;
  }

  Future spotifyList() async {
    await getSpotifyInfo(widget.userData.SpotifyList).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future getSpotifyInfo(spotifyLists) async {
    spotifyLists.forEach((element) async {
      SpotifyApi.getData(element).then((value) {
        if (mounted) {
          setState(() {
            metaData.add(value);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                child: Text(
                  AppLocalizations.of(context)!.spotifylist,
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
                  : metaData.length != 0
                      ? (Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 4),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: metaData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 1, 8, 2),
                                  child: SizedBox(
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: _SpotifyCard(
                                            spotifyData: metaData[index])),
                                  ),
                                );
                              },
                            ),
                          ),
                        ))
                      : (Center(
                          child: Text(
                            AppLocalizations.of(context)!.thereisnomusic,
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
    required this.spotifyData,
  }) : super(key: key);

  final SpotifyMetadata spotifyData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(Uri.parse(spotifyData.providerUrl)))
          throw 'Could not launch $spotifyData';
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            child: Image(
                image: CachedNetworkImageProvider(spotifyData.thumbnailUrl)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                spotifyData.title.length >= 15
                    ? spotifyData.title.substring(0, 15)
                    : spotifyData.title,
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
