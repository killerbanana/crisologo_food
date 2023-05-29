import 'package:flutter/material.dart';

class ProductFullScreen extends StatelessWidget {
  const ProductFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .5,
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(double.infinity),
                minScale: 1,
                maxScale: 4.0,
                scaleEnabled: true,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
