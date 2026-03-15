import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List> fetchCards(String url) async {
    final response = await http.get(Uri.parse(url));

    final data = jsonDecode(response.body);

    return data["template_properties"]["child_list"];
  }
}
