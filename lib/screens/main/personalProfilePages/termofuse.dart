import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermOfUse extends StatelessWidget {
  TermOfUse({Key? key}) : super(key: key);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Term Of Use'),
        ),
        body: Container(
            child: SfPdfViewer.network(
          'https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/Terms%20Of%20Use.pdf?alt=media&token=8d2ef168-2108-401a-ae31-6acbe2730798',
          pageLayoutMode: PdfPageLayoutMode.single,
          key: _pdfViewerKey,
        )));
  }
}
