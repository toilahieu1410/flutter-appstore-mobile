import 'package:app_store/views/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_store/models/cart.dart';
import 'package:app_store/provider/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Dùng ref.watch nó sẽ theo dõi dữ liệu ngay lập tức
    // VD: Nếu chúng ta thêm 1 mục mới vào giỏ hàng, nó sẽ cập nhật từ 1 thành 2 ngay lập tức
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/cartb.png'), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 320,
                top: 50,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/not.png',
                      width: 25,
                      height: 25,
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              cartData.length.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Positioned(
                left: 60,
                top: 50,
                child: Text(
                  'My Cart',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Giỏ hàng của bạn đang trống \n Bạn có thể thêm sản phẩm vào giỏ hàng từ nút bên dưới',
                    style: GoogleFonts.roboto(fontSize: 15, letterSpacing: 1.7),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MainScreen();
                          }),
                        );
                      },
                      child: const Text('Shop Now'))
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(color: Color(0xFFD7DDFF)),
                          ),
                        ),
                        Positioned(
                            top: 20,
                            left: 45,
                            child: Container(
                              width: 10,
                              height: 10,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)),
                            )),
                        Positioned(
                            top: 15,
                            left: 70,
                            child: Text(
                              'Bạn có ${cartData.length} sản phẩm',
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.7),
                            )),
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartData.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartData.values.toList()[index];
                        return Card(
                          child: SizedBox(
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(cartItem.image[0],
                                      fit: BoxFit.cover),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.productName,
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      cartItem.category,
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "\$${cartItem.productPrice.toStringAsFixed(2)}", // hiện thêm 2 chữ số thập phân
                                      style: GoogleFonts.lato(
                                          color: Colors.pink,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 120,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF102DE1),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  _cartProvider
                                                      .decrementCartItem(
                                                          cartItem.productId);
                                                },
                                                icon: const Icon(
                                                  CupertinoIcons.minus,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                cartItem.quantity.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    _cartProvider
                                                        .incrementCartItem(
                                                            cartItem.productId);
                                                  },
                                                  icon: const Icon(
                                                    CupertinoIcons.plus,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _cartProvider.removeCartItem(
                                              cartItem.productId);
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.delete,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
    );
  }
}
