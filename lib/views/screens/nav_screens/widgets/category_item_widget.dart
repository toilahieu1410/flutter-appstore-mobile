
import 'package:app_store/controllers/category_controller.dart';
import 'package:app_store/models/category.dart';
import 'package:app_store/views/screens/detail/screens/inner_category_screen.dart';
import 'package:app_store/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItemWidget extends StatefulWidget {

  const CategoryItemWidget({super.key});

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  // A Future that will hold the list of banners once loaded from the API
  late Future<List<CategoryModel>> futureCategories;
  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReusableTextWidget(title: 'Categories', subtitle: 'View all'),
        FutureBuilder(
          future: futureCategories, 
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
            final categories = snapshot.data!;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8 
            ), 
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) {
                    return InnerCategoryScreen(categoryModel: category);
                  }));
                },
                child: Column(
                  children: [
                    Image.network(category.image, height: 50, width: 50,),
                    Text(
                      category.name, 
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
    );
  }
}