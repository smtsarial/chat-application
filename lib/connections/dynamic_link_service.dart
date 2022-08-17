import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  static String invit1e = "invitedby";

  Future<Uri>? createDynamicLink(String invite, String? id) async {
    print("DeepLink createDynamicLink: $id");

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://sirenlive.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse("https://sirenlive.page.link/?$invite=$id"),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: AndroidParameters(
        packageName: "com.anonmy.anonmy",
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: IOSParameters(
        bundleId: "com.anonmy.anonmy",
        minimumVersion: '1',
      ),
    );

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri uri = shortDynamicLink.shortUrl;

    //final Uri dynamicLinks = await FirebaseDynamicLinks.instance.buildLink(parameters);
    return uri;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    print("DeepLink retrieveDynamicLink");

    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      Uri? deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey("invitedby")) {
          String? id = deepLink.queryParameters["invitedby"];
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestScreen(id: id);
          print("DeepLink invited by: $id");
        }
      } else {
        print("DeepLink not found");
      }
    } catch (e) {
      print("DeepLink invited by Error: $e");
    }
  }

  static listenDynamicLink() {
    print("DeepLink listenDynamicLink");
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("helllllllllo");
      print(dynamicLinkData.link.toString());
    }).onError((error) {
      // Handle errors
      print(error);
    });
  }
}
