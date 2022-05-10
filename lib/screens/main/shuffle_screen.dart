import 'dart:async';

import 'package:anonmy/connections/adhelper.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/story.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/filter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'personDetailScreens/user_profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShufflePage extends StatefulWidget {
  const ShufflePage({Key? key}) : super(key: key);

  @override
  State<ShufflePage> createState() => _ShufflePageState();
}

class _ShufflePageState extends State<ShufflePage> {
  late RangeValues _currentRangeValues = RangeValues(18, 65);
  late int _filterGenderValue = 1;
  late String filterCity = "İstanbul";
  late String filterGender = "All";
  late List filterAge = [18, 65];

  late List<Story> stories = [];
  String searchUsername = "";
  bool isLoaded = false;
  List<User> userList = [];

  static final _kAdIndex = 7;
  //late BannerAd _ad;
  bool _isAdLoaded = false;

  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  void initState() {
    if (mounted) {
      getAllUsers().then((value) {
        //_ad = BannerAd(
        //  adUnitId: AdHelper.bannerAdUnitId,
        //  size: AdSize.mediumRectangle,
        //  request: AdRequest(),
        //  listener: BannerAdListener(
        //    onAdLoaded: (_) {
        //      setState(() {
        //        _isAdLoaded = true;
        //      });
        //    },
        //    onAdFailedToLoad: (ad, error) {
        //      // Releases an ad resource when it fails to load
        //      ad.dispose();
//
        //      print(
        //          'Ad load failed (code=${error.code} message=${error.message})');
        //    },
        //  ),
        //);
        //_ad.load();
      });
    }
    super.initState();
  }

  Stream<QuerySnapshot> stream() async* {
    var _stream = FirebaseFirestore.instance
        .collection('users')
        .where("username", isGreaterThanOrEqualTo: searchUsername)
        .snapshots();
    yield* _stream;
  }

  Future getAllUsers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy("userType", descending: true)
        .get()
        .then((value) async {
      List<User> list = [];
      value.docs.forEach((element) {
        list.add(User.fromMap(element));
      });
      await FirestoreHelper.getUserData().then((value) {
        for (int i = 0; i < list.length; i++) {
          if (value.blockedUsers.toList().contains(list[i].email)) {
            list.removeAt(i);
          }
        }
      });
      if (mounted) {
        setState(() {
          userList = list;
          isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    settingModalBottomSheet(context);
                  },
                  child: const Card(
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.filter_list_rounded,
                          )))),
              Expanded(
                child: TextField(
                    onChanged: (value) {
                      List<User> data = userList
                          .where((element) => element.username.contains(value))
                          .toList();
                      if (userList.length != 0) {
                        setState(() {
                          searchUsername = value;
                          userList = data;
                        });
                      } else {
                        getAllUsers();
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: PureColor,
                      ),
                      hintText: AppLocalizations.of(context)!.search,
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: isLoaded
                ? userList.length != 0
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 9 / 11,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                        itemCount: userList.length +
                            (userList.length >= 7
                                ? _isAdLoaded
                                    ? 1
                                    : 0
                                : 0),
                        itemBuilder: (BuildContext ctx, index) {
                          if (_isAdLoaded && index == _kAdIndex) {
                            return Container(
                              //child: AdWidget(ad: _ad),
                              //width: _ad.size.width.toDouble(),
                              //height: _ad.size.height.toDouble(),
                              alignment: Alignment.center,
                            );
                          } else {
                            return shuffleUserCard(
                                userList[_getDestinationItemIndex(index)]);
                          }
                        })
                    : Text(AppLocalizations.of(context)!.nodata)
                : Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.deepPurple,
                      highlightColor: Colors.white,
                      child: Image.asset(
                        "assets/images/seffaf_renkli.png",
                        height: 100,
                      ),
                    ),
                  ),
          ),
        )
      ],
    );
  }

  Widget shuffleUserCard(User userData) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                      senderData: context.watch<UserProvider>().user,
                      userData: userData)));
        },
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: (() {
                        if (userData.userType == "basic") {
                          return const Color.fromARGB(255, 61, 61, 61);
                        } else if (userData.userType == "z-admin") {
                          return Color.fromARGB(255, 35, 179, 200);
                        } else if (userData.userType.contains("shuffle")) {
                          return PrimaryColor;
                        } else {
                          return const Color.fromARGB(255, 61, 61, 61);
                        }
                      })(),
                      width: 2.5),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 61, 61, 61)
                      : const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 37, 37, 37)
                          : const Color.fromARGB(255, 185, 185, 185)
                              .withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(4, 8), // changes position of shadow
                    )
                  ],
                )),
            Center(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              gradient: userData.myStoriesId.length != 0
                                  ? (LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.blue,
                                        Colors.green,
                                      ],
                                    ))
                                  : (LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.grey,
                                        Colors.grey,
                                      ],
                                    )),
                              shape: BoxShape.circle,
                              color: PrimaryColor,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: Image(
                                image: CachedNetworkImageProvider(
                                    userData.profilePictureUrl),
                              ).image,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: userData.userType.contains('shuffle')
                                ? Icon(FontAwesomeIcons.crown,
                                    color: Colors.yellow)
                                : Container(),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: userData.isActive
                                  ? userData.showStatus
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green,
                                          ),
                                        )
                                      : Container()
                                  : Container()),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData.firstName + " " + userData.lastName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "@" + userData.username,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      userData.showStatus
                          ? userData.isActive
                              ? Container()
                              : Text(timeago.format(userData.lastActiveTime))
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      userData.userBio.isNotEmpty
                          ? (userData.userBio.length > 20
                              ? (Text(
                                  userData.userBio.substring(0, 14) + " ...",
                                ))
                              : Text(userData.userBio))
                          : Text(AppLocalizations.of(context)!.nodescription)
                    ],
                  )),
            )
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
                                  leading: AppLocalizations.of(context)!.all,
                                  title: Text(''),
                                  onChanged: (value) => setState(() {
                                    _filterGenderValue = value!;
                                    filterGender =
                                        AppLocalizations.of(context)!.all;
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
    //print(userList.length);
    List<User> list = [];
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        list.add(User.fromMap(element));
      });
    });
    List<User> data = list
        .where((element) =>
            element.age >= filterAge[0] &&
            element.age <= filterAge[1] &&
            element.city == filterCity)
        .toList();
    if (filterGender != "All") {
      data = data.where((element) => element.gender == filterGender).toList();
    }
    setState(() {
      userList = data;
    });
  }
}
