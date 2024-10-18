import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_flutter_lab_1/models/request_models.dart';
import 'package:mongo_flutter_lab_1/providers/user_provider.dart';
import 'dart:convert';
import 'package:mongo_flutter_lab_1/varibles.dart';
import 'package:provider/provider.dart';

class RequestController {
  // ฟังก์ชันดึงข้อมูลคำขอยืมทั้งหมด
  Future<List<RequesterModel>> getRequests(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/request/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => RequesterModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return [];
    }
  }

  // ฟังก์ชันดึงข้อมูลคำขอคืนทั้งหมด
  Future<List<RequesterModel>> getReturned(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/request/requests/returned'), // Update with your endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => RequesterModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load returned requests');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return [];
    }
  }


  // ฟังก์ชันส่งคำขอยืมอุปกรณ์
  Future<void> sendRequest(BuildContext context, RequesterModel request) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final url = Uri.parse('$apiURL/api/request');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
        body: json.encode(request.toJson()),  // แปลง RequesterModel เป็น JSON
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ส่งคำขอยืมอุปกรณ์สำเร็จ')),
        );
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please login again.')),
        );
      } else {
        throw Exception('Failed to send request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

   // ฟังก์ชันอนุมัติคำขอยืม
  Future<void> approveRequest(BuildContext context, String requestId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final url = Uri.parse('$apiURL/api/request/$requestId/approve');
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
        body: json.encode({"decision": "approved"}), // ระบุ decision เป็น approved
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('คำขอยืมอุปกรณ์ถูกอนุมัติ')),
        );
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please login again.')),
        );
      } else {
        throw Exception('Failed to approve request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // ฟังก์ชันปฏิเสธคำขอยืม
  Future<void> rejectRequest(BuildContext context, String requestId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;

    try {
      final url = Uri.parse('$apiURL/api/request/$requestId/reject');
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Bearer token
        },
        body: json.encode({"decision": "rejected"}), // ระบุ decision เป็น rejected
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('คำขอยืมอุปกรณ์ถูกปฏิเสธ')),
        );
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please login again.')),
        );
      } else {
        throw Exception('Failed to reject request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}