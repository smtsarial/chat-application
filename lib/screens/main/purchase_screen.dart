import 'dart:async';
import 'dart:io';

import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/consumable_store.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/**/
class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _conectionSubscription;
  final List<String> _productLists = Platform.isAndroid
      ? [
          'shuffle_15',
          'shuffle_30',
          'shuffle_45',
          'shuffle_60',
          "story_15",
          "story_45",
          "story_60"
        ]
      : ['com.cooni.point1000', 'com.cooni.point5000'];

  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getProduct().then((value) {
      print(_items);
    });
    FirestoreHelper.setUserPurchaseActiveStatus().then((value) async {
      await FirestoreHelper.updateMyPurchaseStatus();
    });
  }

  @override
  void dispose() {
    _conectionSubscription.cancel();
    _conectionSubscription.pause();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.

    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion.toString();
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: $productItem');
      //print(productItem);
      if (productItem != null) {
        await FirestoreHelper.getUserData().then((value) {
          FirestoreHelper.db.collection('purchases').add({
            "productId": productItem.productId,
            "date": productItem.transactionDate,
            "active": true,
            "owner": value.email,
            "ownerId": value.id,
            "detail": productItem.toString()
          });
        }).then((value) async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
          );
        });
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error1111: $purchaseError');
    });
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance
        .requestPurchase(item.productId.toString())
        .then((value) async {
      print("**************************************");
      print(value);
      print(_purchases);
    });
  }

  Future _getProduct() async {
    try {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getProducts(_productLists);
      for (var item in items) {
        //print('${item.toString()}');
        this._items.add(item);
      }

      setState(() {
        this._items = items;
        this._purchases = [];
      });
    } catch (e) {
      print(e);
    }
  }

  Future _getPurchases() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

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
                      _requestPurchase(_items[3]);
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
                                  Text(AppLocalizations.of(context)!.vip),
                                  Text(
                                    AppLocalizations.of(context)!.sixty,
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
                  onTap: () {
                    _requestPurchase(_items[2]);
                  },
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
                  onTap: () {
                    _requestPurchase(_items[1]);
                  },
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
                  onTap: () {
                    _requestPurchase(_items[0]);
                  },
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
                  onTap: () {
                    _requestPurchase(_items[6]);
                  },
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
                  onTap: () {
                    _requestPurchase(_items[5]);
                  },
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
                  onTap: () {
                    _requestPurchase(_items[4]);
                  },
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
