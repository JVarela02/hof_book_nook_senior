import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:http/http.dart' as http;


class ConfirmExchangePage extends StatefulWidget {
  final Map<String, dynamic> forSaleBook;
  final Map<String, dynamic> exchangeBook;
  final String sellerName;
  final String buyerName;
  final String priceDifference;
  final String sellerEmail;
  final String buyerEmail;
  const ConfirmExchangePage(this.forSaleBook, this.exchangeBook, this.sellerName, this.buyerName, this.priceDifference, this.sellerEmail, this.buyerEmail);
  @override
  State<ConfirmExchangePage> createState() => ConfirmExchangePageState(this.forSaleBook, this.exchangeBook, this.sellerName, this.buyerName, this.priceDifference, this.sellerEmail, this.buyerEmail);
}

class ConfirmExchangePageState extends State<ConfirmExchangePage> {
  Map<String, dynamic> forSaleBook;
    Map<String, dynamic> exchangeBook;
    String sellerName;
    String buyerName;
    String priceDifference;
    String sellerEmail;
    String buyerEmail;
  ConfirmExchangePageState(this.forSaleBook, this.exchangeBook, this.sellerName, this.buyerName, this.priceDifference, this.sellerEmail, this.buyerEmail);

final user = FirebaseAuth.instance.currentUser!;

  List<dynamic> buyerBooks = [];
  var buyerISBN;

  //get reference ID for credits
  Future getBuyerBooks() async {
    List<String> buyerReferences = [];
    print("In getBuyerBooks");
    await FirebaseFirestore.instance
          .collection('textbooks')
          .where('Seller', isEqualTo: user.email)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                //print(document.reference.id);
                buyerReferences.add(document.reference.id);
              },
            ),
          );
    var collection = FirebaseFirestore.instance.collection('textbooks');
    var bReferences;
    for(bReferences in buyerReferences){
      var docSnapshot = await collection.doc(bReferences).get();
      if(docSnapshot.exists){
        Map<String,dynamic>? item = docSnapshot.data();
        buyerBooks.add(item);
      }
    }
    //print("Buyer References is of length " + buyerReferences.length.toString());
    //print("Buyer Books is of length " + buyerBooks.length.toString() );
    //print(buyerBooks);
    }

  List<dynamic> wishBooks = [];
  var wishISBN;


  Future emailSeller({
    required String user_name,
    required String textbook_name,
    required String seller_email,
  }) async {
    final serviceId = 'service_1lu743t';
    final templateId = 'template_8tyuraq';
    final userId = 'O7K884SMxRo1npb9t';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': user_name,
          'seller_email' : seller_email,
          'textbook_name': textbook_name,
        }
      }),
    );
    print(response.body);
  }

  Future getWishBooks() async {
    List<dynamic> wishReferences = [];
    print("In getWishBooks");
    //print(forSaleBook["Seller"]);   
    await FirebaseFirestore.instance
          .collection('wishlist')
          .where('User', isEqualTo: forSaleBook["Seller"])
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                //print(document.reference.id);
                wishReferences.add(document.reference.id);
              },
            ),
          );
    var collection = FirebaseFirestore.instance.collection('wishlist');
    var references;
    for(references in wishReferences){
      var docSnapshot = await collection.doc(references).get();
      if(docSnapshot.exists){
        Map<String,dynamic>? item = docSnapshot.data();
        wishBooks.add(item);
      }
    }
    //print(wishBooks.length);
    //print(wishBooks);

    
    }

  int countRuns = 0;

  List<String> crossReference = ["Exchangeables", "No Items Available"];
  String exchangeValue = "Exchangeables";


  Future compareBooks() async {
    countRuns += 1;
    print("In compareBooks run: " + countRuns.toString());
    if(countRuns == 1){
    await getWishBooks();
    await getBuyerBooks();
    }
    else{
      print("did this already");
    }
    // List<String> crossReference = ["Exchangeables", "No Items Available"];
    int wL = wishBooks.length;
    print("length of Wl = " + wL.toString());
    int bL = buyerBooks.length;
    print("length of bL = "  + bL.toString());
    var wishItem;
    var buyerItem;
    print("going to for loop");
    for(wishItem in wishBooks){
      print("in loop 1 - " + wishItem["ISBN"]);
      for(buyerItem in buyerBooks){
        print("Comparing " + wishItem["ISBN"] + " to " + buyerItem["ISBN"]);
        if (wishItem["ISBN"] == buyerItem["ISBN"]){
          if(crossReference.contains(wishItem["Title"])){
            print("already there");
          }
          else{
          String textbook = wishItem["Title"]; 
          crossReference.add(textbook);
          }
        } 
      }
    }
    print(crossReference);
    if(crossReference.length > 1){
      crossReference.remove("No Items Available");
    }

    return crossReference;
  }

  String difference = "N/A";
  int buyerPrice = 0;
  //Map<String, dynamic> exchangeBook = {};


  calculateDifference(var exItem){
    print("Calculating differece");
    var book;
    if(exItem == "Exchangeables" || exItem == "No Items Available"){
      difference = "N/A";
      print("No calc needed");
      return;
    }
    else{
      for(book in buyerBooks){
        print("In other loops");
        if(book["Title"] == exItem){
          print("exchange book is " + book.toString());
          buyerPrice = int.parse(book["Price"]);
          print("buyer price = " + buyerPrice.toString());
          print("exchange author is " + book["Author"]);
          exchangeBook = book;
        }
      }
    }
    print("Book for sale is + " + forSaleBook.toString());
    print("for sale item price = " + forSaleBook.toString());
    int priceDif = int.parse(forSaleBook["Price"]) - buyerPrice;
    difference = priceDif.toString();
  }
  


  //var buyerName = "";
  Future getBuyerName() async{
  var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var firstName = data['first name'];
      var lastName = data['last name'];
      String fullName = firstName + " " + lastName;
      buyerName = fullName;
    }
  }

  Future sendNotification() async {
    final notification = <String, String> {
      "header" : buyerName+ " wants to buy your book!",
      "message" : buyerName+ " wants to exchange their "+exchangeBook["Title"]+" for your "+forSaleBook["Title"],
      "read" : "false",
      "recipient" : sellerEmail,
      "sender" : buyerEmail
    };
    var db = FirebaseFirestore.instance;
    db.collection("notifications").doc().set(notification);
  }

  //var sellerName = "";
  Future getSellerName() async{
  var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: forSaleBook["Seller"]);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var firstName = data['first name'];
      var lastName = data['last name'];
      String fullName = firstName + " " + lastName;
      sellerName = fullName;
    }
    await getBuyerName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Purchase")),
          ),
        ),
      ),
      body: 
      Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Expanded(
                  child: Column(
                    children: [
                      Row(
                      children: [
                        Image.network(forSaleBook['Cover'],
                        scale: 0.7,),
                    
                        SizedBox(width: 20),
                          
                        Expanded(
                              child: Column(
                                children: [
                    
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(forSaleBook['Title'],
                                    style: GoogleFonts.merriweather(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                     ),),
                                  ),
                    
                                  SizedBox(height:30),
                        
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Condition: " + forSaleBook['Condition'],
                                    style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                     ),),
                                  ),
                    
                                  SizedBox(height:30),
                        
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Price: " + forSaleBook['Price'] + " credits",
                                    style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                     ),),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.network(exchangeBook['Cover'],
                        scale: 0.7,),
                    
                        SizedBox(width: 20),
                          
                        Expanded(
                              child: Column(
                                children: [
                    
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(exchangeBook['Title'],
                                    style: GoogleFonts.merriweather(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                     ),),
                                  ),
                    
                                  SizedBox(height:30),
                        
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Condition: " + exchangeBook['Condition'],
                                    style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                     ),),
                                  ),
                    
                                  SizedBox(height:30),
                        
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Price: " + exchangeBook['Price'] + " credits",
                                    style: GoogleFonts.merriweather(
                                    fontSize: 15,
                                     ),),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15,),
                    
                    ElevatedButton(
                        onPressed: () {
                          sendNotification();
                          //emailSeller(user_name: buyerName, textbook_name: forSaleBook["Title"].toString(), seller_email: sellerEmail);
                          // This is where the purchase will be truly confirmed. Send email to other user notifying
                        }, // route to account page
                        child: Text('Send Exchange Offer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                      /*Text("Seller is " + sellerName),
                      SizedBox(height: 5,),
                      Text("Buyer is " + buyerName),
                      SizedBox(height: 5,),
                      Text("The price difference is " + priceDifference.toString()),
                      SizedBox(height: 5,),
                      Text("for sale book is " + forSaleBook.toString()),
                      SizedBox(height: 5,),
                      Text("Exchange book is " + exchangeBook.toString())
                      */
                    ]
                  ),
                ),
            ),
          )
      ));}}