import 'package:app_store/controllers/product_controller.dart';
import 'package:app_store/models/product_model.dart';
import 'package:app_store/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

class PopularProductWidget extends StatefulWidget {
  const PopularProductWidget({super.key});

  @override
  State<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends State<PopularProductWidget> {
  // Biến future này chứa danh sách các sản phẩm phổ biến
  late Future<List<Product>> futurePopularProducts;
  @override
  void initState() {
    super.initState();
    futurePopularProducts = ProductController().loadPopularProducts();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: futurePopularProducts, 
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if(snapshot.hasError) {
        return Center(child: Text('Error ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No popular Products'),
        );
      } else {
        final products = snapshot.data;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItemWidget(product: product);
            }
          ),
        );
      }
    });
  }
}