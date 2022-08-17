import 'dart:io';
import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/main.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/QuickHelp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnamecontroller = new TextEditingController();
  TextEditingController lastnamecontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  late File _image;
  bool _imageload = false;
  late ImagePicker picker;
  bool _visibleCircular = false;
  String editedCountry = "";
  User userData = emptyUser;

  @override
  void initState() {
    picker = new ImagePicker();
    if (mounted) {
      Authentication().getUser().then((value) {
        FirestoreHelper.getUserData()
            .then((value) => setState((() => userData = value)));
      });
    }
    super.initState();
  }

  Future SelectImageFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          _imageload = true;
          _image = File(value.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.editprofile),
        backgroundColor: PrimaryColor,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    SelectImageFromGallery();
                  },
                  child: _imageload == true
                      ? CircleAvatar(
                          backgroundColor: PureColor,
                          radius: 100,
                          child: CircleAvatar(
                            radius: 95,
                            backgroundImage: Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                        )
                      : CircleAvatar(
                          radius: 95,
                          backgroundImage: CachedNetworkImageProvider(
                              userData.profilePictureUrl),
                        ),
                ),
              ),
              SizedBox(
                height: 9,
              ),
              Center(
                child: Text(AppLocalizations.of(context)!.tapdoedit),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        controller: firstnamecontroller,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: userData.firstName,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        controller: lastnamecontroller,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: userData.lastName,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: userData.email,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        controller: descriptioncontroller,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: userData.userBio.length != 0
                              ? userData.userBio
                              : "Please add description.",
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: DropdownButtonFormField<String>(
                          value: "Şehir",
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          dropdownColor: PrimaryColor,
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              editedCountry = newValue.toString();
                            });
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
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.showmyonlinestatus,
                              style: TextStyle(fontSize: 15),
                            ),
                            CupertinoSwitch(
                                value: userData.showStatus,
                                onChanged: (value) {
                                  try {
                                    FirestoreHelper.db
                                        .collection('users')
                                        .doc(userData.id)
                                        .update({"showStatus": value}).then(
                                            (value) {
                                      Authentication().getUser().then((value) {
                                        FirestoreHelper.getUserData().then(
                                            (value) => setState(
                                                (() => userData = value)));
                                      });
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                })
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            updateUser();
                          },
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: _visibleCircular
                              ? Visibility(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    color: Colors.blueGrey,
                                    strokeWidth: 2,
                                  ),
                                  visible: _visibleCircular,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.update,
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                        ),
                      ],
                    )
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  Future updateUser() async {
    setState(() {
      _visibleCircular = true;
    });
    if (_imageload != true) {
      FirebaseFirestore.instance.collection('users').doc(userData.id).update({
        "firstName": firstnamecontroller.text.isEmpty
            ? userData.firstName
            : firstnamecontroller.text,
        "lastName": lastnamecontroller.text.isEmpty
            ? userData.lastName
            : lastnamecontroller.text,
        "userBio": descriptioncontroller.text.isEmpty
            ? userData.userBio
            : descriptioncontroller.text,
        "city": editedCountry == "" ? userData.country : editedCountry,
      }).then((value) {
        setState(() {
          _visibleCircular = false;
        });

        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: "ERROR",
          message: "Profile updated successfully except profile picture!",
          isError: true,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      });
      setState(() {
        _visibleCircular = false;
      });
    } else {
      await FirestoreHelper.uploadProfilePictureToStorage(_image).then((value) {
        if (value.contains(".com")) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userData.id)
              .update({
            "firstName": firstnamecontroller.text.isEmpty
                ? userData.firstName
                : firstnamecontroller.text,
            "lastName": lastnamecontroller.text.isEmpty
                ? userData.lastName
                : lastnamecontroller.text,
            "userBio": descriptioncontroller.text.isEmpty
                ? userData.userBio
                : descriptioncontroller.text,
            "city": editedCountry == "" ? userData.country : editedCountry,
            "profilePictureUrl": value
          }).then((value) {
            setState(() {
              _visibleCircular = false;
            });
            QuickHelp.showAppNotificationAdvanced(
              context: context,
              title: "Successfully",
              message: "Profile updated successfully",
              isError: false,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          });
        } else {
          QuickHelp.showAppNotificationAdvanced(
            context: context,
            title: "Not Successfully",
            message: "Profile not updated successfully",
            isError: true,
          );
        }
      });
    }
  }

  Future<void> saveData(data) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userMail", data);

    setState(() {});
  }
}
