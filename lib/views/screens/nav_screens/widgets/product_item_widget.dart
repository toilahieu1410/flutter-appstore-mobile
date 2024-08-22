import 'package:app_store/models/product_model.dart';
import 'package:app_store/views/screens/detail/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product; 

  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(product: product);
        })
        );
      },
      child: Container(
        width: 170,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(24)
              ),
      
              child: Stack(
                children: [
                  Image.network(product.images[0], height: 170, width: 170,
                  fit: BoxFit.cover
                  ),
                  Positioned(
                    top:15,
                    right: 2,
                    child: Image.asset('assets/icons/love.png'),
                    width: 26,
                    height: 26,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset('assets/icons/cart.png', 
                    width: 26, 
                    height: 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              overflow: TextOverflow.ellipsis,
              product.productName, 
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color(0xFF212121),
                fontWeight: FontWeight.bold
              )
            ),
             const SizedBox(height: 4),
             Text(
              product.category,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF)
              ),
             )
          ],
        ),
      ),
    );
  }
}