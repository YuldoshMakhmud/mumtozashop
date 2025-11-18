import 'package:cloud_firestore/cloud_firestore.dart';

class ProductViewModel {

  addNewProduct({required Map<String, dynamic> dataMap}) async {
    await FirebaseFirestore.instance.collection("products").add(dataMap);
  }

  updateProduct({required String docId, required Map<String, dynamic> dataMap}) async {
    await FirebaseFirestore.instance.collection("products").doc(docId).update(dataMap);
  }

  deleteProduct({required String docId}) async {
    await FirebaseFirestore.instance.collection("products").doc(docId).delete();
  }

  Stream<QuerySnapshot> fetchProducts(String categoryName) {
    return FirebaseFirestore.instance.collection("products").where("category", isEqualTo: categoryName.toLowerCase()).snapshots();
  }

}