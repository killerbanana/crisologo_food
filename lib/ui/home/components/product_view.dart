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
                  return Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      data['imageUrl'],
                      fit: BoxFit.fill,
                    ),
                  );
                }

                return Text("Loading location...");
              },
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
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Column(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['imageUrl']),
                                ),
                                title: Text(data['name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('₱ ${data['price']}'),
                                    Text(data['category']),
                                    const Divider(
                                      thickness: 1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
