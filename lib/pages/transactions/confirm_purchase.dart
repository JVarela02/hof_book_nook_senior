import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:http/http.dart' as http;

class ConfirmPurchasePage extends StatefulWidget {
  final Map<String, dynamic> forSaleBook;
  final String sellerName;
  final String buyerName;
  final String buyerEmail;
  final String sellerEmail;
  const ConfirmPurchasePage(this.forSaleBook, this.sellerName, this.buyerName,
      this.buyerEmail, this.sellerEmail);
  @override
  State<ConfirmPurchasePage> createState() => ConfirmPurchasePageState(
      this.forSaleBook,
      this.sellerName,
      this.buyerName,
      this.buyerEmail,
      this.sellerEmail);
}

class ConfirmPurchasePageState extends State<ConfirmPurchasePage> {
  Map<String, dynamic> forSaleBook;
  String sellerName;
  String buyerName;
  String buyerEmail;
  String sellerEmail;
  ConfirmPurchasePageState(this.forSaleBook, this.sellerName, this.buyerName,
      this.buyerEmail, this.sellerEmail);

  int purchase_step = 1;

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
  Future getReferenceIDs() async {
    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('ISBN', isEqualTo: forSaleBook['ISBN'])
        .where('Seller', isEqualTo: sellerEmail)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              forSaleReference = document.reference.id;
            },
          ),
        );
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
      "header":
          buyerName + " wants to buy your book! Please set up a meeting time!",
      "message": buyerName +
          " wants to buy " +
          forSaleBook["Title"] +
          " for " +
          forSaleBook["Price"] +
          " credits.",
      "read": "false",
      "recipient": sellerEmail,
      "sender": buyerEmail,
      "transaction_ID": transaction_ID,
      "type": "purchase"
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
      'status': "purchase",
      'transaction_ID': code,
      'step': purchase_step
    });
    sendNotification(code);
    emailSeller(
        user_name: buyerName,
        textbook_name: forSaleBook['Title'],
        seller_email: sellerEmail);
    await getReferenceIDs();
    final saleDocument = FirebaseFirestore.instance
        .collection('textbooks')
        .doc(forSaleReference);
    saleDocument.update({
      'InNegotiations': true,
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    // Navigator.push(context,
    //   MaterialPageRoute(builder: (BuildContext context) {
    //   return HomePage();
    // }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Align(
                  alignment: Alignment.centerLeft, child: Text("Confirm")),
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
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    print("creating transaction");
                    //print(sellerEmail);
                    //emailSeller(user_name: buyerName, textbook_name: forSaleBook["Title"].toString(), seller_email: sellerEmail);
                    createTransaction();
                    // This is where the purchase will be truly confirmed. Send email to other user notifying
                  }, // route to account page
                  child: Text(
                    'Confirm Purchase',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
                /*Text("Seller is " + sellerName),
                      SizedBox(height: 5,),
                      Text("Buyer is " + buyerName),
                      SizedBox(height: 5,),
                      Text("Buyer email is " + buyerEmail.toString()),
                      SizedBox(height: 5,),
                      Text("for sale book is " + forSaleBook.toString()), */
              ]),
            ),
          ),
        )));
  }
}
