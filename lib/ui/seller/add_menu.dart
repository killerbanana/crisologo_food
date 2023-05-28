import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/seller/arguments/product_args.dart';
import 'package:restaurant_app/ui/seller/bloc/product_bloc.dart';

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    final FirebaseAuth _auth = FirebaseAuth.instance;

    return BlocBuilder<ProductBloc, ProductState>(builder: (ctx, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Menu List",
            style: textInter.copyWith(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    // Perform registration functionality here
                    Navigator.pushNamed(context, '/add-menu-form');
                  },
                  child: Text(
                    'Add an Entry',
                    style: textInter.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: products
                    .where('seller_id', isEqualTo: _auth.currentUser!.uid)
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      color: Colors.blue,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        BlocProvider.of<ProductBloc>(context)
                                            .add(SelectCategoryEvent(
                                                category: data['category']));

                                        BlocProvider.of<ProductBloc>(context)
                                            .add(const ChangeProductImageEvent(
                                                file: null));

                                        Navigator.pushNamed(
                                            context, 'product-edit',
                                            arguments: ProductArgs(
                                              id: document.id,
                                              name: data['name'],
                                              desc: data['description'],
                                              price: data['price'],
                                              category: data['category'],
                                              imageUrl: data['imageUrl'],
                                            ));
                                      },
                                    ),
                                    IconButton(
                                      color: Colors.red,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirmation'),
                                              content: Text(
                                                  'Do you want to delete ${data['name']}?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) {
                                          if (value != null && value) {
                                            products
                                                .doc(document.id)
                                                .delete()
                                                .then((value) {
                                              const snackBar = SnackBar(
                                                content:
                                                    Text('Product Deleted'),
                                                duration: Duration(seconds: 2),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          } else {}
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                })
          ]),
        ),
      );
    });
  }
}
