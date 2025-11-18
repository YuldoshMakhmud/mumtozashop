import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mumtozashop/viewModel/cart_view_model.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  CartViewModel cartViewModel = CartViewModel();
  StreamSubscription<QuerySnapshot>? cartStreamSubscription;
  StreamSubscription<QuerySnapshot>? productStreamSubscription;

  List<CartModel> cartItemsList = [];
  List<String> cartUIDsList = [];
  List<ProductModel> productsList = [];

  bool isProgressing = true;

  int totalCost = 0;
  int totalQuantity = 0;

  CartProvider() {
    getCartItemsData();
  }

  @override
  void dispose() {
    declineProvider();

    super.dispose();
  }

  declineProvider() {
    cartStreamSubscription?.cancel();
    productStreamSubscription?.cancel();
  }

  addItemDataToCart(CartModel cartItemData) {
    cartViewModel.saveItemDataToCart(cartItemData: cartItemData);
  }

  getCartItemsData() {
    isProgressing = true;
    cartStreamSubscription?.cancel();
    cartStreamSubscription = cartViewModel.fetchUserCart().listen((snapshot) {
      List<CartModel> cartItemData = CartModel.fromJsonList(snapshot.docs);

      cartItemsList = cartItemData;

      cartUIDsList = [];
      for (int i = 0; i < cartItemsList.length; i++) {
        cartUIDsList.add(cartItemsList[i].productID);
      }

      if (cartItemsList.isNotEmpty) {
        getCartItemsProducts(cartUIDsList);
      }

      isProgressing = false;
      notifyListeners();
    });
  }

  getCartItemsProducts(List<String> uIDsList) {
    productStreamSubscription?.cancel();
    productStreamSubscription = cartViewModel
        .fetchCartItemsProducts(uIDsList)
        .listen((snapshot) {
          List<ProductModel> productsData = ProductModel.fromJsonList(
            snapshot.docs,
          );
          productsList = productsData;
          isProgressing = false;

          calculateTotalCost(productsList, cartItemsList);

          calculateTotalQuantity();

          notifyListeners();
        });
  }

  calculateTotalCost(
    List<ProductModel> productsList,
    List<CartModel> cartItemsList,
  ) {
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < cartItemsList.length; i++) {
        totalCost +=
            cartItemsList[i].quantity * productsList[i].new_price_Product;
      }
      notifyListeners();
    });
  }

  calculateTotalQuantity() {
    totalQuantity = 0;

    for (int i = 0; i < cartItemsList.length; i++) {
      totalQuantity += cartItemsList[i].quantity;
    }

    notifyListeners();
  }

  deleteItemFromCart(String productID) {
    cartViewModel.removeItemFromCart(docID: productID);

    getCartItemsData();

    notifyListeners();
  }

  decreaseQuantityCount(String productID) async {
    await cartViewModel.decrementQuantityCount(docID: productID);
    notifyListeners();
  }
}
