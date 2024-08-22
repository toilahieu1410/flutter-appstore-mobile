import 'dart:convert';

import 'package:app_store/global_variables.dart';
import 'package:app_store/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductController {
  // Định nghĩa 1 hàm trả về 1 tương lai chứa danh sách các đối tượng mô hình sản phẩm
  Future<List<Product>> loadPopularProducts() async{
    // Sử dụng try catch để xử lý bất kì ngoại lệ nào có thể xảy ra trong quá trình yêu cầu http
    try {
      http.Response response = await http.get(Uri.parse('$uri/api/popular-products'),
      // đặt các http headers cho yêu cầu và cũng xác định rằng nội dung JSON với mã hoá UTF-8
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      // check phản hồi từ HTTP response status code = 00 => yêu cầu thành công

      if(response.statusCode == 200) {
        // Giải mã phản hồi JSON body thành 1 danh sách các đối tượng động
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        // map từng mục trong danh sách thành đối tượng mô hình sản phẩm mà chúng ta có thể sử dụng
      List<Product> products = data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
      return products;
      } else {
      // Nếu trạng thái ko phải là 200 => ném ra 1 ngoại lệ => chỉ ra lỗi khi tải sản phẩm
      throw Exception('Failed to load popular products');

      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  // Tải sản phẩm theo danh mục
  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(Uri.parse('$uri/api/products-by-category/$category'),
       headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if(response.statusCode == 200) {
        // Giải mã phản hồi JSON body thành 1 danh sách các đối tượng động
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        // map từng mục trong danh sách thành đối tượng mô hình sản phẩm mà chúng ta có thể sử dụng
      List<Product> products = data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
      return products;
      } else {
      // Nếu trạng thái ko phải là 200 => ném ra 1 ngoại lệ => chỉ ra lỗi khi tải sản phẩm
      throw Exception('Failed to load popular products');

      }
    } catch (e) {
       throw Exception('Error loading product: $e');
    }
  }


}