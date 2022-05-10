import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:io';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

const String testID = 'shuffle_60';

class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  // Instantiates inAppPurchase
  final InAppPurchase _iap = InAppPurchase.instance;

  // checks if the API is available on this device
  bool _isAvailable = false;

  // keeps a list of products queried from Playstore or app store
  List<ProductDetails> _products = [];

  // List of users past purchases
  List<PurchaseDetails> _purchases = [];

  // subscription that listens to a stream of updates to purchase details
  late StreamSubscription _subscription;

  // used to represents consumable credits the user can buy
  int _coins = 0;

  Future<void> _initialize() async {
    // Check availability of InApp Purchases
    _isAvailable = await _iap.isAvailable();

    // perform our async calls only when in-app purchase is available
    if (_isAvailable) {
      await _getUserProducts();
      _verifyPurchases();

      // listen to new purchases and rebuild the widget whenever
      // there is a new purchase after adding the new purchase to our
      // purchase list

      _subscription = _iap.purchaseStream.listen((data) => setState(() {
            _purchases.addAll(data);
            _verifyPurchases();
          }));
    }
  }

  // Method to retrieve product list
  Future<void> _getUserProducts() async {
    Set<String> ids = {testID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  // checks if a user has purchased a certain product
  PurchaseDetails _hasUserPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID);
  }

  // Method to check if the product has been purchased already or not.
  void _verifyPurchases() {
    PurchaseDetails purchase = _hasUserPurchased(testID);
    if (purchase.status == PurchaseStatus.purchased) {
      _coins = 10;
    }
  }

  // Method to purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  void spendCoins(PurchaseDetails purchase) async {
    setState(() {
      _coins--;
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    // cancelling the subscription
    _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isAvailable ? 'Product Available' : 'No Product Available'),
      ),
      body: Center(
        child: Column(
          children: [
            // Looping over products from app store or Playstore
            // for each product, determine if the user has a past purchase for it
            for (var product in _products)

              // If purchase exists
              if (_hasUserPurchased(product.id) != null) ...[
                Text(
                  '$_coins',
                  style: const TextStyle(fontSize: 30),
                ),
                ElevatedButton(
                    onPressed: () => spendCoins(_hasUserPurchased(product.id)),
                    child: const Text('Consume')),
              ]

              // If not purchased exist
              else ...[
                Text(
                  product.title,
                ),
                Text(product.description),
                Text(product.price),
                ElevatedButton(
                    onPressed: () => _buyProduct(product),
                    child: const Text(''))
              ]
          ],
        ),
      ),
    );
  }
}
