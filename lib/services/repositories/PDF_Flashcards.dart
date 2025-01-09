import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> uploadPdf(File pdfFile, int quantity, int difficulty) async {
  var uri = Uri.parse('http://192.168.56.1:5000/generate-flashcards'); // Replace with your local IP
  var request = http.MultipartRequest('POST', uri);

  request.files.add(await http.MultipartFile.fromPath('file', pdfFile.path));
  request.fields['quantity'] = quantity.toString();
  request.fields['difficulty'] = difficulty.toString();

  var response = await request.send();

  if (response.statusCode == 200) {
    final responseData = await http.Response.fromStream(response);
    print('Flashcards: ${responseData.body}');
  } else {
    print('Failed to upload PDF: ${response.reasonPhrase}');
  }
}
