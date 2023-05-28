import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';
import 'package:restaurant_app/ui/seller/bloc/product_bloc.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  bool loading = true;
  String selectedItem = '';
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc('3LEBa25UxID17cplGS03')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        for (var data in data['food_category']) {
          categories.add(data);
        }
        categories.sort((a, b) {
          if (a == 'Others') {
            return 1;
          } else if (b == 'Others') {
            return -1;
          } else {
            return a.compareTo(b);
          }
        });
        loading = false;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              placeholder: 'Click to Select Category',
              readOnly: true,
              onTap: loading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SuggestionsPage(
                            items: categories,
                            onSuggestionSelected: (item) {
                              BlocProvider.of<ProductBloc>(context)
                                  .add(SelectCategoryEvent(category: item));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
            ),
            SizedBox(height: 16.0),
            Text('Selected Category: ${state.category}'),
          ],
        ),
      );
    });
  }
}

class SuggestionsPage extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onSuggestionSelected;

  SuggestionsPage({
    required this.items,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Category'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item),
            onTap: () => onSuggestionSelected(item),
          );
        },
      ),
    );
  }
}
