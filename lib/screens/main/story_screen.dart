import 'package:anonmy/connections/adhelper.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/story.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/screens/main/story/stories_editor.dart';
import 'package:anonmy/screens/main/storyViewer_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/filter_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late List<Story> stories = [];
  late List<User> users = [];
  late RangeValues _currentRangeValues = RangeValues(18, 65);
  late int _filterGenderValue = 1;
  late String filterCity = "İstanbul";
  late String filterGender = "All";
  late List filterAge = [18, 65];
  int premiumStoryCount = 0;
  static final _kAdIndex = 2;
  late BannerAd _ad;
  bool _isAdLoaded = false;

  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  Future getStories() async {
    await FirestoreHelper.getStoriesForStoryScreen().then((value) {
      value.forEach((element) async {
        List<Story> stor1es = [];
        List<Story> premiumstor1es = [];
        if (DateTime.now().difference(element.createdTime).inHours < 24) {
          await FirestoreHelper.db
              .collection('users')
              .doc(element.ownerId)
              .get()
              .then((value) async {
            User userinfo = await User.fromMap(value.data());
            if (userinfo.userType.contains("story")) {
              //print("premium");
              premiumstor1es.add(element);
              setState(() {
                premiumStoryCount = premiumStoryCount + 1;
              });
            } else {
              //print("notpremium");
              stor1es.add(element);
            }
          });
        }
        setState(() {
          stories.addAll(premiumstor1es);
          stories.addAll(stor1es);
        });
        //print(
        //    "objectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobject");
        //print("2222" + stories.length.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(
          children: [
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    takeStory();
                  },
                  child: Icon(Icons.add_a_photo),
                ),
                Text(
                  AppLocalizations.of(context)!.stories,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    settingModalBottomSheet(context);
                  },
                  child: Icon(Icons.filter_list_rounded),
                ),
              ],
            )),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: stories.length != 0
                    ? RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            stories = [];
                          });
                          getStories();
                        },
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 9 / 16,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2),
                            itemCount: stories.length +
                                (stories.length >= 2
                                    ? _isAdLoaded
                                        ? 1
                                        : 0
                                    : 0),
                            itemBuilder: (BuildContext ctx, index) {
                              if (_isAdLoaded && index == _kAdIndex) {
                                return Container(
                                  child: AdWidget(ad: _ad),
                                  width: _ad.size.width.toDouble(),
                                  height: _ad.size.height.toDouble(),
                                  alignment: Alignment.center,
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StoryViewer(
                                                  imageList: [
                                                    stories[
                                                        _getDestinationItemIndex(
                                                            index)]
                                                  ],
                                                  ownerProfilepicture: stories[
                                                          _getDestinationItemIndex(
                                                              index)]
                                                      .ownerProfilePicture,
                                                  ownerUsername: stories[
                                                          _getDestinationItemIndex(
                                                              index)]
                                                      .ownerUsername,
                                                  //storyDate: stories[
                                                  //        _getDestinationItemIndex(
                                                  //            index)]
                                                  //    .createdTime,
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: PrimaryColor,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  stories[_getDestinationItemIndex(
                                                          index)]
                                                      .imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: index < premiumStoryCount
                                                ? Border.all(
                                                    width: 2.0,
                                                    color: PrimaryColor)
                                                : Border(),
                                            color: index < premiumStoryCount
                                                ? Color.fromARGB(
                                                    88, 251, 255, 0)
                                                : Color.fromARGB(137, 0, 0, 0),
                                          )),
                                      Positioned(
                                          left: 4,
                                          bottom: 10,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: PureColor,
                                                radius: 12,
                                                child: CircleAvatar(
                                                  radius: 11,
                                                  backgroundImage: Image(
                                                    image: CachedNetworkImageProvider(
                                                        stories[_getDestinationItemIndex(
                                                                index)]
                                                            .ownerProfilePicture),
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ).image,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(stories[_getDestinationItemIndex(
                                                              index)]
                                                          .ownerUsername
                                                          .length >
                                                      8
                                                  ? stories[
                                                          _getDestinationItemIndex(
                                                              index)]
                                                      .ownerUsername
                                                      .substring(0, 8)
                                                  : stories[
                                                          _getDestinationItemIndex(
                                                              index)]
                                                      .ownerUsername)
                                            ],
                                          )),
                                    ],
                                  ),
                                );
                              }
                            }),
                      )
                    : Center(
                        child: Text(
                            AppLocalizations.of(context)!.thereisnostories),
                      ))
          ],
        ));
  }

  void settingModalBottomSheet(context1) {
    showModalBottomSheet(
        context: context1,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Column(
                children: [
                  Container(
                    height: 35,
                    decoration: BoxDecoration(color: Colors.grey[800]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _currentRangeValues = RangeValues(18, 65);
                                _filterGenderValue = 1;
                                filterCity = "İstanbul";
                                filterGender = "All";
                                filterAge = [18, 65];
                              });
                            },
                            child: Text(AppLocalizations.of(context)!.reset)),
                        Text(AppLocalizations.of(context)!.filter),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.cancel))
                      ],
                    ),
                  ),
                  Container(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.age,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              filterAge[0].round().toString() +
                                  " - " +
                                  filterAge[1].round().toString(),
                            ),
                          ],
                        ),
                      ),
                      RangeSlider(
                        activeColor: PrimaryColor,
                        inactiveColor: Colors.grey,
                        values: _currentRangeValues,
                        max: 65,
                        min: 18,
                        onChanged: (values) {
                          setState(() {
                            filterAge = [
                              values.start.round(),
                              values.end.round()
                            ];
                            _currentRangeValues = values;
                          });
                        },
                      )
                    ],
                  )),
                  Divider(),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)!.city,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: filterCity,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: TextColor),
                              enabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                            dropdownColor: PrimaryColor,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: TextColor),
                            onChanged: (String? newValue) {
                              setState(
                                () {
                                  filterCity = newValue.toString();
                                },
                              );
                            },
                            items: <String>[
                              'Adana',
                              'Adıyaman',
                              'Afyon',
                              'Ağrı',
                              'Amasya',
                              'Ankara',
                              'Antalya',
                              'Artvin',
                              'Aydın',
                              'Balıkesir',
                              'Bilecik',
                              'Bingöl',
                              'Bitlis',
                              'Bolu',
                              'Burdur',
                              'Bursa',
                              'Çanakkale',
                              'Çankırı',
                              'Çorum',
                              'Denizli',
                              'Diyarbakır',
                              'Edirne',
                              'Elazığ',
                              'Erzincan',
                              'Erzurum',
                              'Eskişehir',
                              'Gaziantep',
                              'Giresun',
                              'Gümüşhane',
                              'Hakkari',
                              'Hatay',
                              'Isparta',
                              'Mersin',
                              'İstanbul',
                              'İzmir',
                              'Kars',
                              'Kastamonu',
                              'Kayseri',
                              'Kırklareli',
                              'Kırşehir',
                              'Kocaeli',
                              'Konya',
                              'Kütahya',
                              'Malatya',
                              'Manisa',
                              'Kahramanmaraş',
                              'Mardin',
                              'Muğla',
                              'Muş',
                              'Nevşehir',
                              'Niğde',
                              'Ordu',
                              'Rize',
                              'Sakarya',
                              'Samsun',
                              'Siirt',
                              'Sinop',
                              'Sivas',
                              'Tekirdağ',
                              'Tokat',
                              'Trabzon',
                              'Tunceli',
                              'Şanlıurfa',
                              'Uşak',
                              'Van',
                              'Yozgat',
                              'Zonguldak',
                              'Aksaray',
                              'Bayburt',
                              'Karaman',
                              'Kırıkkale',
                              'Batman',
                              'Şırnak',
                              'Bartın',
                              'Ardahan',
                              'Iğdır',
                              'Yalova',
                              'Karabük',
                              'Kilis',
                              'Osmaniye',
                              'Düzce'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      )),
                  Divider(),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(context)!.gender,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyRadioListTile<int>(
                                  value: 1,
                                  groupValue: _filterGenderValue,
                                  leading: 'All',
                                  title: Text(''),
                                  onChanged: (value) => setState(() {
                                    _filterGenderValue = value!;
                                    filterGender = "All";
                                  }),
                                ),
                                MyRadioListTile<int>(
                                  value: 2,
                                  groupValue: _filterGenderValue,
                                  leading: AppLocalizations.of(context)!.male,
                                  title: Text(''),
                                  onChanged: (value) => setState(() {
                                    _filterGenderValue = value!;
                                    filterGender = "Male";
                                  }),
                                ),
                                MyRadioListTile<int>(
                                  value: 3,
                                  groupValue: _filterGenderValue,
                                  leading: AppLocalizations.of(context)!.female,
                                  title: Text(''),
                                  onChanged: (value) => setState(() {
                                    _filterGenderValue = value!;
                                    filterGender = "Female";
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    width: 680.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: PrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.applyfilter,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        //debugPrint("Butona tıklandı");
                        //print(filterAge);
                        //print(filterCity);
                        //print(filterGender);
                        FirestoreHelper.getUserData().then((value) {
                          if (value.userType.contains("shuffle")) {
                            updateFilterUserData()
                                .then((value) => Navigator.pop(context));
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please update your account to use filter");
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Future updateFilterUserData() async {
    List<Story> list = [];
    await FirestoreHelper.getStoriesForStoryScreen().then((value) {
      value.forEach((element) {
        if (DateTime.now().difference(element.createdTime).inHours < 24) {
          list.add(element);
        }
      });
    });
    //print(userList.length);

    List<Story> data = list
        .where((element) =>
            element.ownerAge >= filterAge[0] &&
            element.ownerAge <= filterAge[1] &&
            element.ownerCity == filterCity)
        .toList();
    if (filterGender != "All") {
      data =
          data.where((element) => element.ownerGender == filterGender).toList();
    }
    setState(() {
      stories = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    //_ad.dispose();
  }

  Future takeStory() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StoriesEditor(
              giphyKey: 'TyardCfj6AlrGXaPKYwbV493gvskn5EU',
              onDone: (uri) {
                debugPrint(uri);
              },
            )));
  }
}
