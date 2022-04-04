import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

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
            height: 60,
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 100),
                    padding: const EdgeInsets.fromLTRB(80, 40, 80, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: PrimaryColor, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 100),
                    padding: const EdgeInsets.fromLTRB(80, 40, 80, 40),
                    decoration: BoxDecoration(
                        border: Border.all(color: PrimaryColor, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
          Container(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(45, 60, 45, 60),
                  decoration: BoxDecoration(
                      border: Border.all(color: PrimaryColor, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(45, 60, 45, 60),
                  decoration: BoxDecoration(
                      border: Border.all(color: PrimaryColor, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(45, 60, 45, 60),
                  decoration: BoxDecoration(
                      border: Border.all(color: PrimaryColor, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          )),
          Container(),
          Container()
        ],
      )),
    );
  }
}
