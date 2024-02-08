import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/remove_wishlist.dart';
import 'package:the_hof_book_nook/pages/in%20app/add_wishlist.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/read%20data/get_wishlist_info.dart';

class PurchasePage extends StatefulWidget {
  final Map<String, dynamic> itemID;
  const PurchasePage(this.itemID);
  @override
  State<PurchasePage> createState() => _PurchasePageState(this.itemID);
}

class _PurchasePageState extends State<PurchasePage> {
  Map<String, dynamic> itemID;
  _PurchasePageState(this.itemID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Purchase")),
          ),
        ),
      ),
      body:
      Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.network(itemID['Cover'],
                    scale: 0.7,),

                    SizedBox(width: 20),
          
                    Expanded(
                          child: Column(
                            children: [

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(itemID['Title'],
                                style: GoogleFonts.merriweather(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                 ),),
                              ),

                              SizedBox(height:30),
                    
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Condition: " + itemID['Condition'],
                                style: GoogleFonts.merriweather(
                                fontSize: 15,
                                 ),),
                              ),

                              SizedBox(height:30),
                    
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Price: " + itemID['Price'] + " credits",
                                style: GoogleFonts.merriweather(
                                fontSize: 15,
                                 ),),
                              ),
                            ],
                          ),
                        ),
                  ],
                )
              ],
            ),
          ),
        )
    ));
}
}