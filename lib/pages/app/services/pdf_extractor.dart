import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

String extract_text(File file) {
  //Load an existing PDF document.
  final PdfDocument document =
      PdfDocument(inputBytes: file.readAsBytesSync());
//Extract the text from all the pages.
  String text = PdfTextExtractor(document).extractText();
//Dispose the document.
  document.dispose();
  print(text);
  return text;
}