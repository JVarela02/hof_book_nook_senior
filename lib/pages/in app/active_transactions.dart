import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/pages/transactions/buyer_receipt_page.dart';
import 'package:the_hof_book_nook/pages/transactions/counter_offer_page.dart';
import 'package:the_hof_book_nook/pages/transactions/delivery_proposal.dart';
import 'package:the_hof_book_nook/pages/transactions/meetup_confirm.dart';
import 'package:the_hof_book_nook/pages/transactions/notification_complete.dart';
import 'package:the_hof_book_nook/pages/transactions/offer_received_page.dart';
import 'package:the_hof_book_nook/pages/transactions/seller_delivery_page.dart';

class ActTransPage extends StatefulWidget {
  const ActTransPage({super.key});

  @override
  State<ActTransPage> createState() => _ActTransPageState();
}

class _ActTransPageState extends State<ActTransPage> {

checkType(var transaction){
    print("in checkType");
    var type;
    if (transaction['forExchange'] == null){
      type = "purchase";
    }
    else{
      type = "exchange";
    }
    print(type);
    return type;
  }

  void showErrorBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
          return Expanded(
            child: AlertDialog(
              title: Text('Still Not Open'),
              content: Text('It is still not your meet-up time. The page will open at that time.'),
            ),
          );
      }
    );
  }

  whereTo(var transaction, transaction_reference, notification_reference) {
    print('in whereTo');
    var getStatus = transaction['status'];
    String type = checkType(transaction);
    print('Status of transaction is ' + getStatus);
    int open = -2;
    if(getStatus == "Await")
      {String rightnowString = DateFormat(' MMM d, yyyy H:mm a').format(DateTime.now());
      var rightNow = DateFormat(' MMM d, yyyy H:mm a').parse(rightnowString);
      String meetTimeString = transaction['meetup'][1] + " " + transaction['meetup'][2];
      var meetTime = DateFormat(' MMM d, yyyy H:mm a').parse(meetTimeString);
      open = rightNow.compareTo(meetTime);
      if(open >= 0){
        print("open");
      }
      else{
        print("closed");
      }}
    else{
      open = -3;
    }

    // Offer Page Route
    if (getStatus == "offer") {
      print("in first if");
      if (transaction['seller_email'] == user.email) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OfferReceivedPage(
                  transaction, transaction_reference, notification_reference);
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    }
    else if (getStatus == "counter") {
      print("in second if");
      if (transaction['buyer_email'] == user.email) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CounterOfferPage(
                  transaction, transaction_reference, notification_reference);
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    }
    else if(getStatus == "purchase" || getStatus == "exchange"){
      if (transaction['seller_email'] == user.email) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DeliveryProposalPage(
                  transaction, transaction_reference, notification_reference);
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    }
    else if(getStatus == "incomplete"){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DeliveryProposalPage(
                  transaction, transaction_reference, notification_reference);
            },
          ),
        );
    }

    else if(getStatus == "Meetup-Offer"){
      if(transaction['buyer_email'] == user.email){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MeetupConfirmPage(
                  transaction, transaction_reference, notification_reference);
            },
          ),
        );
      }
      else{
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    }

    else if(getStatus == "Meetup-Counter"){
      if(transaction['seller_email'] == user.email){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MeetupConfirmPage(
                  transaction, transaction_reference, notification_reference);
            },
          ),
        );
      }
      else{
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    }

    else if(getStatus == "Await"){
      print(type);
      if(open >= 0){
        if(transaction['seller_email'] == user.email){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SellerDeliveryPage(
                    transaction, transaction_reference, notification_reference,type);
              },
            ),
          );
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NotifCompletePage();
              },
            ),
          );
        }}
        else{
          // ERROR DIALOGUE
          showErrorBox();
        }
    }

    else if(getStatus == "Purchase Delivered"){
      if(transaction['buyer_email'] == user.email){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BuyerReceiptPage(
                  transaction, transaction_reference, notification_reference,type);
            },
          ),
        );
      }
      else{
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    } 

    else if(getStatus == "Exchange Delivered"){
      if(transaction['seller_email'] == user.email){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SellerDeliveryPage(
                  transaction, transaction_reference, notification_reference,type);
            },
          ),
        );
      }
      else{
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
      }
    }

    else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NotifCompletePage();
            },
          ),
        );
    }

  }

   final user = FirebaseAuth.instance.currentUser!;
    List<dynamic> sellerList = [];
    List<dynamic> buyerList = [];
    List<String> transList = [];
    List<dynamic> userTrans = [];
    List<dynamic> transIDList = [];
    List<dynamic> status = [];
    List<dynamic> titleList = [];
    List<dynamic> sellerEmailList = [];
    List<dynamic> fullTransactionList = [];
    List<ElevatedButton> buttonsList = <ElevatedButton>[];

  /*List<Widget> _buildButtonsWithNames() {
    getTransactions();
    for (int i = 0; i < transIDList.length; i++) {
      buttonsList
          .add(new ElevatedButton(onPressed: null, child: Text(transIDList[i])));
    }
    return buttonsList;
  } */

  Future getTransactions() async {
    await FirebaseFirestore.instance
        .collection('transactions')
        //.where('buyer_email', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              transList.add(document.reference.id);
            },
          ),
        );
    var collection = FirebaseFirestore.instance.collection('transactions');
    for(int i = 0; i < transList.length; i++) {
    var docSnapshot = await collection.doc(transList[i]).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
        /*print(user.email);
        print(data?['seller_email']);
        print(data?['buyer_email']);
        print(data?['seller_email'].compareTo(user.email)); */
        if ((data?['seller_email'] == user.email || data?['buyer_email'] == user.email) && data?['status'] != "canceled") {
          sellerList.add(data?['seller']);
          sellerEmailList.add(data?['seller_email']);
          buyerList.add(data?['buyer']);
          transIDList.add(data?['transaction_ID']);
          status.add(data?['status']);
          titleList.add(data?['forSale']['Title']);
          fullTransactionList.add(data);
        }
      }
      // print(transList);
      // print(sellerList);
      // print(buyerList);
      // //print(transIDList);
      // print(status); 
      //print(fullTransactionList);
      
       
  }

  }

  Text whoSell(index) {
      //print("seller is " + sellerEmailList[index]);
      if(user.email == sellerEmailList[index]) {
        return(Text("You are selling " + titleList[index] + " to " + buyerList[index]));
      } else {
        return(Text("You are buying " + titleList[index] + " from " + sellerList[index]));
      }

      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
         const FittedBox(
           child: Padding(
             padding: EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Active Transactions")
              ),
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
                Navigator.push(context,MaterialPageRoute(
                           builder: (context) {
                           return LoginPage(showRegisterPage: () {  },);
                          },
                        ), );
              },
                child: const Text("Logout",
                style: TextStyle(
                  color : Colors.white,
                  fontWeight: FontWeight.bold,
                ))
                     ),
            ),
          )],    
     ),
      body: Center(child: Column(children: [
        Expanded(
              child: FutureBuilder(
                future: getTransactions(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: transIDList.length,
                    itemBuilder: ((context, index) {
                      if (transIDList.isNotEmpty) {
                        return ListTile(
                          /*leading: 
                                Text(transList[index]), */
                          title: 
                                whoSell(index),
                                 
                          subtitle:
                                Text("Transaction ID: "+ transIDList[index].toString()),
                          trailing: Icon(
                            Icons.square_outlined,
                          ),
                          onTap: () {
                              print("data being passed is " + transList[index]);
                              whereTo(fullTransactionList[index], transList[index], "0");
                              //showDialogBox(transIDList[index]),
                          }
                        );
                      } else {
                        return SizedBox(height: 20);
                      }
                    }),
                  );
                },
              ),
            )
     ]),)


      /*body: Center(
        child: Column(
          children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        getTransactions();
                        return ActTransPage();
                      }));
                    }, // route to account page
                    child: Text('Testing Fun Stuff',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]
              )
            ) */
        );
    
    
  }
}



  