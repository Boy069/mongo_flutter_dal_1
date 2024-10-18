import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/controller/RequestController.dart';
import 'package:mongo_flutter_lab_1/models/request_models.dart';

class RequestEquipmentPage extends StatefulWidget {
  const RequestEquipmentPage({Key? key}) : super(key: key);

  @override
  _RequestEquipmentPageState createState() => _RequestEquipmentPageState();
}

class _RequestEquipmentPageState extends State<RequestEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? requester;
  String? productName;
  String? serialNumber;
  String? img;
  int? num;
  String? productStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ส่งคำขอยืมอุปกรณ์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ชื่อผู้ขอ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อผู้ขอ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    requester = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่ออุปกรณ์';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productName = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'หมายเลขอุปกรณ์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกหมายเลขอุปกรณ์';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    serialNumber = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'URL รูปภาพ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอก URL รูปภาพ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    img = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'จำนวนอุปกรณ์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนอุปกรณ์';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณากรอกเป็นตัวเลข';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    num = value != null
                        ? int.tryParse(value)
                        : 0; // ถ้า value เป็น null ให้ค่า default เป็น 0
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'สถานะอุปกรณ์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกสถานะอุปกรณ์';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productStatus = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // สร้าง Product object
                      final product = Product(
                        id: 'generatedId', // ID อาจถูกสร้างโดย backend
                        name: productName!,
                        serialNumber: serialNumber!,
                        img: img!,
                        num: num!,
                        status: productStatus!,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      // สร้าง RequesterModel object
                      final request = RequesterModel(
                        id: 'generatedId', // ID อาจถูกสร้างโดย backend
                        requester: requester!,
                        product: product, // ใส่ Product object ที่สร้าง
                        status: 'pending', // ตั้งสถานะเริ่มต้นเป็น 'pending'
                        requestDate: DateTime.now(),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        approvalDate: DateTime.now(),
                      );

                      // ส่งคำขอไปยังเซิร์ฟเวอร์
                      RequestController().sendRequest(context, request);
                    }
                  },
                  child: const Text('ส่งคำขอ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
