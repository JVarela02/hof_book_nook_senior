import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/read%20data/get_textbook_info.dart';

class RemoveTextbookPage extends StatefulWidget {
  const RemoveTextbookPage({super.key});

  @override
  State<RemoveTextbookPage> createState() => _RemoveTextbookPageState();
}

class _RemoveTextbookPageState extends State<RemoveTextbookPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> myListingRefernces = [];

  //get textbooks
  Future getTextbooks() async {
    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('Seller', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              myListingRefernces.add(document.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Remove Textbook")),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTextbooks(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: myListingRefernces.length,
                  itemBuilder: ((context, index) {
                    String docIdTobeDeleted = myListingRefernces[index];
                    if (myListingRefernces.isNotEmpty) {
                      return ListTile(
                          leading: const Icon(Icons
                              .camera_alt_rounded), // This will turn into photo of textbook
                          title: GetTitle(titleForSale: myListingRefernces[index],),
                          subtitle:
                              GetPrice(priceForSale: myListingRefernces[index]),
                          trailing: Icon(Icons.delete_forever_outlined),
                          onTap: () async {
                            try {
                              FirebaseFirestore.instance
                                  .collection("textbooks")
                                  .doc(docIdTobeDeleted)
                                  .delete()
                                  .then((_) {
                                print("Successfly deleted textbook.");
                              });
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return RemoveTextbookPage();
                                  },
                                ),
                              );
                            } catch (e) {
                              print("Error deleting textbook.");
                            }
                          }
                          // Remove Textbook Function
                          );
                    } else {
                      return SizedBox(height: 20);
                    }
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
