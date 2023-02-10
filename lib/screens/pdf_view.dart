import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:customer/utils/theme.dart';
import 'package:flutter/material.dart';
class PdfView extends StatefulWidget {
  final String url;

  const PdfView({Key key, this.url}) : super(key: key);
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.url);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Viewer"),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(backgroundColor: primary,))
              : PDFViewer(document: document)),
    );
  }
}
