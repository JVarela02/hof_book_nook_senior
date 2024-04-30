import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/active_transactions.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';

class CounterOfferPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  const CounterOfferPage(this.transactionData, this.transactionReference,
      this.notificationReference);
  @override
  State<CounterOfferPage> createState() => CounterOfferPageState(
      this.transactionData,
      this.transactionReference,
      this.notificationReference);
}

class CounterOfferPageState extends State<CounterOfferPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  CounterOfferPageState(this.transactionData, this.transactionReference,
      this.notificationReference);

  List<dynamic> creditIDList = [];

  Future getCreditID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              creditIDList.add(document.reference.id);
            },
          ),
        );
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(creditIDList[0]).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var credits = data?['credits'];
      //print(credits);
      //print(creditIDList[0]);
      //print(credits.runtimeType);
      creditIDList.add(credits);
      //print(creditIDList);
       
  }

  }

  List<dynamic> sellerCreditIDList = [];

  Future getCreditIDSeller() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: transactionData['seller_email'])
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


  var saleTextbookReference = "";
  Future findTextbook(String txtID, String Seller) async {
    print("getting Textbook");
    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('Textbook ID', isEqualTo: txtID)
        .where('Seller', isEqualTo: Seller)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              saleTextbookReference = document.reference.id;
            },
          ),
        );
  }

  counterAccepted() async {
    // Updates transaction status to "meet-up (s)"
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
    transaction_document.update({
      'status': "purchase",
    });


    // creates a new notification for seller
    sendNotification(
        transactionData['transaction_ID'],
        transactionData['buyer'] +
            " has chosen to accept purchase with credits. Please choose a meet-up date",
        transactionData['buyer'] +
            " has chosen to accept the counter offer for " +
            transactionData['forSale']['Title'] +
            ". Please select a meet-up date, time, and location that works for you",
        transactionData['seller_email'],
        transactionData['buyer_email']);
    print("new notification uploaded");

    // emails seller
    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['buyer'] +
            " has chosen to accept the counter offer for " +
            transactionData['forSale']['Title'] +
            ". Please got to the app to select a meet-up time",
        sender_name: transactionData['buyer'],
        receiver_name: transactionData['seller'],
        receiver_email: transactionData['seller_email']);
    print("email sent");


    // updates notification to "read" if applicable and send back to applicable page
    if(notificationReference != "0" ){
      final notification_document = FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationReference);
      notification_document.update({
        'read': true,
      });
      print("notification updated");
      // send back to notification page
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return NotificationPage();
      }));
    }
    else{
      print("ha nope no notification");
      // send back to notification page
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return ActTransPage();}));
    }

    

  }

  counterRejected() async {
    // update transaction status to "canceled"
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
    transaction_document.update({
      'status': "canceled",
    });

    // update transaction step to 4
    transaction_document.update({'step': 4});

    print("transactions updated");

    // update notification to "read"
    if(notificationReference != 0 ){
    final notification_document = FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationReference);
    notification_document.update({
      'read': true,
    });
    print("notification updated");
    }
    else{
      print("ha nope no notification");
    }

    // create a new notification for seller
    sendNotification(
        transactionData['transaction_ID'],
        transactionData['buyer'] + " has chosen to not purchase with credits",
        transactionData['buyer'] +
            " has chosen to not accept the counter offer for " +
            transactionData['forSale']['Title'] +
            ". Your book will return to being listed for sale",
        transactionData['seller_email'],
        transactionData['buyer_email']);
    print("new notification uploaded");

    // send seller email

    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['buyer'] +
            " has chosen to not accept the counter offer for " +
            transactionData['forSale']['Title'] +
            ". Your book will return to being listed for sale",
        sender_name: transactionData['buyer'],
        receiver_name: transactionData['seller'],
        receiver_email: transactionData['seller_email']);
    print("email sent");

    // change status of inNegotiations of textbook to false
    await findTextbook(transactionData['forSale']['Textbook ID'], transactionData['seller']);
    final forSale_document = FirebaseFirestore.instance.collection('textbooks').doc(saleTextbookReference);
      forSale_document.update({'InNegotiations': false, });


    // send back to navigation page
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return NotificationPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Counter offer for Order " +
                      transactionData['transaction_ID'].toString())),
            ),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Expanded(
              child: Column(children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Seller: " + transactionData['seller'],
                    style: GoogleFonts.merriweather(
                      fontSize: 15,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Textbook For Sale: ",
                    style: GoogleFonts.merriweather(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Image.network(
                      transactionData['forSale']['Cover'],
                      scale: 1,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              transactionData['forSale']['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Condition: " +
                                  transactionData['forSale']['Condition'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Price: " +
                                  transactionData['forSale']['Price'] +
                                  " credits",
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
                SizedBox(height: 35),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    transactionData['seller'] +
                        " has chosen to reject an exchange and asks for a direct credit purchse instead. \n Please accept or deny using the buttons below.",
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print("rawr");
                    await getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + int.parse(transactionData['Price']),                                   
                              });
                              print("I should have subtracted by now.");
                              });
                    counterAccepted();
                  }, // route to account page
                  child: Text(
                    'Accept Counter Offer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + int.parse(transactionData['Price']),                                   
                              });
                              print("I should have subtracted by now.");
                              });
                    print("boo");
                    counterRejected();
                  }, // route to account page
                  child: Text(
                    'Cancel Purchase',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
          ),
        )));
  }
}
