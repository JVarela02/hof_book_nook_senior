import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/active_transactions.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';


class BuyerReceiptPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  final String version;
  const BuyerReceiptPage(this.transactionData, this.transactionReference,
      this.notificationReference, this.version);
  @override
  State<BuyerReceiptPage> createState() => BuyerReceiptPageState(
      this.transactionData,
      this.transactionReference,
      this.notificationReference, this.version);
}

class BuyerReceiptPageState extends State<BuyerReceiptPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  final String version;
  BuyerReceiptPageState(this.transactionData, this.transactionReference,
      this.notificationReference,this.version);


  final user = FirebaseAuth.instance.currentUser!;

  getUserInfo (var email) async{
    var userID;
    print("getting user " + email);
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              userID = document.reference.id;
            },
          ),
        );
    return userID;
  }

  getCreditAmount(var userReference) async{
    print("gettings credits for " + userReference);
    //int creditInAccount = 0;
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userReference).get();
    if (docSnapshot.exists) {
      print("in if");
      Map<String, dynamic>? data = docSnapshot.data();
      int creditInAccount = data?['credits'];
      print("amount of credits is " + creditInAccount.toString());
      return creditInAccount;
  }
    //return creditInAccount;
  }

  transactionComplete() async {
      print("in transacation complete");

      // TRANSFER CREDITS 
      int cost = int.parse(transactionData['forSale']['Price']);
      var seller = await getUserInfo(transactionData['seller_email']);
      int sellerCredits = await getCreditAmount(seller);
      // Add credits to seller
      var newCredit = sellerCredits + cost;
      final creditExchange = FirebaseFirestore.instance.collection('users').doc(seller);
        creditExchange.update({'credits': newCredit,});
      
      // Send notification and email to buyer 
      sendNotification(
        transactionData['transaction_ID'],
        transactionData['buyer'] +
            " has marked " + transactionData['forSale']['Title'] + "as received",
        transactionData['buyer'] +
            " has marked " +
            transactionData['forSale']['Title'] +
            " as received at " + transactionData['meetup'][0] + ". This transaction has now been marked as complete. If there are any issues please use our 'Get Support' page located in your 'My Account' tab",
        transactionData['seller_email'],
        transactionData['buyer_email']);
    print("new notification uploaded");

    // send buyer email
    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['buyer'] +
            " has marked " +
            transactionData['forSale']['Title'] +
            " as received. The transaction has now been marked as complete. If there are any issues with your transaction please use the 'Get Support' page located in app. Thank you for using Hof Book Nook!" ,
        sender_name: transactionData['buyer'],
        receiver_name: transactionData['seller'],
        receiver_email: transactionData['seller_email']);
    print("email sent");

    // Change status to "Complete"
      final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
        transaction_document.update({
          'status': "Complete",
        });
      
      // Mark Notification as read (if applicapble) and pop back to correct page
      print(notificationReference);
      if (notificationReference != "0") {
      final notification_document = FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationReference);
      notification_document.update({
        'read': true,
      });
      print("notification updated");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return NotificationPage();
        }));
    } else {
      print("ha nope no notification");
      Navigator.pop(context);
      Navigator.pop(context);
      //Navigator.pop(context);
      //Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return ActTransPage();}));
    }
  }

  exhangeDelivered() async {
      // Change status to "Exchange Delivered"
      final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
        transaction_document.update({
          'status': "Exchange Delivered",
        });
      
      // Send notification and email to buyer 
      sendNotification(
        transactionData['transaction_ID'],
        transactionData['seller'] +
            " has marked " + transactionData['forExchange']['Title'] + "as devliered",
        transactionData['seller'] +
            " has marked " +
            transactionData['forSale']['Title'] +
            " as received and" + transactionData['forExchange']['Title'] + "as devliered at " + transactionData['meetup'][0] + "please confirm your receipt of the exchange at this time",
        transactionData['seller_email'],
        transactionData['buyer_email']);
    print("new notification uploaded");

    // send buyer email
    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['seller'] +
            " has marked " +
            transactionData['forSale']['Title'] +
            " as received and " + transactionData['forExchange']['Title'] + "as devliered. Please head over to the app to confirm your receipt of the exchange item",
        sender_name: transactionData['buyer'],
        receiver_name: transactionData['seller'],
        receiver_email: transactionData['seller_email']);
    print("email sent");
      
      // Mark Notification as read (if applicapble) and pop back to correct page
      print(notificationReference);
      if (notificationReference != "0") {
      final notification_document = FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationReference);
      notification_document.update({
        'read': true,
      });
      print("notification updated");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return NotificationPage();
        }));
    } else {
      print("ha nope no notification");
      Navigator.pop(context);
      Navigator.pop(context);
      //Navigator.pop(context);
      //Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return ActTransPage();}));
    }
  }


  @override
  Widget build(BuildContext context) {
    // Purchase version of the page ( no exchange )
    if(version == "purchase")
    {return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Receipt Order #" +
                      transactionData['transaction_ID'].toString())),
            ),
          ),
        ), 

        body: Center(
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Expanded(
                child: Center(
              child: Column(
                children: [
                  Text(
                    "Transaction #" +
                        transactionData['transaction_ID'].toString(),
                    style: GoogleFonts.merriweather(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        transactionData['forSale']['Cover'],
                        scale: 1.5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 275),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              transactionData['forSale']['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "by " + transactionData['forSale']['Author'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              transactionData['forSale']['Condition'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () async {
                      await transactionComplete();
                    },
                    child: Text(
                      "Confirm Receipt",
                      //style: TextStyle(color: Colors.white),
                      style: GoogleFonts.merriweather(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
          ),
        )),

    );
    }



    // Exchange version of the page 
    else{
      return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Setup Delivery Date Order #" +
                      transactionData['transaction_ID'].toString())),
            ),
          ),
        ), 

        body: Center(
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Expanded(
                child: Center(
              child: Column(
                children: [
                  Text(
                    "Transaction #" +
                        transactionData['transaction_ID'].toString(),
                    style: GoogleFonts.merriweather(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Purchase Received",
                    style: GoogleFonts.merriweather(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        transactionData['forSale']['Cover'],
                        scale: 1.5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 275),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              transactionData['forSale']['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "by " + transactionData['forSale']['Author'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              transactionData['forSale']['Condition'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),

                  Text(
                    "Exchange Delivered: ",
                    style: GoogleFonts.merriweather(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        transactionData['forExchange']['Cover'],
                        scale: 1.5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 275),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              transactionData['forExchange']['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "by " + transactionData['forExchange']['Author'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              transactionData['forExchange']['Condition'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () async {
                      final notification_document = FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(notificationReference);
                        notification_document.update({
                        'read': true,
                        });
                    },
                    child: Text(
                      "Confirm Receipt",
                      //style: TextStyle(color: Colors.white),
                      style: GoogleFonts.merriweather(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
          ),
        )),
    );
    }
  }
}
