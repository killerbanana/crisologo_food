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
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> datas =
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>;

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
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        color: Colors.blue,
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          BlocProvider.of<ProductBloc>(context)
                                              .add(SelectCategoryEvent(
                                                  category:
                                                      product['category']));

                                          BlocProvider.of<ProductBloc>(context)
                                              .add(
                                                  const ChangeProductImageEvent(
                                                      file: null));

                                          Navigator.pushNamed(
                                              context, 'product-edit',
                                              arguments: ProductArgs(
                                                id: snapshot
                                                    .data!.docs[index].id,
                                                name: product['name'],
                                                desc: product['description'],
                                                price: product['price'],
                                                category: product['category'],
                                                imageUrl: product['imageUrl'],
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
                                                title:
                                                    const Text('Confirmation'),
                                                content: Text(
                                                    'Do you want to delete ${product['name']}?'),
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
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete()
                                                  .then((value) {
                                                const snackBar = SnackBar(
                                                  content:
                                                      Text('Product Deleted'),
                                                  duration:
                                                      Duration(seconds: 2),
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  color: Colors.blue,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    BlocProvider.of<ProductBloc>(context).add(
                                        SelectCategoryEvent(
                                            category: product['category']));

                                    BlocProvider.of<ProductBloc>(context).add(
                                        const ChangeProductImageEvent(
                                            file: null));

                                    Navigator.pushNamed(context, 'product-edit',
                                        arguments: ProductArgs(
                                          id: snapshot.data!.docs[index].id,
                                          name: product['name'],
                                          desc: product['description'],
                                          price: product['price'],
                                          category: product['category'],
                                          imageUrl: product['imageUrl'],
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
                                              'Do you want to delete ${product['name']}?'),
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
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ).then((value) {
                                      if (value != null && value) {
                                        products
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete()
                                            .then((value) {
                                          const snackBar = SnackBar(
                                            content: Text('Product Deleted'),
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
                          );
                        }),
                  );
                })
          ]),
        ),
      );
    });
  }
}
