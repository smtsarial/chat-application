import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  static String invit1e = "invitedby";

  Future<Uri>? createDynamicLink(String invite, String? id) async {
    print("DeepLink createDynamicLink: $id");

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://anonmy.page.link',
      link: Uri.parse("https://anonmy.page.link/?$invite=$id"),
      androidParameters: AndroidParameters(
        packageName: "com.anonmy.anonmy",
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.anonmy.anonmy",
        minimumVersion: '1',
      ),
    );

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri uri = shortDynamicLink.shortUrl;
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

  static listenDynamicLink() async {
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
