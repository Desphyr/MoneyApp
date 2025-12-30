import 'dart:convert';
import 'dart:developer';

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
}
