import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';

class OfferReceivedPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  const OfferReceivedPage(this.transactionData, this.transactionReference,
      this.notificationReference);
  @override
  State<OfferReceivedPage> createState() => OfferReceivedPageState(
      this.transactionData,
      this.transactionReference,
      this.notificationReference);
}

class OfferReceivedPageState extends State<OfferReceivedPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  OfferReceivedPageState(this.transactionData, this.transactionReference,
      this.notificationReference);

  String remainderText = "";
  checkRemainder() {
    int remainder = int.parse(transactionData['remainder']);
    if (remainder < 0) {
      remainderText =
          "You would pay buyer " + (-remainder).toString() + " credits";
    }
    if (remainder == 0) {
      remainderText = "No credits would be owed";
    } else {
      remainderText =
          "Buyer would also pay " + remainder.toString() + " credits";
    }
  }

  var saleTextbookReference = "";
  Future findTextbook(String ISBN, String Buyer) async {
    print("getting Textbook");
    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('ISBN', isEqualTo: ISBN)
        .where('Seller', isEqualTo: Buyer)
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

  void showDialogBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('End of Demo'),
            content: Text(
                'This concludes our demo next step is setting up a meet-up'),
            actions: [
              TextButton(
                //textColor: Colors.black,
                onPressed: () {
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NotificationPage();
                      },
                    ),
                  );
                },
                child: Text('Mark as Read'),
              ),
            ],
          ),
        );
      },
    );
  }

  offerAccepted() {
    // Sends them to set up meet-up page
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
    transaction_document.update({
      'status': "meet-up",
    });

    // update transaction step to 5
    transaction_document.update({'step': 5});
    print("transactions updated");

    showDialogBox();
    print("ahh");
    ;
  }

  offerRejected() async {
    // update transaction status to "counter-offer"
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
    transaction_document.update({
      'status': "counter",
    });

    // update transaction step to 2
    transaction_document.update({'step': 2});

    print("transactions updated");

    // update notification to "read"
    final notification_document = FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationReference);
    notification_document.update({
      'read': true,
    });
    print("notification updated");

    // create a new notification for buyer
    sendNotification(
        transactionData['transaction_ID'],
        transactionData['seller'] +
            " has chosen to not accept exchange. Please accept or reject counter offer",
        transactionData['seller'] +
            " has chosen to not accept the exchange for " +
            transactionData['forSale']['Title'] +
            ". Please select to either purchase with credits or cancel transaction",
        transactionData['buyer_email'],
        transactionData['seller_email']);
    print("new notification uploaded");

    // send buyer email

    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['seller'] +
            " has chosen to not accept the exchange. Please go to app to either accept buying " +
            transactionData['forSale']['Title'] +
            " with credits or cancel the transaction.",
        sender_name: transactionData['seller'],
        receiver_name: transactionData['buyer'],
        receiver_email: transactionData['buyer_email']);
    print("email sent");

    // Update for Exchange Textbook inNegotiations status to False
    await findTextbook(
        transactionData['forSale']['ISBN'], transactionData['buyer']);
    final forExchange_document = FirebaseFirestore.instance
        .collection('textbooks')
        .doc(saleTextbookReference);
    forExchange_document.update({
      'InNegotiations': false,
    });

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
    checkRemainder();
    return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Offer for Order " +
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
                    "Buyer: " + transactionData['buyer'],
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Exchange Offer: ",
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
                      transactionData['forExchange']['Cover'],
                      scale: 1,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              transactionData['forExchange']['Title'],
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
                                  transactionData['forExchange']['Condition'],
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
                                  transactionData['forExchange']['Price'] +
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
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    remainderText,
                    style: GoogleFonts.merriweather(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("rawr");
                    offerAccepted();
                  }, // route to account page
                  child: Text(
                    'Accept Offer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print("boo");
                    offerRejected();
                  }, // route to account page
                  child: Text(
                    'Request Credit Only',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
          ),
        )));
  }
}
