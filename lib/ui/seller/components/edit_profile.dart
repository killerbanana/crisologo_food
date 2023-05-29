import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/styles.dart';

class EditProfileSeller extends StatefulWidget {
  const EditProfileSeller({super.key});

  @override
  State<EditProfileSeller> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileSeller> {
  FilePickerResult? filePicker;
  File? file;

  CollectionReference locations =
      FirebaseFirestore.instance.collection('shops');

  String img = '';
  String shopName = '-';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController nameCtrl = TextEditingController();

  String? url;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await FirebaseFirestore.instance
        .collection('shops')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;

        img = data['imageUrl'];
        shopName = data['name'];
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final shopId = ModalRoute.of(context)?.settings.arguments as String;
    if (filePicker != null && !kIsWeb) {
      file = File(filePicker!.files.single.path!);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
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
                        child: filePicker != null
                            ? kIsWeb
                                ? Image.memory(
                                    filePicker!.files.first.bytes!,
                                    gaplessPlayback: true,
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    file!,
                                    fit: BoxFit.fill,
                                  )
                            : Image.network(img),
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
                          await getImage(context).then((value) {
                            setState(() {
                              filePicker = value;
                            });
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
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: CupertinoTextField(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                placeholder: 'Shop Name',
                controller: nameCtrl,
                onChanged: (value) {},
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () async {
                    if (filePicker != null) {
                      if (kIsWeb) {
                        url = await saveImage(
                          fileName: filePicker!.files.first.name,
                          fileBytes: filePicker!.files.first.bytes!,
                          path: null,
                        );
                      } else {
                        url = await saveImage(
                          fileName: filePicker!.files.first.name,
                          fileBytes: null,
                          path: filePicker!.files.single.path!,
                        );
                      }
                    }
                    await locations.doc(shopId).update({
                      'name': nameCtrl.text.isEmpty ? shopName : nameCtrl.text,
                      'imageUrl': url ?? img,
                    }).then((value) {
                      nameCtrl.text = '';
                      const snackBar = SnackBar(
                        content: Text('Profile Saved!'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }).catchError(
                        (error) => print("Failed to save profile: $error"));
                  },
                  child: Text(
                    'Save Profile',
                    style: textInter.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    required String fileName,
    required var fileBytes,
    required String? path,
  }) async {
    TaskSnapshot snapshot;
    if (kIsWeb) {
      snapshot = await FirebaseStorage.instance
          .ref('uploads/seller/profile/$fileName')
          .putData(fileBytes!);
    } else {
      snapshot = await FirebaseStorage.instance
          .ref('uploads/seller/profile/$fileName')
          .putFile(File(path!));
    }
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
