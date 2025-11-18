import 'package:flutter/material.dart';
import 'package:mumtozashop/viewModel/category_view_model.dart';
import 'package:mumtozashop/views/widgets/category_btn.dart';

import '../../../../models/category_model.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  CategoryViewModel categoryViewModel = CategoryViewModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoryViewModel.fetchCategories(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.hasData && dataSnapshot.data != null) {
          List<CategoryModel> categoriesList = CategoryModel.fromJsonList(
            dataSnapshot.data!.docs,
          );

          if (categoriesList.isEmpty) {
            return Container();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoriesList
                    .map(
                      (category) => CategoryBtn(
                        imageBase64: category.imageCategory,
                        name: category.nameCategory,
                      ),
                    )
                    .toList(),
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
