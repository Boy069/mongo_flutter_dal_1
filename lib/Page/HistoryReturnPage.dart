import 'package:flutter/material.dart';
import 'package:mongo_flutter_lab_1/controller/RequestController.dart';
import 'package:mongo_flutter_lab_1/models/request_models.dart';

class HistoryReturnPage extends StatefulWidget {
  const HistoryReturnPage({super.key});

  @override
  _HistoryReturnPageState createState() => _HistoryReturnPageState();
}

class _HistoryReturnPageState extends State<HistoryReturnPage> {
  List<RequesterModel> requests = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReturnedRequests();
  }

  Future<void> _fetchReturnedRequests() async {
    // ตั้งค่าการโหลดเป็นจริงและรีเซ็ตข้อความข้อผิดพลาด
    setState(() {
      isLoading = true; 
      errorMessage = null; 
    });

    try {
      final requestList = await RequestController().getReturned(context);
      setState(() {
        requests = requestList; // อัปเดตรายการคำขอคืน
      });
    } catch (error) {
      setState(() {
        errorMessage = 'เกิดข้อผิดพลาดในการดึงข้อมูลคำขอคืน: $error'; // กำหนดข้อความข้อผิดพลาด
      });
    } finally {
      setState(() {
        isLoading = false; // ตั้งค่าการโหลดเป็นเท็จเมื่อเสร็จสิ้นการเรียกข้อมูล
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการคืน'), // ชื่อแถบด้านบน
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // แสดงสัญลักษณ์การโหลด
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // แสดงข้อความข้อผิดพลาดถ้ามี
              : _buildReturnedRequestList(), // แสดงรายการคำขอคืน
    );
  }

  Widget _buildReturnedRequestList() {
    return ListView.separated(
      itemCount: requests.length, // จำนวนรายการที่จะแสดง
      separatorBuilder: (context, index) => Divider(height: 1), // เพิ่ม Divider ระหว่างรายการ
      itemBuilder: (context, index) {
        final request = requests[index]; // ดึงคำขอที่กำลังแสดง
        return Card(
          elevation: 2, // เพิ่มเงาให้กับ Card
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ตั้งค่าระยะห่างของ Card
          child: ListTile(
            contentPadding: EdgeInsets.all(16), // ตั้งค่าระยะห่างภายใน
            title: Text(
              request.product.name, // แสดงชื่อผลิตภัณฑ์
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('สถานะ: ${request.status}'), // แสดงสถานะคำขอ
                SizedBox(height: 4), // เพิ่มระยะห่างระหว่างข้อความ
                Text(
                  'วันที่คืน: ${request.requestDate.toLocal().toString().split(' ')[0]}', // แสดงวันที่คืนในรูปแบบที่เหมาะสม
                  style: TextStyle(color: Colors.grey[600]), // เปลี่ยนสีข้อความ
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
