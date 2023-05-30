import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/seller/arguments/product_args.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as ProductArgs;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Category: ${product.category}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price: \₱ ${int.parse(product.price).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10.0),
            product.promo != ""
                ? Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(14, 2, 36, 43),
                        blurRadius: 3,
                        offset: Offset(0, 10),
                        spreadRadius: -5,
                      ),
                    ]),
                    child: ClipPath(
                        clipper: MyClipperRightSide(),
                        child: Container(
                          height: 72,
                          width: 253,
                          color: Colors.white,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                child: SizedBox(
                                  height: 72,
                                  width: 73,
                                  child: ClipPath(
                                    clipper: MyClipperLeftSide(),
                                    child: Container(
                                      height: 72,
                                      width: 73,
                                      alignment: Alignment.center,
                                      color: Color(0xFF16E282),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 11, right: 11),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Promo',
                                        style: textInter.copyWith(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Semantics(
                                                label:
                                                    // 'cy-voucher-${widget.index}-title',
                                                    'cy-pasabuy-voucher-title',
                                                child: Text("${product.promo}",
                                                    textAlign: TextAlign.left,
                                                    softWrap: true,
                                                    style: GoogleFonts.inter(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.2,
                                                        height: 1.1)),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                : Container(),
            SizedBox(height: 10.0),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              product.desc,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipperRightSide extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var smallLineLength = 6;
    var smallLineHeight = size.height / 18;
    var path = Path();

    path.moveTo(0, size.height);

    path.lineTo(size.width, size.height);

    for (int i = 17; i >= 0; i--) {
      if (i % 2 == 0) {
        path.lineTo(size.width, smallLineHeight.toDouble() * i);
      } else {
        path.lineTo(
            size.width - smallLineLength, smallLineHeight.toDouble() * i);
      }
    }

    path.lineTo(0, 0);

    for (int i = 1; i <= 18; i++) {
      if (i % 2 == 0) {
        path.lineTo(0, smallLineHeight.toDouble() * i);
      } else {
        path.lineTo(smallLineHeight.toDouble(), smallLineHeight.toDouble() * i);
      }
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}

class MyClipperLeftSide extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var smallLineLength = 6;
    var smallLineHeight = size.height / 18;
    var path = Path();

    path.moveTo(size.width, 0);

    path.lineTo(0, 0);

    for (int i = 1; i <= 18; i++) {
      if (i % 2 == 0) {
        path.lineTo(0, smallLineHeight.toDouble() * i);
      } else {
        path.lineTo(smallLineHeight.toDouble(), smallLineHeight.toDouble() * i);
      }
    }

    path.lineTo(size.width, size.height);

    double smallHeight = size.height / 10;
    double smallIndent = 1;

    for (int i = 10; i >= 1; i--) {
      if (i % 2 == 0) {
        if (i == 10) {
          path.lineTo(size.width, size.height - (smallHeight.toDouble() / 2));
          path.lineTo(size.width - smallIndent,
              size.height - (smallHeight.toDouble() / 2));
        } else {
          path.lineTo(
              size.width,
              size.height -
                  ((smallHeight.toDouble() * i) +
                      (smallHeight.toDouble() / 2)));
          path.lineTo(
              size.width - smallIndent,
              size.height -
                  (smallHeight.toDouble() * i + (smallHeight.toDouble() / 2)));
        }
      } else {
        path.lineTo(
            size.width - smallIndent,
            size.height -
                ((smallHeight.toDouble() * i) + (smallHeight.toDouble() / 2)));
        path.lineTo(
            size.width,
            size.height -
                (smallHeight.toDouble() * i + (smallHeight.toDouble() / 2)));
      }
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
