import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/remove_wishlist.dart';
import 'package:the_hof_book_nook/pages/in%20app/add_wishlist.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/read%20data/get_wishlist_info.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
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
            child:
                Align(alignment: Alignment.centerLeft, child: Text("Wishlist")),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage(
                            showRegisterPage: () {},
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize
                  .min, // this will take space as minimum as posible(to center)
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return RemoveTextbookFromWishlistPage();
                    }));
                  }, // "route" to home page
                  child: Text('Delete from Wishlist'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return WishlistTextbookInputPage();
                    }));
                  }, // route to account page
                  child: Text('Add to Wishlist'),
                ),
              ],
            ),
          ),
          //],),

          SizedBox(
            height: 10,
          ),

          Expanded(
            child: FutureBuilder(
              future: getTextbooks(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: wishlistRefernces.length,
                  itemBuilder: ((context, index) {
                    if (wishlistRefernces.isNotEmpty) {
                      return ListTile(
                        leading: GetCover(
                          coverForSale: wishlistRefernces[index],
                        ), // This will turn into photo of textbook
                        title: GetTitle(
                          titleForSale: wishlistRefernces[index],
                        ),
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