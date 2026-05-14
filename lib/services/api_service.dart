import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ApiService {
  static const String url = "https://task.itprojects.web.id";

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$url/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }
  static Future<List<Product>> getProducts(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$url/api/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);
    final List products = data['data']['products'];

    return products.map((e) => Product.fromJson(e)).toList();
  }

  static Future<bool> addProduct(
    String token,
    String name,
    String price,
    String description,
  ) async {
    final response = await http.post(
      Uri.parse('$url/api/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal Menambahkan Produk');
    }
  }

  static Future<bool> submitTugas(
    String token,
    String name,
    int price,
    String description,
    String githubUrl,
  ) async {
    final response = await http.post(
      Uri.parse('$url/api/products/submit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal Submit Tugas');
    }
  }
}