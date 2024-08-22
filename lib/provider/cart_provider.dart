import 'package:app_store/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Định nghĩa trạng thái StateNotifierProvider hiển thị 1 instance của CartNotifier
// làm cho nó có thể truy cập vào trong ứng dụng của mình
final cartProvider = StateNotifierProvider<CartNotifier, Map<String,Cart>> (
  (ref) {
    return CartNotifier();
  }
);
// 1 lớp thông báo (notifier class) để quản lý trạng thái giỏ hàng (cart state)
// bằng cách mở rộng StateNotifier với trạng thái ban đầu là 1 empty map
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

  // Phương thức thêm sản phẩm vào giỏ hàng
  void addProductToCart({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    // Kiểm tra sản phẩm đã có trong giỏ hàng chưa dựa trên productId
    if (state.containsKey(productId)) {
      // Nếu sản phẩm đã có trong giỏ hàng, chúng ta muốn cập nhật quantity
      // và có thể các chi tiết khác
      state = {
        ...state,
        productId: Cart(
            productName: state[productId]!.productName,
            productPrice: state[productId]!.productPrice,
            category: state[productId]!.category,
            image: state[productId]!.image,
            vendorId: state[productId]!.vendorId,
            productQuantity: state[productId]!.productQuantity,
            quantity: state[productId]!.quantity + 1,
            productId: state[productId]!.productId,
            description: state[productId]!.description,
            fullName: state[productId]!.fullName)
      };
    } else {
      // Nếu sản phẩm ko có trong giỏ hàng, thêm nó với các chi tiết đã cung cấp
      state = {
        ...state,
        productId: Cart(
            productName: productName,
            productPrice: productPrice,
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName)
      };
    }
  }



  // Phương thức tăng số lượng của 1 sản phẩm trong giỏ hàng
  void incrementCartItem(String productId) {
    if(state.containsKey(productId)) {
      state[productId]!.quantity ++;

      // Thông báo notify listener trạng thái đã thay đổi
      state = {...state};
    }
  }

    // Phương thức giảm số lượng của 1 sản phẩm trong giỏ hàng
  void decrementCartItem(String productId) {
    if(state.containsKey(productId)) {
      state[productId]!.quantity --;

      // Thông báo notify listener trạng thái đã thay đổi
      state = {...state};
    }
  }

  // Phương thức để xoá mặt hàng khỏi giỏ hàng
  void removeCartItem(String productId) {
    state.remove(productId);
    // Thông báo cho ng nghe rằng trạng thái thay đổi
    state = {...state};
  }


  // Phương thức để tính tổng số lượng sản phẩm có trong giỏ hàng
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }
}
