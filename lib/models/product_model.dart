// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    String id;
    String name;
    String serialNumber;
    String img;
    int num;
    String status;

    ProductModel({
        required this.id,
        required this.name,
        required this.serialNumber,
        required this.img,
        required this.num,
        required this.status,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        name: json["name"],
        serialNumber: json["serialNumber"],
        img: json["img"],
        num: json["num"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "serialNumber": serialNumber,
        "img": img,
        "num": num,
        "status": status,
    };
}
