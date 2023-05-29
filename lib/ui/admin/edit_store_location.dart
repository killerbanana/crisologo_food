import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/styles.dart';

class EditStoreLocation extends StatefulWidget {
  const EditStoreLocation({super.key});

  @override
  State<EditStoreLocation> createState() => _EditStoreLocationState();
}

class _EditStoreLocationState extends State<EditStoreLocation> {
  FilePickerResult? filePicker;
  File? file;
  CollectionReference locations =
      FirebaseFirestore.instance.collection('locations');

  String? url;

  @override
  Widget build(BuildContext context) {
    final shopName = ModalRoute.of(context)?.settings.arguments as List<String>;
    if (filePicker != null && !kIsWeb) {
      file = File(filePicker!.files.single.path!);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          shopName[0],
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
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
                  : Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/restaurant-ilocos.appspot.com/o/noimage.png?alt=media&token=a0b3b506-ee61-40cb-b6bc-d250c2cef0c9'),
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
                    await getImage(context).then((value) {
                      setState(() {
                        filePicker = value;
                      });
                    });
                  },
                  child: Text(
                    'Browse Image',
                    style: textInter.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                    await locations.doc(shopName[1]).set({
                      'id': locations.doc().id,
                      'seller_id': shopName[1],
                      'imageUrl': url ??
                          'https://firebasestorage.googleapis.com/v0/b/restaurant-ilocos.appspot.com/o/noimage.png?alt=media&token=a0b3b506-ee61-40cb-b6bc-d250c2cef0c9',
                    }).then((value) {
                      const snackBar = SnackBar(
                        content: Text('Location Saved!'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }).catchError(
                        (error) => print("Failed to add user: $error"));
                  },
                  child: Text(
                    'Save Location',
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
          .ref('uploads/locations/$fileName')
          .putData(fileBytes!);
    } else {
      snapshot = await FirebaseStorage.instance
          .ref('uploads/locations/$fileName')
          .putFile(File(path!));
    }
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
