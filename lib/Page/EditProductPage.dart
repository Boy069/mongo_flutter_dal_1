import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/Widget/customCliper.dart';
import 'package:mongo_flutter_lab_1/controller/product_controller.dart';
import 'package:mongo_flutter_lab_1/models/product_model.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product; // รับ ProductModel ที่จะทำการแก้ไข

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String serialNumber; // เพิ่มฟิลด์สำหรับ Serial Number
  late String img;
  late int num;
  late String status;

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลจาก ProductModel มาแสดงในฟอร์ม
    name = widget.product.name;
    serialNumber = widget.product.serialNumber; // แสดง Serial Number ที่มีอยู่
    img = widget.product.img;
    num = widget.product.num;
    status = widget.product.status;
  }

  // Function to update the product
  Future<void> _updateProduct(BuildContext context, String productId) async {
    final productController = ProductController();
    try {
      final response = await productController.updateProduct(
        context,
        productId,
        name,
        serialNumber, // เพิ่ม Serial Number
        img,
        num,
        status,
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/admin');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('แก้ไขสินค้าเรียบร้อยแล้ว')),
        );
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refresh token expired. Please login again.')),
        );
      }
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
      );
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
                        text: 'แก้ไข',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
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
                            initialValue: name,
                            onSaved: (value) => name = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Serial Number', // เพิ่มฟิลด์สำหรับ Serial Number
                            initialValue: serialNumber,
                            onSaved: (value) => serialNumber = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ลิงก์รูปภาพ',
                            initialValue: img,
                            onSaved: (value) => img = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'จำนวน',
                            initialValue: num.toString(),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => num = int.parse(value!),
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'สถานะ',
                            initialValue: status,
                            onSaved: (value) => status = value!,
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // Call the update function
                                    _updateProduct(context, widget.product.id);
                                  }
                                },
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
                                    'แก้ไข',
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

  // ฟังก์ชันสร้าง TextField สำหรับฟอร์มแก้ไขสินค้า
  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }
}
