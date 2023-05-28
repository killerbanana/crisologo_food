import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/styles.dart';

class ToApprove extends StatelessWidget {
  const ToApprove({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shops for approval',
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
            StreamBuilder<QuerySnapshot>(
                stream: users
                    .where('status', isEqualTo: 'for approval')
                    .orderBy('displayName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
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
                                title: Text(data['displayName']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['email']),
                                    const Divider(
                                      thickness: 1,
                                    )
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      color: Colors.green,
                                      icon: const Icon(Icons.check),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirmation'),
                                              content: Text(
                                                  'Do you want to approve ${data['displayName']} request?'),
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
                                            users.doc(document.id).update({
                                              "status": "approved"
                                            }).then((value) {
                                              const snackBar = SnackBar(
                                                content: Text('Shop Approved'),
                                                duration: Duration(seconds: 2),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          } else {}
                                        });
                                      },
                                    ),
                                    IconButton(
                                      color: Colors.red,
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirmation'),
                                              content: Text(
                                                  'Do you want to reject ${data['displayName']} request?'),
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
                                            users.doc(document.id).update({
                                              "status": "rejected"
                                            }).then((value) {
                                              const snackBar = SnackBar(
                                                content: Text('Shop Rejected'),
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
                }),
          ],
        ),
      ),
    );
  }
}
