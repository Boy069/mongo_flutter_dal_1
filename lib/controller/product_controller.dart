import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mongo_flutter_lab_1/controller/auth_controller.dart';
import 'package:mongo_flutter_lab_1/models/product_model.dart';
import 'package:mongo_flutter_lab_1/providers/user_provider.dart';
import 'package:mongo_flutter_lab_1/varibles.dart';

class ProductController {
  final _authController = AuthController();

  // Fetch products from the API
  Future<List<ProductModel>> getProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      debugPrint('Requesting products from: $apiURL/api/products');

      // Make the GET request
      final response = await http.get(
        Uri.parse('$apiURL/api/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception('Refresh token expired. Please login again.');
      } else if (response.statusCode == 403) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await getProducts(context);
      } else {
        throw Exception(
            'Failed to load products with status code: ${response.statusCode}');
      }
    } catch (err) {
      debugPrint('Error fetching products: $err');
      throw Exception('Failed to load products');
    }
  }

  // Insert product to the API
  Future<http.Response> insertProduct(BuildContext context, String name,
      String serialNumber, String img, int num, String status) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    final Map<String, dynamic> insertData = {
      "name": name,
      "serialNumber": serialNumber,
      "img": img,
      "num": num,
      "status": status,
    };

    try {
      debugPrint('Inserting product: $insertData');

      final response = await http.post(
        Uri.parse("$apiURL/api/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(insertData),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 201) {
        debugPrint("Product inserted successfully!");
        return response;
      } else if (response.statusCode == 403) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await insertProduct(context, name, serialNumber, img, num, status);
      } else {
        return response;
      }
    } catch (error) {
      debugPrint('Error inserting product: $error');
      throw Exception('Failed to insert product');
    }
  }

  // Update product by ID
  Future<http.Response> updateProduct(BuildContext context, String productId,
      String name, String serialNumber, String img, int num, String status) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      "name": name,
      "serialNumber": serialNumber,
      "img": img,
      "num": num,
      "status": status,
    };

    try {
      debugPrint('Updating product $productId: $updateData');

      final response = await http.put(
        Uri.parse("$apiURL/api/$productId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(updateData),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint("Product updated successfully!");
        return response;
      } else if (response.statusCode == 403) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await updateProduct(context, productId, name, serialNumber, img, num, status);
      } else {
        return response;
      }
    } catch (error) {
      debugPrint('Error updating product: $error');
      throw Exception('Failed to update product');
    }
  }

  // Delete product by ID
  Future<http.Response> deleteProduct(
      BuildContext context, String productId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      debugPrint('Deleting product: $productId');

      final response = await http.delete(
        Uri.parse("$apiURL/api/$productId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint("Product deleted successfully!");
        return response;
      } else if (response.statusCode == 403) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await deleteProduct(context, productId);
      } else {
        return response;
      }
    } catch (error) {
      debugPrint('Error deleting product: $error');
      throw Exception('Failed to delete product due to error: $error');
    }
  }
}
