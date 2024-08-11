import 'dart:convert';

import 'package:app_store/global_variables.dart';
import 'package:app_store/models/category.dart';
import 'package:app_store/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  //load the uploaded category

  Future<List<SubcategoryModel>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      // send an http get request to load the categories
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => SubcategoryModel.fromJson(subcategory))
              .toList();
        } else {
          print('sibcategories not found');
          return [];
        }
      } else if (response.statusCode == 404) {
        print('subcategories not found');
          return [];
      } else {
        print('failed to fetch subcategories');
        return [];
      }
    } catch (e) {
      print('error fetching subcategories $e');
      return [];
    }
  }
}
