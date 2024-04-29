import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/active_transactions.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';


class finalImageConfirmPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  final String version;
  final String imagePath;
  const finalImageConfirmPage(this.transactionData,this.transactionReference,this.notificationReference,this.version,this.imagePath);
  @override
  State<finalImageConfirmPage> createState() => finalImageConfirmPageState(
      this.transactionData,this.transactionReference,this.notificationReference,this.version,this.imagePath);
}

class finalImageConfirmPageState extends State<finalImageConfirmPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  final String version;
  final String imagePath;
  finalImageConfirmPageState(this.transactionData,this.transactionReference,this.notificationReference,this.version,this.imagePath);

  final user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();

  purchaseDelivered() async {
      // upload image to transaction
      //final imagesRef = storageRef.child("images");
      String fileName = "pDelivered" + transactionData['transaction_ID'].toString() + " - " + transactionData['seller'] +".jpg";
      print("file name is $fileName");
      final purchaseImageRef = storageRef.child("images/${fileName}");
      print("created ref for image $purchaseImageRef");
      File image = File(imagePath);
      print("have the image");

      await purchaseImageRef.putFile(image);
      print("done with upload");

      final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
      transaction_document.update({
          'purchase image name': fileName,
        });
        print("updated purchase image name");


      // Change status to "Purchase Delivered"
        transaction_document.update({
          'status': "Purchase Delivered",
        });

        print("updated status");
      
      // Send notification and email to buyer 
      sendNotification(
        transactionData['transaction_ID'],
        transactionData['seller'] +
            " has marked " + transactionData['forSale']['Title'] + "as devliered",
        transactionData['seller'] +
            " has marked " +
            transactionData['forSale']['Title'] +
            " as delivered at " + transactionData['meetup'][0] + "please confirm your receipt of this product at this time",
        transactionData['buyer_email'],
        transactionData['seller_email']);
    print("new notification uploaded");

    // send buyer email
    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['seller'] +
            " has marked " +
            transactionData['forSale']['Title'] +
            " as delivered. Please head over to the app to confirm your receipt of the product",
        sender_name: transactionData['seller'],
        receiver_name: transactionData['buyer'],
        receiver_email: transactionData['buyer_email']);
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
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return ActTransPage();}));
    }
  }

  exchangeDelivered() async {
      // upload image to transaction
      //final imagesRef = storageRef.child("images");
      String fileName = "eDelivered" + transactionData['transaction_ID'].toString() + " - " + transactionData['buyer'] + ".jpg";
      final exchangeImageRef = storageRef.child("images/${fileName}");
      File image = File(imagePath);

      await exchangeImageRef.putFile(image);

      final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
      transaction_document.update({
          'exchange image name': fileName,
        });


      // Change status to "Exchange Delivered"
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
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return NotificationPage();
        }));
    } else {
      print("ha nope no notification");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return ActTransPage();}));
    }
  }

  markDelivery() async {
    print(imagePath);
    if(transactionData['seller_email'] == user.email){
      // purchase delivered
      await purchaseDelivered();
    }
    else{
      //exchange delivered
      await exchangeDelivered();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: const Text('Display the Picture')),
      //The image is stored as a file on the device. Use the Image.file
          //constructor with the given path to display the image.
      body: 
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Expanded(
                child: Column(
                    children: [
                      Image.file(File(imagePath)),
                      SizedBox(height:15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200,40)),
                          onPressed: () async {
                            print("hello");
                            await markDelivery();
                            print("done");
                          },
                  child: const Text("Confirm Delivery"),),
                    ],
                  ),
              ),
            ),
          )));
    }
  }

