import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/search/bloc/search_bloc.dart';
import 'package:restaurant_app/ui/search/components/product_card.dart';
import 'package:restaurant_app/ui/search/components/selectable_chip.dart';
import 'package:restaurant_app/ui/seller/arguments/product_args.dart';
import 'package:restaurant_app/ui/seller/bloc/product_bloc.dart';

import '../home/components/product_view.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference shops = FirebaseFirestore.instance.collection('shops');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<QueryDocumentSnapshot<Object?>> list = [];

  Timer? _debounce;
  Future<void> runCheck(String? value, bool? fromChip) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), () async {
      list.clear();
      if (value != '') {
        if (fromChip!) {
          BlocProvider.of<SearchBloc>(context)
              .add(GetSearchEvent(searchKey: value!));
        } else {
          FirebaseFirestore.instance.collection('recent_searches').add({
            'term': value,
            'timestamp': FieldValue.serverTimestamp(),
            'userId': _auth.currentUser!.uid,
          });
          BlocProvider.of<SearchBloc>(context)
              .add(GetSearchEvent(searchKey: value!));
        }
      }
    });
  }

  Stream<QuerySnapshot> getRecentSearches() {
    return FirebaseFirestore.instance
        .collection('recent_searches')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
          ),
          Text(
            'Search',
            style: textInter.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: CupertinoSearchTextField(
              controller: _textEditingController,
              onChanged: (value) async {
                await runCheck(value, false);
              },
              placeholder: 'Search...',
              style: TextStyle(fontSize: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Recent Searches',
            style: textInter.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: getRecentSearches(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return SelectableChip(
                      label: data['term'],
                      onSelected: (bool isSelected) async {
                        if (isSelected) {
                          await runCheck(data['term'], true);
                        }
                      },
                    );
                  }).toList(),
                );
              }),
          SizedBox(
            height: 16,
          ),
          BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
            return Container(
              child: state.list.isNotEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: List.generate(state.list.length, (index) {
                          Map<String, dynamic> datas =
                              state.list[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              if (datas['type'] == 'shop') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductView(
                                      sellerId: state.list[index].id,
                                      sellerName: datas['name'],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/product-details',
                                  arguments: ProductArgs(
                                    id: state.list[index].id,
                                    name: datas['name'],
                                    desc: datas['description'],
                                    price: datas['price'],
                                    category: datas['category'],
                                    imageUrl: datas['imageUrl'],
                                    promo: datas['promo'],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 140,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(.05),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: state.list[index].id,
                                    child: Container(
                                      height: 180,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            datas['imageUrl'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      datas['name'],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      datas['type'] == 'shop'
                                          ? datas['isOpen']
                                              ? 'Open'
                                              : 'Close'
                                          : datas['category'],
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: datas['type'] == 'shop'
                                            ? datas['isOpen']
                                                ? Colors.green
                                                : Colors.red
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      datas['type'] == 'shop'
                                          ? '${datas['opening']} - ${datas['closing']}'
                                          : '₱ ${datas['price']}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Color(0XFF756F6F),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : Text('NO DATA'),
            );
          }),
        ],
      ),
    );
  }
}
