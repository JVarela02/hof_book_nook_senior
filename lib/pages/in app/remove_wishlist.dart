import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/read%20data/get_wishlist_info.dart';
import 'package:the_hof_book_nook/pages/in%20app/wishlist_page.dart';

class RemoveTextbookFromWishlistPage extends StatefulWidget {
  const RemoveTextbookFromWishlistPage({super.key});

  @override
  State<RemoveTextbookFromWishlistPage> createState() =>
      _RemoveTextbookFromWishlistPageState();
}

class _RemoveTextbookFromWishlistPageState
    extends State<RemoveTextbookFromWishlistPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> wishlistRefernces = [];

  //get textbooks
  Future getTextbooks() async {
    await FirebaseFirestore.instance
        .collection('wishlist')
        .where('User', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              wishlistRefernces.add(document.reference.id);
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
                  itemCount: wishlistRefernces.length,
                  itemBuilder: ((context, index) {
                    String docIdTobeDeleted = wishlistRefernces[index];
                    if (wishlistRefernces.isNotEmpty) {
                      return ListTile(
                          leading: const Icon(Icons
                              .camera_alt_rounded), // This will turn into photo of textbook
                          title: GetTitle(
                            titleForSale: wishlistRefernces[index],
                          ),
                          trailing: Icon(Icons.delete_forever_outlined),
                          onTap: () async {
                            try {
                              FirebaseFirestore.instance
                                  .collection("wishlist")
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
                                    return RemoveTextbookFromWishlistPage();
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