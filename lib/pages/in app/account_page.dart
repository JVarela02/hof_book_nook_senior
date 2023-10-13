import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/removetxt_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/txtinput_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/read data/get_account_info.dart';

class accountPage extends StatefulWidget {
  const accountPage({super.key});

  @override
  State<accountPage> createState() => _accountPageState();
}

class _accountPageState extends State<accountPage> {

   final user = FirebaseAuth.instance.currentUser!;


  // full Names list
  List<String> fullNames = [];

  //get fullNames
   Future getfullName() async {
    await FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference);
          fullNames.add(document.reference.id);
        },
      ),
    );
  }


  // user names
  List<String> userNames = [];

  //get userNames
  Future getuserName() async {
    await FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference);
          userNames.add(document.reference.id);
        },
      ),
    );
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
              child: Text("Account Page")
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

  body: 
      Center(
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
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                       return HomePage();
                        }));
                      }, // route to account page
                      child: Text('Home'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                       return MyListingsPage();
                        }));
                      }, // route to my page ... this page ...
                      child: Text('My Listings'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                       return accountPage();
                        }));
                      },
                      child: Text('My Account', 
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
            ),
           

          SizedBox(height: 15,),

          Text("Signed in as: " + user.email!),

          SizedBox(height:30),

            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton( 
                onPressed: () {
                   Navigator.push(
                     context, 
                        MaterialPageRoute(
                           builder: (context) {
                           return TextbookInputPage();
                          },
                        ),);},
                child: Text("Add Listing",
                  style: TextStyle(color: Colors.white),
                ),      
              ),
            ),
          
          SizedBox(height: 30,),

            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton( 
                onPressed: () {
                   Navigator.push(
                     context, 
                        MaterialPageRoute(
                           builder: (context) {
                           return RemoveTextbookPage();
                          },
                        ),);},
                child: Text("Remove Listing",
                  style: TextStyle(color: Colors.white),
                ),         
              ),
            ),

          SizedBox(height: 30,),

            // SizedBox(
            //   height: 60,
            //   width: 300,
            //   child: ElevatedButton( 
            //     onPressed: signout,
            //     child: Text("Sign Out",
            //       style: TextStyle(color: Colors.white),
            //     ),         
            //   ),
            // ),


          ],
        ),

      ),

    );
  }
}