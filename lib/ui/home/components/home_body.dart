import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/home/components/slider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _shopStream =
        FirebaseFirestore.instance.collection('banner').snapshots();
    final Stream<QuerySnapshot> _category =
        FirebaseFirestore.instance.collection('category').snapshots();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 46),
          child: Text(
            'Hi, User',
            style: textInter.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Text(
            'Get your favorite food here!',
            style: textInter.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        SliderImage(),
        SizedBox(
          height: 30,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 20, right: 20),
        //   child: StreamBuilder<QuerySnapshot>(
        //     stream: _category,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError) {
        //         return Text(snapshot.error.toString());
        //       }

        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Text("");
        //       }

        //       List<dynamic> data = snapshot.data!.docs.toList();

        //       return Container(
        //         height: 90,
        //         width: MediaQuery.of(context).size.width,
        //         child: ListView.builder(
        //             itemCount: data.length,
        //             scrollDirection: Axis.horizontal,
        //             shrinkWrap: true,
        //             itemBuilder: (context, index) {
        //               Map<String, dynamic> datas =
        //                   data[index].data()! as Map<String, dynamic>;
        //               return Row(
        //                 children: [
        //                   Container(
        //                     width: 72,
        //                     child: Column(
        //                       children: [
        //                         CircleAvatar(
        //                           radius: 27,
        //                         ),
        //                         Text(
        //                           datas['name'],
        //                           textAlign: TextAlign.center,
        //                           style: textInter.copyWith(
        //                             fontSize: 14,
        //                             color: Colors.black,
        //                             fontWeight: FontWeight.w500,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     width: 20,
        //                   ),
        //                 ],
        //               );
        //             }),
        //       );
        //     },
        //   ),
        // ),
        // SizedBox(
        //   height: 30,
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Recommendation',
            style: textInter.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: StreamBuilder<QuerySnapshot>(
              stream: _shopStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                }

                List<dynamic> data = snapshot.data!.docs.toList();

                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(data.length, (index) {
                    Map<String, dynamic> datas =
                        data[index].data()! as Map<String, dynamic>;
                    return Container(
                      width: 140,
                      height: 242,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              datas['name'],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              datas['isOpen'] ? "Open" : "Close",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color:
                                    datas['isOpen'] ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${datas['opening']} - ${datas['closing']}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Color(0XFF756F6F),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
