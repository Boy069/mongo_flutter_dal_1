import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/Widget/customCliper.dart';
import 'package:mongo_flutter_lab_1/controller/product_controller.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController(); // Create ProductController instance
  String productName = '';
  String serialNumber = ''; // เพิ่มฟิลด์สำหรับ Serial Number
  String img = '';
  int num = 0;
  String status = '';

  // แยกฟังก์ชันสำหรับเพิ่มสินค้า
  void _addNewProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // พิมพ์ค่าสำหรับการดีบัก
      print('Adding Product: name=$productName, serialNumber=$serialNumber, img=$img, num=$num, status=$status');

      _productController.insertProduct(
        context,
        productName,
        serialNumber, // เพิ่ม Serial Number
        img,
        num,
        status,
      ).then((response) {
        // ตรวจสอบสถานะการตอบกลับ
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 201) {
          // การดำเนินการเมื่อสำเร็จ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มสินค้าเรียบร้อยแล้ว')),
          );
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (response.statusCode == 401) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Refresh token expired. Please login again.')),
          );
        } else {
          // จัดการกับการตอบกลับข้อผิดพลาดอื่น ๆ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: ${response.statusCode} - ${response.body}')),
          );
        }
      }).catchError((error) {
        // จัดการกับข้อผิดพลาดที่ไม่คาดคิด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE9EFEC),
                          Color(0xffFABC3F),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'เพิ่ม',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้าใหม่',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField(
                            label: 'ชื่อสินค้า',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกชื่อสินค้า';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productName = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Serial Number', // เพิ่มฟิลด์สำหรับ Serial Number
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอก Serial Number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              serialNumber = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ลิงก์รูปภาพ',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกลิงก์รูปภาพ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              img = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'จำนวน',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกจำนวน';
                              }
                              if (int.tryParse(value) == null) {
                                return 'กรุณากรอกจำนวนที่ถูกต้อง';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              num = int.parse(value!);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'สถานะ',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกสถานะ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              status = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _addNewProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff821131),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'บันทึก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/admin'); // เปลี่ยนไปยังหน้าแสดงสินค้า
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(103, 103, 103, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
