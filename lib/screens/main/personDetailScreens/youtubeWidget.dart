import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_metadata/youtube.dart';

class YoutubeCard extends StatefulWidget {
  const YoutubeCard({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
  List<MetaDataModel> metaData = [];
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

  Future spotifyList() async {
    await getYoutubeInfo(widget.userData.myYoutubeVideo).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future getYoutubeInfo(youtubeList) async {
    youtubeList.forEach((element) async {
      print("object");
      YoutubeMetaData.getData(element).then((value) {
        setState(() {
          metaData.add(value);
        });
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
                  "Youtube List",
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
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: metaData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 1, 8, 2),
                                child: SizedBox(
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: _YoutubeCard(
                                          youtubeData: metaData[index])),
                                ),
                              );
                            },
                          ),
                        ))
                      : (Center(
                          child: Text(
                            "There is no added YouTube video.",
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

class _YoutubeCard extends StatelessWidget {
  const _YoutubeCard({
    Key? key,
    required this.youtubeData,
  }) : super(key: key);

  final MetaDataModel youtubeData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(Uri.parse(youtubeData.url.toString())))
          throw 'Could not launch $youtubeData';
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 120,
            child: Image(
                image: CachedNetworkImageProvider(
                    youtubeData.thumbnailUrl.toString())),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                youtubeData.title.toString().length >= 10
                    ? (youtubeData.title.toString()).substring(0, 15)
                    : youtubeData.title.toString(),
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
