import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PdfToImg {
  final String apiKey =
      "emmo1933@gmail.com_Mma8sKP3EFgHSUj1IGWgOUu1qjicMjF7XMJV01T27tcr1EMMDYG61ApulFKD9rmt";
  final String sourceFile;
  final String pages;
  final String password;
  final String outputFileName;

  PdfToImg({
    required this.sourceFile,
    this.pages = '',
    this.password = '',
    required this.outputFileName,
  });

  Future<void> convertPdfToPng() async {
    try {
      final presignedUrlData = await getPresignedUrl();
      final uploadUrl = presignedUrlData[0];
      final uploadedFileUrl = presignedUrlData[1];

      await uploadFile(uploadUrl);
      await startConversion(uploadedFileUrl);
    } catch (e) {
      print("Error: $e");
    }
  } 

  Future<List<String>> getPresignedUrl() async {
    final String url =
        'https://api.pdf.co/v1/file/upload/get-presigned-url?contenttype=application/octet-stream&name=${Uri.encodeComponent(sourceFile)}';
    final response = await http.get(
      Uri.parse(url),
      headers: {'x-api-key': apiKey},
    );

    final data = jsonDecode(response.body);

    if (data['error'] == false) {
      return [data['presignedUrl'], data['url']];
    } else {
      throw Exception('Error getting presigned URL: ${data['message']}');
    }
  }

  Future<void> uploadFile(String uploadUrl) async {
    final fileBytes = await File(sourceFile).readAsBytes();

    final response = await http.put(
      Uri.parse(uploadUrl),
      headers: {"Content-Type": "application/octet-stream"},
      body: fileBytes,
    );

    if (response.statusCode != 200) {
      throw Exception('Error uploading file');
    }
  }

  Future<void> startConversion(String uploadedFileUrl) async {
    final String url =
        'https://api.pdf.co/v1/pdf/convert/to/png?password=$password&pages=$pages&url=$uploadedFileUrl&async=True';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': password,
        'pages': pages,
        'url': uploadedFileUrl,
        'async': true,
      }),
    );

    final data = jsonDecode(response.body);

    if (data['error'] == false) {
      print('Job #${data['jobId']} has been created!');
      await checkIfJobIsCompleted(data['jobId'], data['url']);
    } else {
      throw Exception('Error converting PDF: ${data['message']}');
    }
  }

  Future<void> checkIfJobIsCompleted(String jobId, String resultFileUrl) async {
    final String url = 'https://api.pdf.co/v1/job/check';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'jobid': jobId}),
    );

    final data = jsonDecode(response.body);

    print(
        'Checking Job #$jobId, Status: ${data['status']}, Time: ${DateTime.now().toLocal()}');

    if (data['status'] == 'working') {
      await Future.delayed(const Duration(seconds: 3));
      await checkIfJobIsCompleted(jobId, resultFileUrl);
    } else if (data['status'] == 'success') {
      await downloadResultFiles(resultFileUrl);
    } else {
      print('Operation ended with status: "${data['status']}".');
    }
  }

  Future<void> downloadResultFiles(String resultFileUrl) async {
    final response = await http.get(Uri.parse(resultFileUrl));
    final List<dynamic> fileUrls = jsonDecode(response.body);
    // ignore: unused_local_variable
    int page = 1;

    for (final url in fileUrls) {
      final fileResponse = await http.get(Uri.parse(url));
      final pngFilePath = '${Directory.systemTemp.path}/$outputFileName.png';
      final file = File(pngFilePath);
      await file.writeAsBytes(fileResponse.bodyBytes);
      print('Generated PNG file saved as "$outputFileName.png"');
      page++;
    }
  }
}
