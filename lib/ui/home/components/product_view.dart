import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/styles.dart';

class ProductView extends StatelessWidget {
  final String sellerName;
  final String sellerId;
  const ProductView(
      {super.key, required this.sellerName, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sellerName,
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: locations.doc(sellerId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Container();
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/product-fullscreen',
                          arguments: data['imageUrl']);
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: EdgeInsets.all(double.infinity),
                        minScale: 1,
                        maxScale: 4.0,
                        scaleEnabled: true,
                        child: Image.network(
                          data['imageUrl'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                }

                return Text("Loading location...");
              },
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: products
                    .where('seller_id', isEqualTo: sellerId)
                    .orderBy('category')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> datas = snapshot.data!.docs[index]
                            .data()! as Map<String, dynamic>;

                        final product = snapshot.data!.docs[index];

                        // Check if it's the first item of a new category
                        if (index == 0 ||
                            product['category'] !=
                                snapshot.data!.docs[index - 1]['category']) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  product['category'],
                                  style: textInter.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  product['name'],
                                  style: textInter.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(product['imageUrl']),
                                ),
                                subtitle: Text(
                                  'Price: ₱ ${product['price']}',
                                  style: textInter.copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return ListTile(
                          title: Text(
                            product['name'],
                            style: textInter.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(product['imageUrl']),
                          ),
                          subtitle: Text(
                            'Price: ₱ ${product['price']}',
                            style: textInter.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
