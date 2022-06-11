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

/************************************************************************************************************************** */
//const bool _kAutoConsume = true;
//
//const String _kConsumableId = 'shuffle_15';
//const String _kUpgradeId = 'shuffle_30';
//const String _kSilverSubscriptionId = 'shuffle_45';
//const String _kGoldSubscriptionId = 'shuffle_60';
//const List<String> _kProductIds = <String>[
//  _kConsumableId,
//  _kUpgradeId,
//  _kSilverSubscriptionId,
//  _kGoldSubscriptionId,
//];
//
//class PurchaseScreen extends StatefulWidget {
//  const PurchaseScreen({Key? key}) : super(key: key);
//
//  @override
//  State<PurchaseScreen> createState() => _PurchaseScreenState();
//}
//
//class _PurchaseScreenState extends State<PurchaseScreen> {
//  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//  late StreamSubscription<List<PurchaseDetails>> _subscription;
//  List<String> _notFoundIds = <String>[];
//  List<ProductDetails> _products = <ProductDetails>[];
//  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
//  List<String> _consumables = <String>[];
//  bool _isAvailable = false;
//  bool _purchasePending = false;
//  bool _loading = true;
//  String? _queryProductError;
//
//  @override
//  void initState() {
//    final Stream<List<PurchaseDetails>> purchaseUpdated =
//        _inAppPurchase.purchaseStream;
//    _subscription =
//        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//      _listenToPurchaseUpdated(purchaseDetailsList);
//    }, onDone: () {
//      _subscription.cancel();
//    }, onError: (Object error) {
//      // handle error here.
//    });
//    initStoreInfo();
//    super.initState();
//  }
//
//  Future<void> initStoreInfo() async {
//    final bool isAvailable = await _inAppPurchase.isAvailable();
//    if (!isAvailable) {
//      setState(() {
//        _isAvailable = isAvailable;
//        _products = <ProductDetails>[];
//        _purchases = <PurchaseDetails>[];
//        _notFoundIds = <String>[];
//        _consumables = <String>[];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    if (Platform.isIOS) {
//      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//          _inAppPurchase
//              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//    }
//
//    final ProductDetailsResponse productDetailResponse =
//        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//    if (productDetailResponse.error != null) {
//      setState(() {
//        _queryProductError = productDetailResponse.error!.message;
//        _isAvailable = isAvailable;
//        _products = productDetailResponse.productDetails;
//        _purchases = <PurchaseDetails>[];
//        _notFoundIds = productDetailResponse.notFoundIDs;
//        _consumables = <String>[];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    if (productDetailResponse.productDetails.isEmpty) {
//      setState(() {
//        _queryProductError = null;
//        _isAvailable = isAvailable;
//        _products = productDetailResponse.productDetails;
//        _purchases = <PurchaseDetails>[];
//        _notFoundIds = productDetailResponse.notFoundIDs;
//        _consumables = <String>[];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    final List<String> consumables = await ConsumableStore.load();
//    setState(() {
//      _isAvailable = isAvailable;
//      _products = productDetailResponse.productDetails;
//      _notFoundIds = productDetailResponse.notFoundIDs;
//      _consumables = consumables;
//      _purchasePending = false;
//      _loading = false;
//    });
//  }
//
//  @override
//  void dispose() {
//    if (Platform.isIOS) {
//      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//          _inAppPurchase
//              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//      iosPlatformAddition.setDelegate(null);
//    }
//    _subscription.cancel();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final List<Widget> stack = <Widget>[];
//    if (_queryProductError == null) {
//      stack.add(
//        ListView(
//          children: <Widget>[
//            _buildConnectionCheckTile(),
//            _buildProductList(),
//            _buildConsumableBox(),
//            _buildRestoreButton(),
//          ],
//        ),
//      );
//    } else {
//      stack.add(Center(
//        child: Text(_queryProductError!),
//      ));
//    }
//    if (_purchasePending) {
//      stack.add(
//        Stack(
//          children: const <Widget>[
//            Opacity(
//              opacity: 0.3,
//              child: ModalBarrier(dismissible: false, color: Colors.grey),
//            ),
//            Center(
//              child: CircularProgressIndicator(),
//            ),
//          ],
//        ),
//      );
//    }
//
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('IAP Example'),
//        ),
//        body: Stack(
//          children: stack,
//        ),
//      ),
//    );
//  }
//
//  Card _buildConnectionCheckTile() {
//    if (_loading) {
//      return const Card(child: ListTile(title: Text('Trying to connect...')));
//    }
//    final Widget storeHeader = ListTile(
//      leading: Icon(_isAvailable ? Icons.check : Icons.block,
//          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
//      title:
//          Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
//    );
//    final List<Widget> children = <Widget>[storeHeader];
//
//    if (!_isAvailable) {
//      children.addAll(<Widget>[
//        const Divider(),
//        ListTile(
//          title: Text('Not connected',
//              style: TextStyle(color: ThemeData.light().errorColor)),
//          subtitle: const Text(
//              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//        ),
//      ]);
//    }
//    return Card(child: Column(children: children));
//  }
//
//  Card _buildProductList() {
//    if (_loading) {
//      return const Card(
//          child: ListTile(
//              leading: CircularProgressIndicator(),
//              title: Text('Fetching products...')));
//    }
//    if (!_isAvailable) {
//      return const Card();
//    }
//    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
//    final List<ListTile> productList = <ListTile>[];
//    if (_notFoundIds.isNotEmpty) {
//      productList.add(ListTile(
//          title: Text('[${_notFoundIds.join(", ")}] not found',
//              style: TextStyle(color: ThemeData.light().errorColor)),
//          subtitle: const Text(
//              'This app needs special configuration to run. Please see example/README.md for instructions.')));
//    }
//
//    // This loading previous purchases code is just a demo. Please do not use this as it is.
//    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//    // We recommend that you use your own server to verify the purchase data.
//    final Map<String, PurchaseDetails> purchases =
//        Map<String, PurchaseDetails>.fromEntries(
//            _purchases.map((PurchaseDetails purchase) {
//      if (purchase.pendingCompletePurchase) {
//        _inAppPurchase.completePurchase(purchase);
//      }
//      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//    }));
//    productList.addAll(_products.map(
//      (ProductDetails productDetails) {
//        final PurchaseDetails? previousPurchase = purchases[productDetails.id];
//        return ListTile(
//          title: Text(
//            productDetails.title,
//          ),
//          subtitle: Text(
//            productDetails.description,
//          ),
//          trailing: previousPurchase != null
//              ? IconButton(
//                  onPressed: () => confirmPriceChange(context),
//                  icon: const Icon(Icons.upgrade))
//              : TextButton(
//                  style: TextButton.styleFrom(
//                    backgroundColor: Colors.green[800],
//                    primary: Colors.white,
//                  ),
//                  onPressed: () {
//                    late PurchaseParam purchaseParam;
//
//                    if (Platform.isAndroid) {
//                      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                      // verify the latest status of you your subscription by using server side receipt validation
//                      // and update the UI accordingly. The subscription purchase status shown
//                      // inside the app may not be accurate.
//                      final GooglePlayPurchaseDetails? oldSubscription =
//                          _getOldSubscription(productDetails, purchases);
//
//                      purchaseParam = GooglePlayPurchaseParam(
//                          productDetails: productDetails,
//                          applicationUserName: null,
//                          changeSubscriptionParam: (oldSubscription != null)
//                              ? ChangeSubscriptionParam(
//                                  oldPurchaseDetails: oldSubscription,
//                                  prorationMode:
//                                      ProrationMode.immediateWithTimeProration,
//                                )
//                              : null);
//                    } else {
//                      purchaseParam = PurchaseParam(
//                        productDetails: productDetails,
//                        applicationUserName: null,
//                      );
//                    }
//
//                    if (productDetails.id == _kConsumableId) {
//                      _inAppPurchase.buyConsumable(
//                          purchaseParam: purchaseParam,
//                          autoConsume: _kAutoConsume || Platform.isIOS);
//                    } else {
//                      _inAppPurchase.buyNonConsumable(
//                          purchaseParam: purchaseParam);
//                    }
//                  },
//                  child: Text(productDetails.price),
//                ),
//        );
//      },
//    ));
//
//    return Card(
//        child: Column(
//            children: <Widget>[productHeader, const Divider()] + productList));
//  }
//
//  Card _buildConsumableBox() {
//    if (_loading) {
//      return const Card(
//          child: ListTile(
//              leading: CircularProgressIndicator(),
//              title: Text('Fetching consumables...')));
//    }
//    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
//      return const Card();
//    }
//    const ListTile consumableHeader =
//        ListTile(title: Text('Purchased consumables'));
//    final List<Widget> tokens = _consumables.map((String id) {
//      return GridTile(
//        child: IconButton(
//          icon: const Icon(
//            Icons.stars,
//            size: 42.0,
//            color: Colors.orange,
//          ),
//          splashColor: Colors.yellowAccent,
//          onPressed: () => consume(id),
//        ),
//      );
//    }).toList();
//    return Card(
//        child: Column(children: <Widget>[
//      consumableHeader,
//      const Divider(),
//      GridView.count(
//        crossAxisCount: 5,
//        shrinkWrap: true,
//        padding: const EdgeInsets.all(16.0),
//        children: tokens,
//      )
//    ]));
//  }
//
//  Widget _buildRestoreButton() {
//    if (_loading) {
//      return Container();
//    }
//
//    return Padding(
//      padding: const EdgeInsets.all(4.0),
//      child: Row(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          TextButton(
//            style: TextButton.styleFrom(
//              backgroundColor: Theme.of(context).primaryColor,
//              primary: Colors.white,
//            ),
//            onPressed: () => _inAppPurchase.restorePurchases(),
//            child: const Text('Restore purchases'),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Future<void> consume(String id) async {
//    await ConsumableStore.consume(id);
//    final List<String> consumables = await ConsumableStore.load();
//    setState(() {
//      _consumables = consumables;
//    });
//  }
//
//  void showPendingUI() {
//    setState(() {
//      _purchasePending = true;
//    });
//  }
//
//  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//    // IMPORTANT!! Always verify purchase details before delivering the product.
//    if (purchaseDetails.productID == _kConsumableId) {
//      await ConsumableStore.save(purchaseDetails.purchaseID!);
//      final List<String> consumables = await ConsumableStore.load();
//      setState(() {
//        _purchasePending = false;
//        _consumables = consumables;
//      });
//    } else {
//      setState(() {
//        _purchases.add(purchaseDetails);
//        _purchasePending = false;
//      });
//    }
//  }
//
//  void handleError(IAPError error) {
//    setState(() {
//      _purchasePending = false;
//    });
//  }
//
//  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//    // IMPORTANT!! Always verify a purchase before delivering the product.
//    // For the purpose of an example, we directly return true.
//    return Future<bool>.value(true);
//  }
//
//  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//    // handle invalid purchase here if  _verifyPurchase` failed.
//  }
//
//  Future<void> _listenToPurchaseUpdated(
//      List<PurchaseDetails> purchaseDetailsList) async {
//    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//      if (purchaseDetails.status == PurchaseStatus.pending) {
//        showPendingUI();
//      } else {
//        if (purchaseDetails.status == PurchaseStatus.error) {
//          handleError(purchaseDetails.error!);
//        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//            purchaseDetails.status == PurchaseStatus.restored) {
//          final bool valid = await _verifyPurchase(purchaseDetails);
//          if (valid) {
//            deliverProduct(purchaseDetails);
//          } else {
//            _handleInvalidPurchase(purchaseDetails);
//            return;
//          }
//        }
//        if (Platform.isAndroid) {
//          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//            final InAppPurchaseAndroidPlatformAddition androidAddition =
//                _inAppPurchase.getPlatformAddition<
//                    InAppPurchaseAndroidPlatformAddition>();
//            await androidAddition.consumePurchase(purchaseDetails);
//          }
//        }
//        if (purchaseDetails.pendingCompletePurchase) {
//          await _inAppPurchase.completePurchase(purchaseDetails);
//        }
//      }
//    }
//  }
//
//  Future<void> confirmPriceChange(BuildContext context) async {
//    if (Platform.isAndroid) {
//      final InAppPurchaseAndroidPlatformAddition androidAddition =
//          _inAppPurchase
//              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//      final BillingResultWrapper priceChangeConfirmationResult =
//          await androidAddition.launchPriceChangeConfirmationFlow(
//        sku: 'purchaseId',
//      );
//      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//          content: Text('Price change accepted'),
//        ));
//      } else {
//        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//          content: Text(
//            priceChangeConfirmationResult.debugMessage ??
//                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
//          ),
//        ));
//      }
//    }
//    if (Platform.isIOS) {
//      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
//          _inAppPurchase
//              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//    }
//  }
//
//  GooglePlayPurchaseDetails? _getOldSubscription(
//      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//    // This is just to demonstrate a subscription upgrade or downgrade.
//    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//    // Please remember to replace the logic of finding the old subscription Id as per your app.
//    // The old subscription is only required on Android since Apple handles this internally
//    // by using the subscription group feature in iTunesConnect.
//    GooglePlayPurchaseDetails? oldSubscription;
//    if (productDetails.id == _kSilverSubscriptionId &&
//        purchases[_kGoldSubscriptionId] != null) {
//      oldSubscription =
//          purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
//    } else if (productDetails.id == _kGoldSubscriptionId &&
//        purchases[_kSilverSubscriptionId] != null) {
//      oldSubscription =
//          purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
//    }
//    return oldSubscription;
//  }
//}
//
///// Example implementation of the
///// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
/////
///// The payment queue delegate can be implementated to provide information
///// needed to complete transactions.
//class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//  @override
//  bool shouldContinueTransaction(
//      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//    return true;
//  }
//
//  @override
//  bool shouldShowPriceConsent() {
//    return false;
//  }
//}
