import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:http/http.dart' as http;

class ConfirmExchangePage extends StatefulWidget {
  final Map<String, dynamic> forSaleBook;
  final Map<String, dynamic> exchangeBook;
  final String sellerName;
  final String buyerName;
  final String priceDifference;
  final String sellerEmail;
  final String buyerEmail;
  const ConfirmExchangePage(
      this.forSaleBook,
      this.exchangeBook,
      this.sellerName,
      this.buyerName,
      this.priceDifference,
      this.sellerEmail,
      this.buyerEmail);
  @override
  State<ConfirmExchangePage> createState() => ConfirmExchangePageState(
      this.forSaleBook,
      this.exchangeBook,
      this.sellerName,
      this.buyerName,
      this.priceDifference,
      this.sellerEmail,
      this.buyerEmail);
}

class ConfirmExchangePageState extends State<ConfirmExchangePage> {
  Map<String, dynamic> forSaleBook;
  Map<String, dynamic> exchangeBook;
  String sellerName;
  String buyerName;
  String priceDifference;
  String sellerEmail;
  String buyerEmail;
  ConfirmExchangePageState(this.forSaleBook, this.exchangeBook, this.sellerName,
      this.buyerName, this.priceDifference, this.sellerEmail, this.buyerEmail);

  Future confirmUniqueCode(int code) async {
    List<dynamic> references = [];
    await FirebaseFirestore.instance
        .collection('transactions')
        .where('transaction_ID', isEqualTo: code)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              references.add(document.reference.id);
            },
          ),
        );
    if (references.length > 1) {
      return false;
    } else {
      return true;
    }
  }

  Future codeGenerator() async {
    int code = Random().nextInt(899999) + 100000;
    bool unique = await confirmUniqueCode(code);
    if (unique == true) {
      return code;
    } else {
      codeGenerator();
    }
    // print(code);
  }

  var forSaleReference = "";
  var forExchangeReference = "";
  Future getReferenceIDs() async {
    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('ISBN', isEqualTo: forSaleBook['ISBN'])
        .where('Seller', isEqualTo: sellerEmail)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              forSaleReference = document.reference.id;
            },
          ),
        );

    print("for sale reference ID is " + forSaleReference);

    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('ISBN', isEqualTo: exchangeBook['ISBN'])
        .where('Seller', isEqualTo: buyerEmail)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              forExchangeReference = document.reference.id;
            },
          ),
        );

    print("for exchange reference ID is " + forExchangeReference);
  }

  Future emailSeller({
    required String user_name,
    required String textbook_name,
    required String seller_email,
  }) async {
    final serviceId = 'service_1lu743t';
    final templateId = 'template_8tyuraq';
    final userId = 'O7K884SMxRo1npb9t';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': user_name,
          'seller_email': seller_email,
          'textbook_name': textbook_name,
        }
      }),
    );
    print(response.body);
  }

  Future sendNotification(int transaction_ID) async {
    final notification = <String, dynamic>{
      "header": buyerName +
          " wants to make a exchange for your book! Please confirm or deny exchange!",
      "message": buyerName +
          " wants to exchange their " +
          exchangeBook["Title"] +
          " for your " +
          forSaleBook["Title"],
      "read": "false",
      "recipient": sellerEmail,
      "sender": buyerEmail,
      "transaction_ID": transaction_ID,
      "type": "exchange"
    };
    var db = FirebaseFirestore.instance;
    db.collection("notifications").doc().set(notification);
  }

  Future createTransaction() async {
    int code = await codeGenerator();
    await FirebaseFirestore.instance.collection("transactions").add({
      'seller': sellerName,
      'seller_email': sellerEmail,
      'buyer': buyerName,
      'buyer_email': buyerEmail,
      'forSale': {
        'Author': forSaleBook['Author'],
        'Condition': forSaleBook['Condition'],
        'Cover': forSaleBook['Cover'],
        'Description': forSaleBook['Description'],
        'ISBN': forSaleBook['ISBN'],
        'Price': forSaleBook['Price'],
        'Title': forSaleBook['Title'],
        'Seller': forSaleBook['Seller'],
      },
      'forExchange': {
        'Author': exchangeBook['Author'],
        'Condition': exchangeBook['Condition'],
        'Cover': exchangeBook['Cover'],
        'Description': exchangeBook['Description'],
        'ISBN': exchangeBook['ISBN'],
        'Price': exchangeBook['Price'],
        'Title': exchangeBook['Title'],
        'Seller': exchangeBook['Seller'],
      },
      'remainder': priceDifference,
      'status': "offer",
      'transaction_ID': code
    });

    // Set textbooks as in negotiations so it doesn't appear as available for sale
    await getReferenceIDs();
    final saleDocument = FirebaseFirestore.instance
        .collection('textbooks')
        .doc(forSaleReference);
    saleDocument.update({
      'InNegotiations': true,
    });
    final exchangeDocument = FirebaseFirestore.instance
        .collection('textbooks')
        .doc(forExchangeReference);
    exchangeDocument.update({
      'InNegotiations': true,
    });

    sendNotification(code);
    emailSeller(
        user_name: buyerName,
        textbook_name: forSaleBook['Title'],
        seller_email: sellerEmail);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    // Navigator.push(context,
    //   MaterialPageRoute(builder: (BuildContext context) {
    //   return HomePage();
    //   }));
  }

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
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Expanded(
              child: Column(children: [
                Row(
                  children: [
                    Image.network(
                      forSaleBook['Cover'],
                      scale: 0.7,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              forSaleBook['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Condition: " + forSaleBook['Condition'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Price: " + forSaleBook['Price'] + " credits",
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.network(
                      exchangeBook['Cover'],
                      scale: 0.7,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              exchangeBook['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Condition: " + exchangeBook['Condition'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Price: " + exchangeBook['Price'] + " credits",
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    createTransaction();
                    //emailSeller(user_name: buyerName, textbook_name: forSaleBook["Title"].toString(), seller_email: sellerEmail);
                    // This is where the purchase will be truly confirmed. Send email to other user notifying
                  }, // route to account page
                  child: Text(
                    'Send Exchange Offer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
                /*Text("Seller is " + sellerName),
                      SizedBox(height: 5,),
                      Text("Buyer is " + buyerName),
                      SizedBox(height: 5,),
                      Text("The price difference is " + priceDifference.toString()),
                      SizedBox(height: 5,),
                      Text("for sale book is " + forSaleBook.toString()),
                      SizedBox(height: 5,),
                      Text("Exchange book is " + exchangeBook.toString())
                      */
              ]),
            ),
          ),
        )));
  }
}
