import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TurkishPrivacyPolicyScreen extends StatelessWidget {
  TurkishPrivacyPolicyScreen({Key? key}) : super(key: key);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Türkçe Gizlilik Politikası'),
        ),
        body: Container(
            child: SfPdfViewer.network(
          'https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/Gizlilik%20Politikas%C4%B1%20(T%C3%BCrk%C3%A7e).pdf?alt=media&token=7f2f6579-5215-47d0-a17c-d5b01b362d48',
          pageLayoutMode: PdfPageLayoutMode.single,
          key: _pdfViewerKey,
        )));
  }
}
