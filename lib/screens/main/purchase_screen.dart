import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
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
                    backgroundImage: CachedNetworkImageProvider(
                        context.watch<UserProvider>().user.profilePictureUrl),
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
                  "Get to the Top!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You can show your profile at the top of the Shuffle and get more messages!",
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
                            border: Border.all(
                                color: Color.fromARGB(255, 53, 167, 0),
                                width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Icon(FontAwesomeIcons.crown,
                                    color: Colors.yellow),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("VIP Badge"),
                                  Text(
                                    "60 Minutes",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                        border: Border.all(
                            color: Color.fromARGB(255, 53, 167, 0), width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Popular"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "45 Minutes",
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
                        border: Border.all(
                            color: Color.fromARGB(255, 53, 167, 0), width: 5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Most Popular"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "30 Minutes",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺29,99")
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
                        border: Border.all(
                            color: Color.fromARGB(255, 53, 167, 0), width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Fast"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "15 Minutes",
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
                  "Get more views from Stories!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You can show your profile at the top of the Story and get more messages and views!",
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
                        border: Border.all(
                            color: Color.fromARGB(255, 53, 167, 0), width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Popular"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "1000 Views",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("₺99,99")
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
                        border: Border.all(
                            color: Color.fromARGB(255, 53, 167, 0), width: 5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Most Popular"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "500 Views",
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
                        border: Border.all(
                            color: Color.fromARGB(255, 53, 167, 0), width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Popular"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "100 Views",
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
