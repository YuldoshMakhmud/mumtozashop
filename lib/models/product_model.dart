import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProductModel {
  String nameProduct;
  String descriptionProduct;
  String imageProduct;
  int old_price_Product;
  int new_price_Product;
  String categoryProduct;
  String idProduct;
  int maxQuantityProduct;

  ProductModel({
    required this.nameProduct,
    required this.descriptionProduct,
    required this.imageProduct,
    required this.old_price_Product,
    required this.new_price_Product,
    required this.categoryProduct,
    required this.idProduct,
    required this.maxQuantityProduct,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String docID) {
    return ProductModel(
      nameProduct: json["name"] ?? "",
      descriptionProduct: json["desc"] ?? "no description",
      imageProduct: json["image"] ?? "",
      new_price_Product: json["new_price"] ?? 0,
      old_price_Product: json["old_price"] ?? 0,
      categoryProduct: json["category"] ?? "",
      maxQuantityProduct: json["quantity"] ?? 0,
      idProduct: docID ?? "",
    );
  }
  String get formattedOldPrice {
    return NumberFormat(
      '#,###',
      'en_US',
    ).format(old_price_Product).replaceAll(',', ' ');
  }

  String get formattedNewPrice {
    return NumberFormat(
      '#,###',
      'en_US',
    ).format(new_price_Product).replaceAll(',', ' ');
  }

  static List<ProductModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
          (product) => ProductModel.fromJson(
            product.data() as Map<String, dynamic>,
            product.id,
          ),
        )
        .toList();
  }
}
