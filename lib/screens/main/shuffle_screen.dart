import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedeneme/connections/firestore.dart';
import 'package:firebasedeneme/models/models.dart';
import 'package:firebasedeneme/models/story.dart';
import 'package:firebasedeneme/models/user.dart';

import 'package:firebasedeneme/theme.dart';
import 'package:firebasedeneme/widgets/avatar.dart';
import 'package:faker/faker.dart';
import 'package:firebasedeneme/widgets/filter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';

import '../../helper.dart';
import 'profilePages/profile_screen.dart';

class ShufflePage extends StatefulWidget {
  const ShufflePage({Key? key}) : super(key: key);

  @override
  State<ShufflePage> createState() => _ShufflePageState();
}

class _ShufflePageState extends State<ShufflePage> {
  late RangeValues _currentRangeValues = RangeValues(18, 65);
  late int _value = 1;

  late List<Story> stories = [];

  @override
  void initState() {
    FirestoreHelper.FakeStory().then((value) {
      setState(() {
        stories = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 2),
                child: TextField(
                    style: TextStyle(fontSize: 12.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: PureColor,
                      ),
                      hintText: "Search",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: PrimaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0)),
                    )),
              ),
            ],
          )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: InkWell(
            onTap: () {
              settingModalBottomSheet(context);
            },
            child: Container(
                child: Row(
              children: [
                Icon(Icons.filter_list_rounded),
                SizedBox(
                  width: 5,
                ),
                Text('Filter'),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            )),
          ),
        ),
        Divider(),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 9 / 10,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext ctx, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return shuffleUserCard(User(
                            doc.id,
                            doc["email"],
                            doc["age"],
                            doc["chatCount"],
                            doc["profilePictureUrl"],
                            doc["followers"],
                            doc["followed"],
                            doc["gender"],
                            doc["isActive"],
                            doc["lastActiveTime"].toDate(),
                            doc["firstName"],
                            doc["lastName"],
                            doc["likes"],
                            doc["userBio"],
                            doc["userTags"],
                            doc["userType"],
                            doc["username"],
                            doc["city"],
                            doc["country"]));
                      });
                } else {
                  return Text("No data");
                }
              }),
        ))
      ],
    );
  }

  Widget shuffleUserCard(User userData) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profile()));
        },
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.textDark,
                    borderRadius: BorderRadius.circular(4))),
            Center(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.blue,
                                  Colors.red,
                                ],
                              ),
                              shape: BoxShape.circle,
                              color: PrimaryColor,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: Image(
                                      image: NetworkImage(
                                          userData.profilePictureUrl))
                                  .image,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                          ),
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
                      Text(userData.city),
                      SizedBox(
                        height: 10,
                      ),
                      userData.userBio.isNotEmpty
                          ? (userData.userBio.length > 20
                              ? (Text(
                                  userData.userBio.substring(0, 14) + " ...",
                                  style: TextStyle(),
                                ))
                              : Text(userData.userBio))
                          : Text("No Description")
                    ],
                  )),
            )
          ],
        ));
  }

  Widget userSpecificInformationLayer() {
    return Center(
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Icon(Icons.message),
                  Text(
                    "Messages",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("2030")
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  FaIcon(FontAwesomeIcons.solidThumbsUp),
                  Text(
                    "Followers",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("203")
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                        TextButton(onPressed: () {}, child: Text("Reset")),
                        Text("Filter"),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"))
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
                              "AGE",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _currentRangeValues.start.round().toString() +
                                  " - " +
                                  _currentRangeValues.end.round().toString(),
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
                              "CITY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: "Şehir",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: TextColor),
                              enabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                            dropdownColor: PrimaryColor,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: TextColor),
                            onChanged: (String? newValue) {},
                            validator: (value) {
                              if (value == "Gender") {
                                return 'Please select your gender.';
                              }
                              return null;
                            },
                            items: <String>[
                              'Şehir',
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
                            "GENDER",
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
                                  groupValue: _value,
                                  leading: 'All',
                                  title: Text(''),
                                  onChanged: (value) =>
                                      setState(() => _value = value!),
                                ),
                                MyRadioListTile<int>(
                                  value: 2,
                                  groupValue: _value,
                                  leading: 'Male',
                                  title: Text(''),
                                  onChanged: (value) =>
                                      setState(() => _value = value!),
                                ),
                                MyRadioListTile<int>(
                                  value: 3,
                                  groupValue: _value,
                                  leading: 'Female',
                                  title: Text(''),
                                  onChanged: (value) =>
                                      setState(() => _value = value!),
                                ),
                                MyRadioListTile<int>(
                                  value: 4,
                                  groupValue: _value,
                                  leading: 'Other',
                                  title: Text(''),
                                  onChanged: (value) =>
                                      setState(() => _value = value!),
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
                        "Apply Filter",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        debugPrint("Butona tıklandı");
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
