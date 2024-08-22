import 'package:app_store/controllers/product_controller.dart';
import 'package:app_store/controllers/subcategory_controller.dart';
import 'package:app_store/models/category.dart';
import 'package:app_store/models/product_model.dart';
import 'package:app_store/models/subcategory.dart';
import 'package:app_store/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:app_store/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:app_store/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:app_store/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:app_store/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final CategoryModel categoryModel;
  const InnerCategoryContentWidget({super.key, required this.categoryModel});

  @override
  State<InnerCategoryContentWidget> createState() => _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState extends State<InnerCategoryContentWidget> {
  late Future<List<SubcategoryModel>> _subcategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    super.initState();
    _subcategories = _subcategoryController
      .getSubCategoriesByCategoryName(widget.categoryModel.name);
    futureProducts = ProductController()
      .loadProductByCategory(widget.categoryModel.name);
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const InnerHeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.categoryModel.banner),
            Center(
              child: Text(
                'Shop by Category',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.7,
                ),
              ),
            ),
            FutureBuilder<List<SubcategoryModel>>(
              future: _subcategories, 
              builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Categories'),
                  );
                } else {
                  final subcategories = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: List.generate(
                        (subcategories.length / 7).ceil(),
                        (setIndex) {
                          final start = setIndex * 7;
                          final end = (setIndex + 1) * 7;
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: subcategories.sublist(
                                start,
                                end > subcategories.length
                                    ? subcategories.length
                                    : end
                              ).map(
                                (subcategory) => SubcategoryTileWidget(
                                  title: subcategory.subCategoryName,
                                  image: subcategory.image,
                                )
                              ).toList(),
                            ),
                          );
                        }
                      ),
                    ),
                  );
                }
              }
            ),
            ReusableTextWidget(title: 'Popular Product', subtitle: 'View all'),
            FutureBuilder<List<Product>>(
              future: futureProducts, 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Products under this category'),
                  );
                } else {
                  final products = snapshot.data!;
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItemWidget(product: product);
                      }
                    ),
                  );
                }
              }
            ),
          ],
        ),
      ),
    );
  }     
  
}