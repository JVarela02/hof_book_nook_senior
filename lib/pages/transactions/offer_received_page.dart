import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';


class OfferReceivedPage extends StatefulWidget {
  final Map<String,dynamic> transactionData;
  const OfferReceivedPage(this.transactionData);
  @override
  State<OfferReceivedPage> createState() => OfferReceivedPageState(this.transactionData);
}

class OfferReceivedPageState extends State<OfferReceivedPage> {
  final Map<String,dynamic> transactionData;
  OfferReceivedPageState(this.transactionData);




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
                      Text("seller is " + transactionData['Seller']),
                      Text("Buyer is " + transactionData['Buyer'])
                    ]
                  ),
                ),
            ),
          )
      ));}}