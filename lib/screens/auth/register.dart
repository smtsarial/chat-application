import 'dart:io';

import 'package:firebasedeneme/connections/auth.dart';
import 'package:firebasedeneme/connections/firestore.dart';
import 'package:firebasedeneme/screens/main/splash_screen.dart';
import 'package:firebasedeneme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController Surname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController ageController = new TextEditingController();

  TextEditingController usernameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _visibleCircular = false;
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/day-challenge-e7c87.appspot.com/o/test%2Fphoto.png?alt=media&token=c0b743a9-55f7-41ec-86ac-df857a419307";
  late File _image;
  bool _imageload = false;
  late ImagePicker picker;

  bool showPickedImageError = false;

  @override
  void initState() {
    picker = new ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Text(
          "ANON CHAT",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
    );

    final email = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value!.length > 5 &&
            value.contains('@') &&
            value.endsWith('.com')) {
          return null;
        } else {
          return 'Please fill the area with correct mail!';
        }
      },
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final name1 = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final Surname1 = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: Surname,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Surname',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final phone1 = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: phone,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password2 = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: passwordController2,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final username = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        var data = FirestoreHelper.checkUsername(value).then((value1) {
          if (value == null || value.isEmpty) {
            return 'Please fill the area!';
          } else if (value1 != 0) {
            return "Please enter unique username";
          }
          return null;
        });
      },
      controller: usernameController,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final age = TextFormField(
      style: TextStyle(color: TextColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        } else if (int.parse(value) > 65 || int.parse(value) < 18) {
          return "Your age must be between 18-65";
        }
        return null;
      },
      controller: ageController,
      autofocus: false,
      obscureText: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Age',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    String gendervalue = 'Gender';
    final gender = Padding(
        padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: DropdownButtonFormField<String>(
          value: gendervalue,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: TextColor),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          dropdownColor: PrimaryColor,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: TextColor),
          onChanged: (String? newValue) {
            setState(() {
              gendervalue = newValue!;
            });
          },
          validator: (value) {
            if (value == "Gender") {
              return 'Please select your gender.';
            }
            return null;
          },
          items: <String>['Gender', 'Male', 'Female', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));

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

    final profilePicture = Column(
      children: [
        SizedBox(
          height: 40,
        ),
        InkWell(
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
                    backgroundColor: PureColor,
                    radius: 100,
                    child: Icon(Icons.camera_alt, size: 95))),
        SizedBox(
          height: 12,
        ),
        Visibility(
          child: Text(
            "Please select profile picture",
            style: TextStyle(color: Colors.red),
          ),
          visible: showPickedImageError,
        ),
      ],
    );

    final registerButton = Padding(
      padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 140),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          signUpValidation(gendervalue);
        },
        color: PureColor,
        child: _visibleCircular
            ? Visibility(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                ),
                visible: _visibleCircular,
              )
            : Text('Register', style: TextStyle(color: PrimaryColor)),
      ),
    );

    return Scaffold(
      backgroundColor: PrimaryColor,
      appBar: AppBar(
        title: const Text('REGISTER'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          children: [
            Form(
              key: _formKey,
              child: Column(children: <Widget>[
                profilePicture,
                name1,
                SizedBox(
                  height: 8.0,
                ),
                Surname1,
                SizedBox(
                  height: 8.0,
                ),
                username,
                SizedBox(
                  height: 8.0,
                ),
                email,
                SizedBox(height: 8.0),
                gender,
                SizedBox(
                  height: 8.0,
                ),
                age,
                SizedBox(
                  height: 8.0,
                ),
                password,
                SizedBox(height: 8.0),
                password2,
                SizedBox(height: 24.0),
                registerButton,
                SizedBox(height: 24.0),
                Divider(),
                Center(
                  child: Text(
                    "When you register, you will be deemed to have accepted our privacy and KVKK documents.",
                    style: TextStyle(color: TextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.0),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveData(mail) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userUID", mail);
  }

  Future signUpValidation(gendervalue) async {
    if (_imageload != true) {
      setState(() {
        _visibleCircular = false;
        showPickedImageError = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _visibleCircular = true;
      });

      if (passwordController.text == passwordController2.text) {
        await Authentication()
            .signUp(emailController.text, passwordController.text)
            .then((value) => {
                  if (value == true)
                    {
                      if (_imageload != true)
                        {
                          Authentication().deleteAccount().whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Error occured please try again!')),
                            );
                            setState(() {
                              _visibleCircular = false;
                              showPickedImageError = true;
                            });
                          }),
                        }
                      else
                        {
                          FirestoreHelper.uploadProfilePictureToStorage(_image)
                              .then((imageURL) async {
                            if (imageUrl.contains(".com")) {
                              FirestoreHelper.addNewUser(
                                      "",
                                      emailController.text,
                                      int.parse(ageController.text),
                                      0,
                                      imageURL,
                                      [],
                                      [],
                                      gendervalue,
                                      true,
                                      DateTime.now(),
                                      name.text,
                                      Surname.text,
                                      [],
                                      "",
                                      [],
                                      "basic",
                                      usernameController.text)
                                  .then((value) async {
                                if (value == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Başarılı Şekilde Kayıt Olundu')),
                                  );
                                  var _userEmail = await Authentication().login(
                                      emailController.text,
                                      passwordController.text);
                                  await saveData(_userEmail.toString());
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplashScreen()));
                                } else {
                                  Authentication()
                                      .deleteAccount()
                                      .whenComplete(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Error occured please try again!')),
                                    );
                                    setState(() {
                                      _visibleCircular = false;
                                    });
                                  });
                                }
                              });
                            } else {
                              Authentication().deleteAccount().whenComplete(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Error occured please try again!')),
                                );
                                setState(() {
                                  _visibleCircular = false;
                                });
                              });
                            }
                          })
                        }
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error occured please try again!')),
                      ),
                      setState(() {
                        _visibleCircular = false;
                      })
                    }
                });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the same password!')),
        );
        setState(() {
          _visibleCircular = false;
        });
      }
    }
  }
}
