import 'package:app_store/models/product_model.dart';
import 'package:app_store/provider/cart_provider.dart';
import 'package:app_store/services/manage_http_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product detail',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
          onPressed: () {}, 
          icon: Icon(Icons.favorite_border))],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 260,
              height: 275,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 50,
                    child: Container(
                      width: 260,
                      height: 260,
                      clipBehavior: Clip.hardEdge,
                      decoration:  BoxDecoration(
                        color: const Color(0XFFD8DDFF),
                        borderRadius: BorderRadius.circular(130)
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 22,
                    child: Container(
                      width: 216,
                      height: 274,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Color(0xFF9CA8FF),
                        borderRadius: BorderRadius.circular(14)
                      ),
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.product.images.length,
                          itemBuilder: (context, index) {
                            return Image.network(widget.product.images[index],
                              width: 200,
                              height: 225,
                            );
                          }
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.productName,
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color(0xFF3C55Ef
                    ),
                  ),
                ),
                Text(
                  '\$${widget.product.productPrice.toString()}',
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3C55Ef)
                  ),
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.product.category,
              style: GoogleFonts.roboto(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('About', style: GoogleFonts.lato(
                  fontSize: 17,
                  letterSpacing: 1.7,
                  color: const Color(
                    0xFF363330
                  )
                ),
                ),
                Text(
                  widget.product.description,
                  style: GoogleFonts.lato(
                    letterSpacing: 1.8,
                    fontSize: 14
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: (){
            _cartProvider.addProductToCart(
              productName: widget.product.productName, 
              productPrice: widget.product.productPrice, 
              category: widget.product.category, 
              image: widget.product.images, 
              vendorId: widget.product.vendorId, 
              productQuantity: widget.product.quantity, 
              quantity: 1, 
              productId: widget.product.id, 
              description: widget.product.description, 
              fullName: widget.product.fullName
            );
            showSnackBar(context, widget.product.productName);
          },
          child: Container(
            width: 385,
            height: 45,
            clipBehavior: Clip.hardEdge, // thêm vòng cung
            decoration: BoxDecoration(
              color: Color(0xFF3B54EE),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Center(
              child: Text('Add To Cart', style: GoogleFonts.mochiyPopOne(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            ),
          ),
        ),
        ),
    );
  }
}
