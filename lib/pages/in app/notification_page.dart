import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/pages/transactions/offer_received_page.dart';
import 'package:the_hof_book_nook/read%20data/get_notification_info.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> myNotificationRefernces = [];
  List<String> myTransactionRefernces = [];

  
  whereTo(var transaction, transaction_reference, notification_reference){
    print('in whereTo');
    var getStatus = transaction['status'];
    print('Status of transaction is ' + getStatus);
    if(getStatus == "offer"){
      Navigator.push(context,
       MaterialPageRoute(
         builder: (context) {
         return OfferReceivedPage(transaction, transaction_reference, notification_reference); },
       ),
     );
    }
    // 
  }

  //get textbooks
  Future getNotifications() async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .where('recipient', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              myNotificationRefernces.add(document.reference.id);
              print(myNotificationRefernces);
            },
          ),
        );
  }

  var myTransactionRefernce = "";
  Future getTransactions(var id_num) async {
    print("in get Transactions");
    await FirebaseFirestore.instance
        .collection('transactions')
        .where('transaction_ID', isEqualTo: id_num)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              myTransactionRefernce = document.reference.id;
            },
          ),
        );
  }

  void showDialogBox(String index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Notifications'),
            content: Text('Would you like to mark this as read?'),
            actions: [
              TextButton(
                //textColor: Colors.black,
                onPressed: () async {
                  final document = FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(index);
                  document.update({
                    'read': true,
                  });
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
              TextButton(
                //Add another text box here BAM view notification content
                //If notification is about book exchange, send to Exchange UI
                //If notification is about book purchase, send to Purchase UI
                //If notification is about counter offer, send to Counter UI
                //If notification is about support message sent(?), send to that UI
                //etc etc etc for any other notifications
                onPressed: () async {
                  print("Getting Notification");
                  final document = FirebaseFirestore.instance.collection('notifications').doc(index);
                  var queryNotificationSnapshot = await document.get();
                  Map<String, dynamic> notifData = queryNotificationSnapshot.data()!;
                  var transaction_ID = notifData['transaction_ID'];
                  print("Got transaction id from notifications its " + transaction_ID.toString());

                  await getTransactions(transaction_ID);
                  print("got transaction reference ID its " + myTransactionRefernce);
                  final document2 = FirebaseFirestore.instance.collection('transactions').doc(myTransactionRefernce);
                  var queryTransactionSnapshot = await document2.get();
                  Map<String, dynamic> transactionData = queryTransactionSnapshot.data()!;

                  whereTo(transactionData, myTransactionRefernce, index);

                  // Navigator.popUntil(context, (route) => false);
                  // Navigator.push(context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //     return NotificationPage(); },
                  //   ),
                  // );
                

                },
                child: Text('View Full Message'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Notifications")),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage(
                            showRegisterPage: () {},
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize
                      .min, // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return HomePage();
                        }));
                      }, // route to account page
                      child: Text(
                        'Home',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MyListingsPage();
                        }));
                      }, // route to my page ... this page ...
                      child: Column(
                        children: [
                          Text('My'),
                          Text('Listings'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return accountPage();
                        }));
                      },
                      child: Column(
                        children: [
                          Text('My'),
                          Text('Account'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return NotificationPage();
                      }));
                    }, // route to account page
                    child: Text('Notifications'),
                  ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getNotifications(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: myNotificationRefernces.length,
                      itemBuilder: ((context, index) {
                        if (myNotificationRefernces.isNotEmpty) {
                          
                          return ListTile(
                            leading: GetRead(
                              readIcon: myNotificationRefernces[index],
                            ),
                            title: GetHeader(
                              newHeader: myNotificationRefernces[index],
                            ),
                            subtitle: GetMessage(
                              newMessage: myNotificationRefernces[index],
                            ),
                            trailing: Icon(
                              Icons.square_outlined,
                            ),
                            onTap: () => showDialogBox(myNotificationRefernces[
                                index]), 
                          );
                        } else {
                          return SizedBox(height: 20);
                        }
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }
}