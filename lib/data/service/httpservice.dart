import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = 'http://10.0.2.2:8000/api/';

  Future<http.Response> get(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    log('GET Response: ${response.body}');
    return response;
  }

  Future<http.Response> post(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );
    log('POST Response: ${response.body}');
    return response;
  }

  Future<http.Response> postWithFile(
    String endPoint,
    Map<String, String> fields,
    File? file,
    String fileFieldName,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endPoint');
      final request = http.MultipartRequest('POST', url);

      request.fields.addAll(fields);

      if (file != null) {
        final imageFile = await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        );
        request.files.add(imageFile);
        log('File added: ${file.path}');
      }

      log('POST with File to: $url');
      log('Fields: ${request.fields}');
      log('Files: ${request.files.length}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log('POST with File Response: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('Error in postWithFile: $e');
      rethrow;
    }
  }

  Future<http.Response> put(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );
    log('PUT Response: ${response.body}');
    return response;
  }

  Future<http.Response> delete(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    log('DELETE Response: ${response.body}');
    return response;
  }
}
