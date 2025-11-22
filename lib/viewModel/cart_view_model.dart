import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_model.dart';

class CartViewModel {

  saveItemDataToCart({required CartModel cartItemData}) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cart")
          .doc(cartItemData.productID)
          .update({
            "product_id": cartItemData.productID,
            "quantity": FieldValue.increment(1),
          });
    } on FirebaseException catch (error) {

      print("Error Message = " + error.code);

      if (error.code == "not-found") {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("cart")
            .doc(cartItemData.productID)
            .set({
              "product_id": cartItemData.productID,
              "quantity": 1,
            });
      }
    }
  }

  Stream<QuerySnapshot> fetchUserCart() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .snapshots();
  }

  Stream<QuerySnapshot> fetchCartItemsProducts(List<String> documentIDs) {
    return FirebaseFirestore.instance
        .collection("products")
        .where(FieldPath.documentId, whereIn: documentIDs)
        .snapshots();
  }

  removeItemFromCart({required String docID}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(docID)
        .delete();
  }

  decrementQuantityCount({required String docID}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(docID)
        .update({
          "quantity": FieldValue.increment(-1),
        });
  }

  clearCart() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .get()
        .then((cartItem) {
      for (DocumentSnapshot dSnapshot in cartItem.docs) {
        dSnapshot.reference.delete();
      }
    });
  }

}