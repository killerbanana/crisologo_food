import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/seller/arguments/product_args.dart';
import 'package:restaurant_app/ui/seller/bloc/product_bloc.dart';
import 'package:restaurant_app/ui/seller/components/drop_down.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    final TextEditingController promosCtrl = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    File? file;

    String? url;

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    final arguments = ModalRoute.of(context)?.settings.arguments as ProductArgs;

    nameCtrl.text = arguments.name;
    priceCtrl.text = arguments.price;
    descCtrl.text = arguments.desc;
    promosCtrl.text = arguments.promo;

    return BlocBuilder<ProductBloc, ProductState>(builder: (ctx, state) {
      // MIGRATE IF NEEDED
      // FirebaseFirestore.instance
      //     .collection('products')
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   querySnapshot.docs.forEach((doc) {
      //     products.doc(doc.id).update({'promo': ''});
      //   });
      // });

      if (state.file != null && !kIsWeb) {
        file = File(state.file!.files.single.path!);
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Menu",
            style: textInter.copyWith(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 87.64,
                    height: 87.36,
                    margin: EdgeInsets.only(left: 16, top: 2),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 100.82,
                          // backgroundColor: Colors.green,
                          child: Semantics(
                            label: 'cy-userprofile',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: state.file != null
                                  ? kIsWeb
                                      ? Image.memory(
                                          state.file!.files.first.bytes!,
                                          gaplessPlayback: true,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          file!,
                                          fit: BoxFit.fill,
                                        )
                                  : Image.network(arguments.imageUrl),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 59.64,
                          top: 59.64,
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: InkWell(
                              onTap: (() async {
                                await getImage(ctx).then((value) {
                                  ctx.read<ProductBloc>().add(
                                      ChangeProductImageEvent(file: value));
                                });
                              }),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(0xFFFF740A),
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  child: Center(
                                    child: Semantics(
                                      label: 'cy-edit-btn',
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      placeholder: 'Name',
                      controller: nameCtrl,
                      onChanged: (value) {
                        BlocProvider.of<ProductBloc>(context)
                            .add(const AddErrorEvent(withError: false));
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      placeholder: 'Price',
                      controller: priceCtrl,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        BlocProvider.of<ProductBloc>(context)
                            .add(const AddErrorEvent(withError: false));
                      },
                      keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      placeholder: 'Description',
                      onChanged: (value) {
                        BlocProvider.of<ProductBloc>(context)
                            .add(const AddErrorEvent(withError: false));
                      },
                      controller: descCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const DropDown(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: CupertinoTextField(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      placeholder: 'Promos (optional)',
                      onChanged: (value) {
                        BlocProvider.of<ProductBloc>(context)
                            .add(const AddErrorEvent(withError: false));
                      },
                      controller: promosCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                      child: Visibility(
                    visible: state.withError,
                    child: Text(
                      'Please fill all required fields',
                      style: textInter.copyWith(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: () async {
                        if (nameCtrl.text.isEmpty ||
                            descCtrl.text.isEmpty ||
                            priceCtrl.text.isEmpty ||
                            state.category.isEmpty) {
                          BlocProvider.of<ProductBloc>(context)
                              .add(const AddErrorEvent(withError: true));
                        } else {
                          if (state.file != null) {
                            if (kIsWeb) {
                              url = await saveImage(
                                uid: _auth.currentUser!.uid,
                                fileName: state.file!.files.first.name,
                                fileBytes: state.file!.files.first.bytes!,
                                path: null,
                              );
                            } else {
                              url = await saveImage(
                                uid: _auth.currentUser!.uid,
                                fileName: state.file!.files.first.name,
                                fileBytes: null,
                                path: state.file!.files.single.path!,
                              );
                            }
                          }
                          await products.doc(arguments.id).update({
                            'id': arguments.id,
                            'seller_id': _auth.currentUser!.uid,
                            'name': nameCtrl.text,
                            'price': priceCtrl.text,
                            'description': descCtrl.text,
                            'category': state.category,
                            'type': 'product',
                            'imageUrl': url ?? arguments.imageUrl,
                            'promo':
                                promosCtrl.text.isEmpty ? '' : promosCtrl.text,
                          }).then((value) {
                            const snackBar = SnackBar(
                              content: Text('Product Edited'),
                              duration: Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            nameCtrl.text = "";
                            priceCtrl.text = "";
                            descCtrl.text = "";
                          }).catchError(
                              (error) => print("Failed to add user: $error"));
                        }
                      },
                      child: Text(
                        'Save',
                        style: textInter.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<FilePickerResult?> getImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'png',
        ],
      );
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> saveImage({
    required String uid,
    required String fileName,
    required var fileBytes,
    required String? path,
  }) async {
    TaskSnapshot snapshot;
    if (kIsWeb) {
      snapshot = await FirebaseStorage.instance
          .ref('uploads/avatars/$uid/$fileName')
          .putData(fileBytes!);
    } else {
      snapshot = await FirebaseStorage.instance
          .ref('uploads/avatars/$uid/$fileName')
          .putFile(File(path!));
    }
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
