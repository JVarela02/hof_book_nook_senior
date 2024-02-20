  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
//import 'package:the_hof_book_nook/pages/in%20app/support_page.dart';
import 'package:the_hof_book_nook/read%20data/get_textbook_info.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> myListingRefernces = [];

  //get textbooks
  Future getTextbooks() async {
    await FirebaseFirestore.instance
        .collection('textbooks')
        .where('Seller', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              myListingRefernces.add(document.reference.id);
            },
          ),
        );
  }

  /*void showDialogBox(String index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Change Status?'),
            content: Text('Do you want to change the status of this book?'),
            actions: [
              TextButton(
                //textColor: Colors.black,
                onPressed: () async {
                  final document = FirebaseFirestore.instance
                      .collection('textbooks')
                      .doc(index);
                  document.update({
                    'InNegotiations': true,
                  });
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) {
                    return MyListingsPage();
                    },
                  ),);
                },
                child: Text('CHANGE TO \'In Negotiations\''),
              ),
              TextButton(
                //textColor: Colors.black,
                onPressed: () async {
                  final document = FirebaseFirestore.instance
                      .collection('textbooks')
                      .doc(index);
                  document.update({
                    'InNegotiations': false,
                  });
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) {
                    return MyListingsPage();
                    },
                  ),);
                },
                child: Text('RESET STATUS'),
              ),
              TextButton(
                //textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL'),
              ),
            ],
          ),
        );
      },
    );
  }
  */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("My Listings")),
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
                mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return HomePage();
                      }));
                    }, // route to account page
                    child: Text('Home',
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
                        Text(
                          'My'
                        ),
                        Text(
                          'Listings'
                        ),

                      ],),
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
                      Text(
                      'My'
                    ),
                        Text(
                          'Account'
                        ),

                      ],),
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
                future: getTextbooks(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: myListingRefernces.length,
                    itemBuilder: ((context, index) {
                      if (myListingRefernces.isNotEmpty) {
                        return ListTile(
                          leading: GetCover(coverForSale: myListingRefernces[index],),// This will turn into photo of textbook
                          title: GetTitle(
                            titleForSale: myListingRefernces[index],
                          ), 
                          subtitle:
                              GetPriceCondition(conpriceForSale: myListingRefernces[index]),
                          trailing: Icon(
                            Icons.square_outlined,
                          ),
                          // onTap: () => showDialogBox(myListingRefernces[index]), // Will be used for "In Negotiations" if done // Update 2024: we no longer want users to manually switch this status
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
