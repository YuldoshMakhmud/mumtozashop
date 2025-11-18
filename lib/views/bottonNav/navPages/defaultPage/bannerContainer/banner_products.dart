import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mumtozashop/viewModel/common_view_model.dart';
import 'package:mumtozashop/viewModel/product_view_model.dart';

import '../../../../../models/product_model.dart';

class BannerProducts extends StatefulWidget {
  final String categoryName;

  const BannerProducts({super.key, required this.categoryName});

  @override
  State<BannerProducts> createState() => _BannerProductsState();
}

class _BannerProductsState extends State<BannerProducts> {
  ProductViewModel productViewModel = ProductViewModel();
  CommonViewModel commonViewModel = CommonViewModel();

  // Color palette to randomly assign colors for categories
  final List<Color> _colorPalette = [
    Colors.green.shade50,
    Colors.pink.shade50,
    Colors.indigo.shade50,
    Colors.purple.shade50,
    Colors.teal.shade50,
    Colors.deepPurple.shade50,
    Colors.cyan.shade50,
    Colors.blue.shade50,
    Colors.orange.shade50,
    Colors.lime.shade50,
  ];

  // Assign a consistent random color per category based on hash
  Color getRandomColorForCategory(String category) {
    final hash = category.toLowerCase().runes.fold(
      0,
      (prev, char) => prev + char,
    ); // simple hash
    return _colorPalette[hash % _colorPalette.length];
  }

  Widget specialQuote({required int price, required int discountPercentage}) {
    int random = Random().nextInt(2);

    List<String> quotes = [
      "Grab it for just 💲$price",
      "Enjoy discounts of up to $discountPercentage%",
    ];

    return Text(quotes[random], style: const TextStyle(color: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: productViewModel.fetchProducts(widget.categoryName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> products = ProductModel.fromJsonList(
            snapshot.data!.docs,
          );

          if (products.isEmpty) {
            return const Center(child: Text("No Products Found"));
          } else {
            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: getRandomColorForCategory(widget.categoryName),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          //"${widget.categoryName[0].toUpperCase()}${widget.categoryName.substring(1)}",
                          widget.categoryName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/show_specific_products",
                              arguments: {"name": widget.categoryName},
                            );
                          },
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: GridView.count(
                      crossAxisCount: 2,
                      scrollDirection: Axis.horizontal,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      padding: const EdgeInsets.all(8),
                      children: List.generate(
                        products.length > 4 ? 4 : products.length,
                        (i) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/product_details",
                              arguments: products[i],
                            );
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .43,
                            padding: const EdgeInsets.all(8),
                            color: Colors.white,
                            height: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Builder(
                                    builder: (context) {
                                      final imgBytes = base64Decode(
                                        products[i].imageProduct,
                                      );
                                      return Image.memory(
                                        imgBytes,
                                        height: 100,
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  products[i].nameProduct,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 15),
                                ),
                                specialQuote(
                                  price: products[i].new_price_Product,
                                  discountPercentage: int.parse(
                                    commonViewModel.getDiscountPercentage(
                                      products[i].old_price_Product,
                                      products[i].new_price_Product,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return CircularProgressIndicator(color: Colors.green);
        }
      },
    );
  }
}
