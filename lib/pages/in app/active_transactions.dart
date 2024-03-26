import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/pages/transactions/counter_offer_page.dart';
import 'package:the_hof_book_nook/pages/transactions/notification_complete.dart';
import 'package:the_hof_book_nook/pages/transactions/offer_received_page.dart';
import 'package:the_hof_book_nook/read%20data/get_notification_info.dart';

class ActTransPage extends StatefulWidget {
  const ActTransPage({super.key});

  @override
  State<ActTransPage> createState() => _ActTransPageState();
}

class _ActTransPageState extends State<ActTransPage> {
   final user = FirebaseAuth.instance.currentUser!;
    List<dynamic> sellerList = [];
    List<dynamic> buyerList = [];
    List<String> transList = [];
    List<dynamic> userTrans = [];
    List<dynamic> transIDList = [];
    List<dynamic> status = [];
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
        if (data?['seller_email'] == user.email || data?['buyer_email'] == user.email) {
          sellerList.add(data?['seller']);
          buyerList.add(data?['buyer']);
          transIDList.add(data?['transaction_ID']);
          status.add(data?['status']);
        }
      }
      print(transList);
      print(sellerList);
      print(buyerList);
      //print(transIDList);
      print(status); 
      
       
  }

  }

  Text whoSell(index) {
      if(user.email == sellerList[index]) {
        return(Text("You are selling to " + buyerList[index]));
      } else {
        return(Text("You are buying from " + sellerList[index]));
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
                          onTap: () =>
                              print("Hi")
                              //showDialogBox(transIDList[index]),
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



  