import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:the_hof_book_nook/repeated_functions.dart';

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

  // Future confirmUniqueCode(int code) async {
  //   List<dynamic> references = [];
  //   await FirebaseFirestore.instance
  //       .collection('transactions')
  //       .where('transaction_ID', isEqualTo: code)
  //       .get()
  //       .then(
  //         (snapshot) => snapshot.docs.forEach(
  //           (document) {
  //             //print(document.reference.id);
  //             references.add(document.reference.id);
  //           },
  //         ),
  //       );
  //   if (references.length > 1) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  // Future codeGenerator() async {
  //   int code = Random().nextInt(899999) + 100000;
  //   bool unique = await confirmUniqueCode(code);
  //   if (unique == true) {
  //     return code;
  //   } else {
  //     codeGenerator();
  //   }
  //   // print(code);
  // }

  List<dynamic> creditIDList = [];
  String creditID = "";
  int creditAmount = 0;

  Future getCreditID(String payer) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: payer)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              //creditIDList.add(document.reference.id);
              creditID = document.reference.id;
              print(creditID);
            },
          ),
        );
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(creditID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      creditAmount = data?['credits'];
      print(creditAmount);
      //print(credits);
      //print(creditIDList[0]);
      //print(credits.runtimeType);
      //creditIDList.add(credits);
      //print(creditIDList);    
  }
  }

  List<dynamic> sellerCreditIDList = [];

  Future getCreditIDSeller() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: sellerEmail)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              sellerCreditIDList.add(document.reference.id);
            },
          ),
        );
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(sellerCreditIDList[0]).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var credits = data?['credits'];
      sellerCreditIDList.add(credits);
    }
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

  /* Future sendNotification(int transaction_ID) async {
    final notification = <String, dynamic> {
      "header" : buyerName+ " wants to make a exchange for your book!",
      "message" : buyerName+ " wants to exchange their "+exchangeBook["Title"]+" for your "+forSaleBook["Title"],
      "read" : "false",
      "recipient" : sellerEmail,
      "sender" : buyerEmail,
      "transaction_ID" : transaction_ID

    };
    var db = FirebaseFirestore.instance;
    db.collection("notifications").doc().set(notification);
  } */

  Future createTransaction() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int code = await idGenerator(6);
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
        'Textbook ID': forSaleBook['Textbook ID']
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
        'Textbook ID': exchangeBook['Textbook ID']
      },
      'remainder': priceDifference,
      'status': "offer",
      'transaction_ID': code,
      'meetup': [],
      'timestamp': timestamp,
      'sent_email': false
    });

    // Remove Credits from correct user 
    // if remainder is < 0 remove from the seller 
    // else if remainder is > 0 remove from buyer
    if(int.parse(priceDifference) > 0){
      await getCreditID(buyerEmail);
      final documents = FirebaseFirestore.instance.collection('users').doc(creditID);
      documents.update({'credits': (creditAmount - int.parse(priceDifference)),});
    }
    else{
      // we do nothing because the seller shouldn't have credits removed for without consent  
    }


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

    sendNotification(
      code,
      buyerName +
          " wants to make a exchange for your book! Please confirm or deny exchange!",
      buyerName +
          " wants to exchange their " +
          exchangeBook["Title"] +
          " for your " +
          forSaleBook["Title"],
      sellerEmail,
      buyerEmail,
    );

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
                      scale: 1,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 400),
                              child: Text(
                                forSaleBook['Title'],
                                style: GoogleFonts.merriweather(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      scale: 1,
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
                  onPressed: () async {
                    // if (int.parse(forSaleBook['Price']) > 0) {
                    //   await getCreditID().then((data) {
                    //     print(creditIDList);
                    //     final documents = FirebaseFirestore.instance
                    //         .collection('users')
                    //         .doc(creditIDList[0]);
                    //     documents.update({
                    //       'credits':
                    //           creditIDList[1] - int.parse(forSaleBook['Price']),
                    //     });
                    //   });
                    //   createTransaction();
                    // } 
                    // else if (int.parse(forSaleBook['Price']) < 0) {
                    //   await getCreditID().then((data) {
                    //     print(creditIDList);
                    //     final documents = FirebaseFirestore.instance
                    //         .collection('users')
                    //         .doc(creditIDList[0]);
                    //     documents.update({
                    //       'credits': sellerCreditIDList[1] -
                    //           int.parse(forSaleBook['Price']),
                    //     });
                    //   });
                      createTransaction();
                    //}

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
