import 'dart:convert';

import 'package:app_store/global_variables.dart';
import 'package:app_store/models/banner_model.dart';
import 'package:http/http.dart' as http;

class BannerController {

  // fetch banners
  Future<List<BannerModel>> loadBanners () async {
    try {
      // send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'), 
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );
      print(response.body);
      if(response.statusCode == 200) { // OK
        final List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners = data.map((banner) => BannerModel.fromJson(banner)).toList();

        return banners;
      } else {
        // throw an execption if the server responsed with an error status code
        throw Exception('Failed to load Banners');
      }
    } catch(e) {
        throw Exception('Error loading Banners $e');
    }
  }
}