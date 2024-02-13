import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';


class ConfirmPurchasePage extends StatefulWidget {
  final Map<String, dynamic> forSaleBook;
  final String sellerName;
  final String buyerName;
  final String buyerEmail;
  const ConfirmPurchasePage(this.forSaleBook, this.sellerName, this.buyerName, this.buyerEmail);
  @override
  State<ConfirmPurchasePage> createState() => ConfirmPurchasePageState(this.forSaleBook, this.sellerName, this.buyerName, this.buyerEmail);
}

class ConfirmPurchasePageState extends State<ConfirmPurchasePage> {
  Map<String, dynamic> forSaleBook;
    String sellerName;
    String buyerName;
    String buyerEmail;
  ConfirmPurchasePageState(this.forSaleBook, this.sellerName, this.buyerName, this.buyerEmail);


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
                child: Expanded(
                  child: Column(
                    children: [
                      Text("Seller is " + sellerName),
                      SizedBox(height: 5,),
                      Text("Buyer is " + buyerName),
                      SizedBox(height: 5,),
                      Text("Buyer email is " + buyerEmail.toString()),
                      SizedBox(height: 5,),
                      Text("for sale book is " + forSaleBook.toString()),

                    ]
                  ),
                ),
            ),
          )
      ));}}