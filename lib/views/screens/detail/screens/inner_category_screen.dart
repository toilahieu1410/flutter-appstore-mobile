import 'package:app_store/controllers/subcategory_controller.dart';
import 'package:app_store/models/category.dart';
import 'package:app_store/models/subcategory.dart';
import 'package:app_store/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:app_store/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const InnerCategoryScreen({super.key, required this.categoryModel});
  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  late Future<List<SubcategoryModel>> _subcategories;
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    super.initState();
    _subcategories = _subcategoryController.getSubCategoriesByCategoryName(widget.categoryModel.name);
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
                'Shop By Subcategories',
                style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.7),
              ),
            ),
              FutureBuilder(
          future: _subcategories, 
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:  CircularProgressIndicator()
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Categories'),
            );
          } else {
            final subcategories = snapshot.data!;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: subcategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8 
            ), 
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return InkWell(
                onTap: () {
                  
                },
                child: Column(
                  children: [
                    Image.network(subcategory.image, height: 50, width: 50,),
                    Text(
                      subcategory.subCategoryName, 
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ], 
                ),
              );
            });
          }
        }),
          ],
        ),
      ),
    );
  }
}
