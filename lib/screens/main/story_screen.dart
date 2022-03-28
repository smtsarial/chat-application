import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/story.dart';
import 'package:faker/faker.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/filter_widgets.dart';
import 'package:flutter/material.dart';

import '../../helper.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late List<Story> stories = [];
  late RangeValues _currentRangeValues = RangeValues(18, 65);
  late int _value = 1;
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
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
        child: Column(
          children: [
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("       "),
                Text("Stories"),
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.add_a_photo),
                )
              ],
            )),
            Divider(),
            InkWell(
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
            Divider(),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 9 / 16,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2),
                  itemCount: stories.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Stack(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: PrimaryColor,
                              image: DecorationImage(
                                image: NetworkImage(stories[index].imageUrl),
                                fit: BoxFit.cover,
                              ),
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
                                            image: NetworkImage(
                                                stories[index].imageUrl))
                                        .image,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(stories[index].ownerUsername)
                              ],
                            )),
                      ],
                    );
                  }),
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
