import 'package:app_store/controllers/category_controller.dart';
import 'package:app_store/controllers/subcategory_controller.dart';
import 'package:app_store/models/category.dart';
import 'package:app_store/models/subcategory.dart';
import 'package:app_store/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // A Future that will hold the list of banners once loaded from the API
  late Future<List<CategoryModel>> futureCategories;
  CategoryModel? _selectedCategory;
  List<SubcategoryModel> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();

    // once the categories are loaded process then
    futureCategories.then((categories) {
      // iterate through the categories to find the 'Fashion' category
      for(var category in categories) {
        if(category.name == 'Fashion') {
          // IF 'Fashion' category is found, set it as the selected category
          setState(() {
            _selectedCategory = category;
          });
          // load subcategories for the 'Fashion' category
          _loadSubcategories(category.name);
        }
      }
    });
  }

  //this will load subcategories base on the categoryName
  Future<void> _loadSubcategories(String categoryName) async {
    final subcategories = await _subcategoryController
        .getSubCategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const HeaderWidget(),
      ),
      body: Row(
        children: [
          // left-side - Display categories
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _loadSubcategories(category.name);
                              },
                              title: Text(
                                category.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedCategory == category
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ),
          // Right side - Display selected category details
          Expanded(
              flex: 5,
              child: _selectedCategory != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_selectedCategory!.name,
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.7)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      _selectedCategory!.banner,
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        _subcategories.isNotEmpty
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: _subcategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // 3 cai 1 hang
                                  mainAxisSpacing:
                                      4, // Khoang cach cần giữa mỗi danh mục con theo chiều dọc
                                  crossAxisSpacing: 8, // chieu ngang
                                ),
                                itemBuilder: (context, index) {
                                  final subcategory = _subcategories[index];
                                  return Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200),
                                        child: Center(
                                          child: Image.network(
                                              subcategory.image,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          subcategory.subCategoryName,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  );
                                })
                            : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    'No Sub Categories',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.7
                                      ),
                                        
                                  ),
                                ),
                            )
                      ],
                    )
                  : Container())
        ],
      ),
    );
  }
}
