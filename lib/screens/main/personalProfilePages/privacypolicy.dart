import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Privacy Policy'),
        ),
        body: Container(
            child: SfPdfViewer.network(
          'https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/Privacy%20Policy.pdf?alt=media&token=5413638e-0b8c-4885-a79f-c3e5102f9411',
          pageLayoutMode: PdfPageLayoutMode.single,
          key: _pdfViewerKey,
        )));
  }
}
