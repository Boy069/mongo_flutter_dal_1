import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/controller/RequestController.dart';
import 'package:mongo_flutter_lab_1/models/request_models.dart';

class ApproveRequestsPage extends StatefulWidget {
  const ApproveRequestsPage({Key? key}) : super(key: key);

  @override
  _ApproveRequestsPageState createState() => _ApproveRequestsPageState();
}

class _ApproveRequestsPageState extends State<ApproveRequestsPage> {
  List<RequesterModel> requests = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      // โหลดคำขอจาก API
      final response = await RequestController().getRequests(context);
      setState(() {
        requests = response; // สมมุติว่า response เป็น List<RequesterModel>
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'เกิดข้อผิดพลาดในการโหลดคำขอ: $e';
      });
    }
  }

  Future<void> _approveRequest(String requestId) async {
    try {
      await RequestController().approveRequest(context, requestId);
      // อัปเดตรายการหลังจากอนุมัติสำเร็จ
      _fetchRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถอนุมัติคำขอได้: $e')),
      );
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      await RequestController().rejectRequest(context, requestId);
      // อัปเดตรายการหลังจากปฏิเสธสำเร็จ
      _fetchRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถปฏิเสธคำขอได้: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำขอยืมอุปกรณ์'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // ใช้สีพื้นหลังที่สวยงาม
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0), // เพิ่ม Padding
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return Card(
                      elevation: 4, // ให้ Card มีเงา
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0), // ระยะห่างระหว่าง Card
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(
                            16.0), // Padding ภายใน ListTile
                        title: Text(
                          request.product.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ), // แสดงชื่ออุปกรณ์
                        subtitle: Text(
                          'ID: ${request.product.id}\nผู้ขอ: ${request.requester} - สถานะ: ${request.status}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                // แสดงการยืนยันก่อนอนุมัติ
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('ยืนยันการอนุมัติ'),
                                      content: const Text(
                                          'คุณต้องการอนุมัติคำขอนี้หรือไม่?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('ยกเลิก'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('อนุมัติ'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด dialog
                                            _approveRequest(request.id);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                // แสดงการยืนยันก่อนปฏิเสธ
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('ยืนยันการปฏิเสธ'),
                                      content: const Text(
                                          'คุณต้องการปฏิเสธคำขอนี้หรือไม่?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('ยกเลิก'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('ปฏิเสธ'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด dialog
                                            _rejectRequest(request.id);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
