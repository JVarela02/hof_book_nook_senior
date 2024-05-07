import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/active_transactions.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/pages/transactions/final_picture_confirmation_page.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';


class SellerDeliveryPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  final String version;
  const SellerDeliveryPage(this.transactionData, this.transactionReference,
      this.notificationReference, this.version);
  @override
  State<SellerDeliveryPage> createState() => SellerDeliveryPageState(
      this.transactionData,
      this.transactionReference,
      this.notificationReference, this.version);
}

class SellerDeliveryPageState extends State<SellerDeliveryPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  final String version;
  SellerDeliveryPageState(this.transactionData, this.transactionReference,
      this.notificationReference,this.version);


  final user = FirebaseAuth.instance.currentUser!;

  var firstCamera;
  late CameraController controller;
  late Future<void> initControllerFuture;

  Future getCameras() async {
      final cameras = await availableCameras();
      final firstCamera = cameras[0];
      controller = CameraController(firstCamera, ResolutionPreset.medium,);
      initControllerFuture = controller.initialize();
      await initControllerFuture;
      CameraPreview(controller);
      /*await Navigator.of(context).push(MaterialPageRoute(builder: ((context) => DisplayFeedScreen(
        controllers: controller
      )))); */
      showDialog(
              context: context,
              builder: (BuildContext context) {
                return Expanded(
                  child: AlertDialog(
                    title: Text("Take Photo"),
                    content: Column(
                      children: [
                        Text("Please take a photo of the book you are delivering with the receiver's ID"),
                        CameraPreview(controller),
                      ],
                    ),
                    actions: [
                      TextButton(
                        //textColor: Colors.black,
                        onPressed: () async {
                          await takePicture();
                          //Navigator.of(context).pop();
                        },
                        child: Text('Take Picture'),
                      ),
                    ],
                  ),
                );
              },
            );
      //final image = await controller.takePicture();
      //await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPictureScreen(
      //        imagePath: image.path,)));
      //print(firstCamera);
  }

  Future takePicture() async {
    final cameras = await availableCameras();
      final firstCamera = cameras[0];
      controller = CameraController(firstCamera, ResolutionPreset.medium,);
      initControllerFuture = controller.initialize();
      await initControllerFuture;
      final image = await controller.takePicture();
      //await 
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => finalImageConfirmPage(transactionData,transactionReference,notificationReference,version,image.path,)));
      print("WE MADE IT BOYS");
  }

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

   void showErrorBox(var Version) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if(Version == 1){
          return Expanded(
            child: AlertDialog(
              title: Text('Already Delivered'),
              content: Text('You have already marked this book as delivered.\nPlease use the other button to confirm receipt of the exchanged book.\nThank you!'),
            ),
          );
      }
      else{
          return Expanded(
            child: AlertDialog(
              title: Text('Deliver Product First'),
              content: Text('You must deliver your product first in order to mark the receipt of an exchange item.\nPlease use the other button to confirm the delivery.\nThank you!'),
            ),
          );
      }
      }
    );
  }

  purchaseDelivered() async {
    if(transactionData['status'] == "Await"){
      await getCameras();}
      /*// Change status to "Purchase Delivered"
      final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
        transaction_document.update({
          'status': "Purchase Delivered",
        });
      
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
    }*/
    else{
      // pop up error that says item has already been marked as delivered 
      showErrorBox(1);
    }
  }

  transactionComplete() async {
    if(transactionData['status'] == "Await"){
      showErrorBox(2);
    }
    else{
      // TRANSFER CREDITS 
      int cost = int.parse(transactionData['remainder']);
      var buyer = await getUserInfo(transactionData['buyer_email']);
      int buyerCredits = await getCreditAmount(buyer);
      print("buyer is " + buyer + " with credits = " + buyerCredits.toString());
      var seller = await getUserInfo(transactionData['seller_email']);
      int sellerCredits = await getCreditAmount(seller);
      print("seller is " + seller + " with credits = " + sellerCredits.toString());
      print("cost is " + cost.toString());
      if(cost > 0){
        // Add credits to seller
        var newCredit = sellerCredits + cost;
        final creditExchange = FirebaseFirestore.instance.collection('users').doc(seller);
          creditExchange.update({'credits': newCredit,});
      }
      else if(cost < 0){
        // Add credits to buyer 
        var newCredit = buyerCredits + -(cost);
        print(newCredit);
        final creditExchange = FirebaseFirestore.instance.collection('users').doc(buyer);
          creditExchange.update({'credits': newCredit,});
      }
      else{
        // do nothing because price was even
        print("woohoo even exchange");
      }
      
      // Send notification and email to buyer 
      sendNotification(
        transactionData['transaction_ID'],
        transactionData['seller'] +
            " has marked " + transactionData['forExchange']['Title'] + "as received",
        transactionData['seller'] +
            " has marked " +
            transactionData['forExchange']['Title'] +
            " as received at " + transactionData['meetup'][0] + ". This transaction has now been marked as complete. If there are any issues please use our 'Get Support' page located in your 'My Account' tab",
        transactionData['buyer_email'],
        transactionData['seller_email']);
    print("new notification uploaded");

    // send buyer email
    await emailNotification(
        header: "Update for transaction " +
            transactionData['transaction_ID'].toString(),
        message: transactionData['seller'] +
            " has marked " +
            transactionData['forExchange']['Title'] +
            " as received. The transaction has now been marked as complete. If there are any issues with your transaction please use the 'Get Support' page located in app. Thank you for using Hof Book Nook!" ,
        sender_name: transactionData['seller'],
        receiver_name: transactionData['buyer'],
        receiver_email: transactionData['buyer_email']);
    print("email sent");

    // Change status to "Complete"
      print("transaction reference is: "+transactionReference);
      final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);
        transaction_document.update({
          'status': "Complete",
        });
        print("transaction updated");

    // Delete the forSale and forExchange textbook from DB 
    String forSaleReference = await findTextbook(transactionData['forSale']['Textbook ID'], transactionData['seller_email']);
    String forExchangeReference = await findTextbook(transactionData['forExchange']['Textbook ID'], transactionData['buyer_email']);
    FirebaseFirestore.instance.collection('textbooks').doc(forSaleReference).delete;
    FirebaseFirestore.instance.collection('textbooks').doc(forExchangeReference).delete;
      
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
                  child: Text("Confirm Delivery Order #" +
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
                      await purchaseDelivered();
                    },
                    child: Text(
                      "Confirm Delivery",
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
                  child: Text("Confirm Delivery Order #" +
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
                      await purchaseDelivered();
                    },
                    child: Text(
                      "Confirm Delivery",
                      //style: TextStyle(color: Colors.white),
                      style: GoogleFonts.merriweather(
                          fontSize: 15, color: Colors.white),
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
  }
}
