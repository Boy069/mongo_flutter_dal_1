import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/controller/auth_controller.dart';
import 'package:mongo_flutter_lab_1/models/product_model.dart';
import 'package:mongo_flutter_lab_1/providers/user_provider.dart';
import 'package:mongo_flutter_lab_1/varibles.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductController {
  final _authController = AuthController();

  // Fetch products from the API
  Future<List<ProductModel>> getProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      // Log the request URL for debugging
      // print('Requesting products from: $apiURL/api/products');

      // Make the GET request
      final response = await http.get(
        Uri.parse('$apiURL/api/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
      );

      // Log the response for debugging
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response and map it to ProductModel objects
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        throw Exception(
            'Refresh token expired. Please login again.'); // เพิ่ม throw Exception
      } else if (response.statusCode == 403) {
        // Refresh token and retry
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await getProducts(context);
      } else {
        throw Exception(
            'Failed to load products with status code: ${response.statusCode}');
      }
    } catch (err) {
      // If the request failed, throw an error
      throw Exception('Failed to load products');
    }
  }

  // Insert product to the API
  Future<http.Response> insertProduct(BuildContext context, String name,
      String img, int num, String status) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    final Map<String, dynamic> insertData = {
      "name": name,
      "img": img,
      "num": num,
      "status": status,
    };

    try {
      // print('Inserting product: $insertData');

      final response = await http.post(
        Uri.parse("$apiURL/api/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(insertData),
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      // Handle successful product insertion
      if (response.statusCode == 201) {
        print("Product inserted successfully!");
        return response; // ส่งคืน response เมื่อเพิ่มสินค้าสำเร็จ
      } else if (response.statusCode == 403) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;

        return await insertProduct(
            context, name, img, num, status);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      // Catch and print any errors during the request
      throw Exception('Failed to insert product');
    }
  }

  // Update product by ID
  Future<http.Response> updateProduct(BuildContext context, String productId,
      String name, String img, int num, String status) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    final Map<String, dynamic> updateData = {
      "name": name,
      "img": img,
      "num": num,
      "status": status,
    };

    try {
      // print('Updating product $productId: $updateData');

      final response = await http.put(
        Uri.parse("$apiURL/api/$productId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(updateData),
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Product updated successfully!");
        return response; // ส่งคืน response
      } else if (response.statusCode == 403) {
        // Refresh the accessToken
        await _authController.refreshToken(context);
        accessToken =
            userProvider.accessToken; // Update the accessToken after refresh

        return await updateProduct(
            context, productId, name, img, num, status);
      } else {
        return response; // ส่งคืน response
      }
    } catch (error) {
      throw Exception('Failed to update product');
    }
  }

  // Delete product by ID
  Future<http.Response> deleteProduct(
      BuildContext context, String productId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      // print('Deleting product: $productId');

      final response = await http.delete(
        Uri.parse("$apiURL/api/$productId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Product deleted successfully!");
        return response;
      } else if (response.statusCode == 403) {
        await _authController.refreshToken(context);
        accessToken = userProvider.accessToken;
        return await deleteProduct(context, productId);
      } else {
        return response;
      }
    } catch (error) {
      // print('Error deleting product: $error');
      throw Exception('Failed to delete product due to error: $error');
    }
  }
}
