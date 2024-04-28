import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/pages/transactions/delivery_proposal.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const theTask = "notifTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("we're doing the task!!! YIPPEE");
    switch (task) {
      case theTask:
        print(theTask);
    }
    throw '';
  });
}

class MeetupConfirmPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  const MeetupConfirmPage(this.transactionData, this.transactionReference,
      this.notificationReference);
  @override
  State<MeetupConfirmPage> createState() => MeetupConfirmPageState(
      this.transactionData,
      this.transactionReference,
      this.notificationReference);
}

class MeetupConfirmPageState extends State<MeetupConfirmPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  MeetupConfirmPageState(this.transactionData, this.transactionReference,
      this.notificationReference);

  final user = FirebaseAuth.instance.currentUser!;

  acceptDate() async {
    // update transaction status to "Await"
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
    transaction_document.update({
      'status': "Await",
    });

    print("transactions updated");

    // update notification to "read"
    if (notificationReference != 0) {
      final notification_document = FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationReference);
      notification_document.update({
        'read': true,
      });
      print("notification updated");
    } else {
      print("ha nope no notification");
    }

    // create a new notification for opposite person
    if (user.email == transactionData['seller_email']) {
      sendNotification(
          transactionData['transaction_ID'],
          transactionData['seller'] + " has accepted the meet-up date",
          transactionData['seller'] +
              " has accepted the proposed meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              ". You will receive more information on the day of the meet-up on how to complete the transaction",
          transactionData['buyer_email'],
          transactionData['seller_email']);
      print("new notification uploaded");
    } else {
      sendNotification(
          transactionData['transaction_ID'],
          transactionData['buyer'] + " has accepted meet-up time",
          transactionData['buyer'] +
              " has accepted the proposed meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              ". You will receive more information on the day of the meet-up on how to complete the transaction",
          transactionData['seller_email'],
          transactionData['buyer_email']);
      print("new notification uploaded");
    }

    // send alternative person email
    if (user.email == transactionData['seller_email']) {
      await emailNotification(
          header: "Update for transaction " +
              transactionData['transaction_ID'].toString(),
          message: transactionData['seller'] +
              " has accepted the proposed meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              " You will receive more infromation on the day of the meet-up on how to complete the transaction",
          sender_name: transactionData['seller'],
          receiver_name: transactionData['buyer'],
          receiver_email: transactionData['buyer_email']);
      print("email sent");
    } else {
      await emailNotification(
          header: "Update for transaction " +
              transactionData['transaction_ID'].toString(),
          message: transactionData['buyer'] +
              " has accepted the proposed meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              " You will receive more infromation on the day of the meet-up on how to complete the transaction",
          sender_name: transactionData['buyer'],
          receiver_name: transactionData['seller'],
          receiver_email: transactionData['seller_email']);
      print("email sent");
    }

    // send back to navigation page
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return NotificationPage();
    }));
  }

  rejectDate() {
    // update transaction to incomplete
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
    transaction_document.update({
      'status': "incomplete",
    });
    // pop this page
    Navigator.of(context).pop();
    // pop to proposal page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DeliveryProposalPage(
              transactionData, transactionReference, notificationReference);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(transactionData['meetup']);
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "For Sale Book: ",
                        style: GoogleFonts.merriweather(
                          fontSize: 15,
                        ),
                      ),
                      Image.network(
                        transactionData['forSale']['Cover'],
                        scale: 3,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        transactionData['forSale']['Title'] +
                            " by " +
                            transactionData['forSale']['Author'],
                        style: GoogleFonts.merriweather(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Proposed Location: ",
                        style: GoogleFonts.merriweather(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        transactionData['meetup'][0],
                        style: GoogleFonts.merriweather(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Proposed Date: ",
                        style: GoogleFonts.merriweather(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        transactionData['meetup'][1],
                        style: GoogleFonts.merriweather(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Proposed Time: ",
                        style: GoogleFonts.merriweather(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        transactionData['meetup'][2],
                        style: GoogleFonts.merriweather(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Workmanager().initialize(callbackDispatcher);
                          Workmanager().registerOneOffTask("1", theTask,
                              initialDelay: Duration(seconds: 15));
                          acceptDate();
                          //getTimes(locationValue, selectedDateText);
                        },
                        child: Text(
                          "Accept Meet-Up Appointment",
                          /*style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                    color: Colors.white
                                  ),*/
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          rejectDate();
                          //getTimes(locationValue, selectedDateText);
                        },
                        child: Text(
                          "Create Alternative\nMeet-Up Appointment",
                          /*style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                    color: Colors.white
                                  ),*/
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),
        )));
  }
}
