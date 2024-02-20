import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/transactions/confirm_exchange_page.dart';
import 'package:the_hof_book_nook/pages/transactions/confirm_purchase.dart';

class PurchasePage extends StatefulWidget {
  final Map<String, dynamic> itemID;
  const PurchasePage(this.itemID);
  @override
  State<PurchasePage> createState() => _PurchasePageState(this.itemID);
}

class _PurchasePageState extends State<PurchasePage> {
  Map<String, dynamic> itemID;
  _PurchasePageState(this.itemID);

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
          .where('InNegotiations', isEqualTo: false)
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
    for (bReferences in buyerReferences) {
      var docSnapshot = await collection.doc(bReferences).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? item = docSnapshot.data();
        buyerBooks.add(item);
      }
    }
    //print("Buyer References is of length " + buyerReferences.length.toString());
    //print("Buyer Books is of length " + buyerBooks.length.toString() );
    //print(buyerBooks);
  }

  List<dynamic> wishBooks = [];
  var wishISBN;

  Future getWishBooks() async {
    List<dynamic> wishReferences = [];
    print("In getWishBooks");
    //print(itemID["Seller"]);
    await FirebaseFirestore.instance
        .collection('wishlist')
        .where('User', isEqualTo: itemID["Seller"])
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
    for (references in wishReferences) {
      var docSnapshot = await collection.doc(references).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? item = docSnapshot.data();
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
    if (countRuns == 1) {
      await getWishBooks();
      await getBuyerBooks();
    } else {
      print("did this already");
    }
    // List<String> crossReference = ["Exchangeables", "No Items Available"];
    int wL = wishBooks.length;
    print("length of Wl = " + wL.toString());
    int bL = buyerBooks.length;
    print("length of bL = " + bL.toString());
    var wishItem;
    var buyerItem;
    print("going to for loop");
    for (wishItem in wishBooks) {
      print("in loop 1 - " + wishItem["ISBN"]);
      for (buyerItem in buyerBooks) {
        print("Comparing " + wishItem["ISBN"] + " to " + buyerItem["ISBN"]);
        if (wishItem["ISBN"] == buyerItem["ISBN"]) {
          if (crossReference.contains(wishItem["Title"])) {
            print("already there");
          } else {
            String textbook = wishItem["Title"];
            crossReference.add(textbook);
          }
        }
      }
    }
    print(crossReference);
    if (crossReference.length > 1) {
      crossReference.remove("No Items Available");
    }

    return crossReference;
  }

  String difference = "N/A";
  int buyerPrice = 0;
  Map<String, dynamic> exchangeBook = {};

  calculateDifference(var exItem) {
    print("Calculating differece");
    var book;
    if (exItem == "Exchangeables" || exItem == "No Items Available") {
      difference = "N/A";
      print("No calc needed");
      return;
    } else {
      for (book in buyerBooks) {
        print("In other loops");
        if (book["Title"] == exItem) {
          print("exchange book is " + book.toString());
          buyerPrice = int.parse(book["Price"]);
          print("buyer price = " + buyerPrice.toString());
          print("exchange author is " + book["Author"]);
          exchangeBook = book;
        }
      }
    }
    print("Book for sale is + " + itemID.toString());
    print("for sale item price = " + itemID.toString());
    int priceDif = int.parse(itemID["Price"]) - buyerPrice;
    difference = priceDif.toString();
  }

  var buyerName = "";
  Future getBuyerName() async {
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

  var sellerName = "";
  Future getSellerName() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: itemID["Seller"]);
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

  /*var sellerEmail = "";
  Future getSellerEmail() async{
  var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: itemID["Seller"]);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var sellerEmail = data['Seller'];
    }
    await getBuyerName();
  }*/

  Future confirmExchangePageRoute() async {
    await getSellerName();
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ConfirmExchangePage(itemID, exchangeBook, sellerName, buyerName,
          difference, itemID["Seller"].toString(), user.email.toString());
    }));
  }

  Future confirmPurchasePageRoute() async {
    await getSellerName();
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ConfirmPurchasePage(itemID, sellerName, buyerName,
          user.email.toString(), itemID["Seller"].toString());
    }));
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
        body: FutureBuilder(
            future: compareBooks(),
            builder: (context, snapshot) {
              return Center(
                  child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        Image.network(itemID['Cover'],
                        scale: 1,),
                    
                        SizedBox(width: 20),
                          
                        Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      itemID['Title'],
                                      style: GoogleFonts.merriweather(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Condition: " + itemID['Condition'],
                                      style: GoogleFonts.merriweather(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Price: " + itemID['Price'] + " credits",
                                      style: GoogleFonts.merriweather(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            confirmPurchasePageRoute();
                          }, // route to account page
                          child: Text(
                            'Purchase with Credits',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 80),
                        DropdownButton(
                          value: exchangeValue,
                          underline: Container(
                            height: 2,
                            color: Color.fromARGB(255, 105, 173, 222),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: crossReference.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            // This is called when the user selects an item.
                            setState(() {
                              exchangeValue = newValue!;
                            });
                            await calculateDifference(exchangeValue);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Remaining Credit Due: " + difference.toString(),
                          style: GoogleFonts.merriweather(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            confirmExchangePageRoute();
                          }, // route to account page
                          child: Text(
                            'Exchange',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            }));
  }
}
