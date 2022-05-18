// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';
import "package:flutter/src/widgets/binding.dart";
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/consumable_store.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  List<String> _kProductIds = <String>[
    "shuffle_60",
    "shuffle_45",
    "shuffle_30",
    "story_60",
    "story_45",
    "story_15",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                child: SvgPicture.asset("assets/svg/rocket.svg"),
                height: 250,
              ),
              Positioned(
                right: 15,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: CachedNetworkImageProvider(context.watch<UserProvider>().user.profilePictureUrl),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.gettothetop,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.youcanshow,
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          )),
          Container(
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("VİP BADGE BUY CLICKED");
                    },
                    child: Container(
                        width: 200,
                        height: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 3), borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Icon(FontAwesomeIcons.crown, color: Colors.yellow),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.vip),
                                  Text(
                                    AppLocalizations.of(context)!.sixty,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("₺89,99")
                                ],
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Container(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 3), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.popular),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.fourtyfive,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺69,99")
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 5), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.mostpopular),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.thirty,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺49,99")
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 3), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.fast),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.fifteen,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺29,99")
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
          Container(),
          Divider(),
          //SECOND PART FOR PURCHASE SCREEN
          SizedBox(
            height: 20,
          ),
          Container(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.getmoreviews,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.youcanshowyourprofile,
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          )),
          Container(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 3), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.popular),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.sixty,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺59,99")
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 5), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.mostpopular),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.fourtyfive,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺39,99")
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 53, 167, 0), width: 3), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.popular),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.fifteen,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺19,99")
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
          Divider()
        ],
      )),
    );
  }
}
