import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseurl = 'http://10.0.2.2:8000/api/';

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseurl$endpoint');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},

    );
    log(response.body);
    return response;
  }
  
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseurl$endpoint');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json','Content-Type': 'application/json'},
      body: jsonEncode(body)
    );
    return response;
  }

  Future<http.Response> postWithFile(String endpoint, Map<String, dynamic> body, File? image) async {
    final url = Uri.parse('$baseurl$endpoint');
    var request = http.MultipartRequest('POST', url);
    
 
    body.forEach((key, value) {
      request.fields[key] = value.toString();
    });
  
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    request.headers['Accept'] = 'application/json';
    
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    return http.Response(respStr, response.statusCode);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseurl$endpoint');
    final response = await http.put(
      url,
      headers: {'Accept': 'application/json','Content-Type': 'application/json'},
      body: jsonEncode(body)
    );
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseurl$endpoint');
    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json'},
    );
    return response;
  }
}
