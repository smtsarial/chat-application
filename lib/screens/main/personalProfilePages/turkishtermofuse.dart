import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TurkishTermOfUse extends StatelessWidget {
  TurkishTermOfUse({Key? key}) : super(key: key);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Türkçe Kullanım Şartları'),
        ),
        body: Container(
            child: SfPdfViewer.network(
          'https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/Kullan%C4%B1m%20%C5%9Eartlar%C4%B1%20(T%C3%BCrk%C3%A7e).pdf?alt=media&token=0f7a1c29-b869-4dbb-baf6-d6ef2a1f9413',
          pageLayoutMode: PdfPageLayoutMode.single,
          key: _pdfViewerKey,
        )));
  }
}
