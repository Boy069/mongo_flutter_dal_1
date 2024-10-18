// To parse this JSON data, do
//
//     final requesterModel = requesterModelFromJson(jsonString);

import 'dart:convert';

List<RequesterModel> requesterModelFromJson(String str) => List<RequesterModel>.from(json.decode(str).map((x) => RequesterModel.fromJson(x)));

String requesterModelToJson(List<RequesterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequesterModel {
    String id;
    String requester;
    Product product;
    String status;
    DateTime requestDate;
    DateTime createdAt;
    DateTime updatedAt;
    DateTime approvalDate;

    RequesterModel({
        required this.id,
        required this.requester,
        required this.product,
        required this.status,
        required this.requestDate,
        required this.createdAt,
        required this.updatedAt,
        required this.approvalDate,
    });

    factory RequesterModel.fromJson(Map<String, dynamic> json) => RequesterModel(
        id: json["_id"],
        requester: json["requester"],
        product: Product.fromJson(json["product"]),
        status: json["status"],
        requestDate: DateTime.parse(json["requestDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        approvalDate: DateTime.parse(json["approvalDate"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "requester": requester,
        "product": product.toJson(),
        "status": status,
        "requestDate": requestDate.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "approvalDate": approvalDate.toIso8601String(),
    };
}

class Product {
    String id;
    String name;
    String serialNumber;
    String img;
    int num;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    Product({
        required this.id,
        required this.name,
        required this.serialNumber,
        required this.img,
        required this.num,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        serialNumber: json["serialNumber"],
        img: json["img"],
        num: json["num"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialNumber": serialNumber,
        "img": img,
        "num": num,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
