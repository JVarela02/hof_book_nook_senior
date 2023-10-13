// import 'dart:html';

// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_hof_book_nook/auth/auth_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/txtinput_page.dart';
import 'package:the_hof_book_nook/read%20data/get_account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hof_book_nook/read%20data/get_textbook_info.dart';
import '../sign ins/login_page.dart';
import '../sign ins/register_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _searchController = TextEditingController();
  String dropdownValue = "Search Type";
  var list = ["Search Type", "ISBN", "Author", "Title"];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 1.0),
            child: Align(alignment: Alignment.centerLeft, child: Text("Home")),
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
                    child: Text('Home'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyListingsPage();
                      }));
                    }, // route to my page ... this page ...
                    child: Text('My Listings'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return accountPage();
                      }));
                    },
                    child: Text(
                      'My Account',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButton(
              value: dropdownValue,
              underline: Container(
                height: 2,
                color: Color.fromARGB(255, 105, 173, 222),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 207, 230, 247),
                  border: Border.all(
                      color: const Color.fromARGB(255, 235, 235, 235),
                      width: 3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Criteria",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                onPressed:
                    // searchMaterial(),
                    () {
                  var route = MaterialPageRoute(
                    builder: (BuildContext context) => ResultsPage(
                        dropdownValue: dropdownValue,
                        searchCriteria: _searchController.text.toString()),
                  );
                  Navigator.of(context).push(route);
                  // Navigator.push(
                  //   context,
                  //      MaterialPageRoute(
                  //         builder: (context) {
                  //         return MyListingsPage();
                  //        },
                  //      ),);
                },
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  final String dropdownValue;
  final String searchCriteria;
  const ResultsPage(
      {super.key, required this.dropdownValue, required this.searchCriteria});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<String> searchRefernces = [];
  final user = FirebaseAuth.instance.currentUser!;
  List<String> userreference = [];

  Future getUsers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference.id);
              userreference.add(document.reference.id);
            },
          ),
        );
  }

  Future sendEmail({
    required String name,
    required String email,
    required String textbook,
    required String selleremail,
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
          'user_name': name,
          'user_email': email,
          'seller_email': selleremail,
          'textbook_name': textbook,
        }
      }),
    );

    print(response.body);
    showEmailResponseDialogBox();
  }

  void showEmailResponseDialogBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Email Sent!'),
            content: Text('The email was successfully sent to the buyer.'),
            actions: [
              TextButton(
                //textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OKAY'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future showDialogBox(String index) async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email);
    var querySnapshot = await collection.get();
    var finalName = "";
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var firstName = data['first name'];
      var lastName = data['last name'];
      String fullName = firstName + " " + lastName;
      finalName = fullName;
    }

    var sellercollection =
        FirebaseFirestore.instance.collection('textbooks').doc(index);
    var querySellerSnapshot = await sellercollection.get();
    var SellerEmail = "";
    Map<String, dynamic> data = querySellerSnapshot.data()!;
    String FullEmail = data['Seller'];
    SellerEmail = FullEmail;
    print(FullEmail);

    var namecollection =
        FirebaseFirestore.instance.collection('textbooks').doc(index);
    var queryNameSnapshot = await namecollection.get();
    var txtName = "";
    Map<String, dynamic> data2 = querySellerSnapshot.data()!;
    String textbookName = data2['Title'];
    txtName = textbookName;
    String txtAuthorName = data2['Title'] + " By: " + data2['Author'];
    String detailDescription = data2['Description'];
    String link = data2['Cover'];
    print(textbookName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text(txtAuthorName),
            //title: Text('Interested in this book?'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(link),
                  Text(detailDescription + '\n \nInterested in this book? Email the seller of this book!'),
                ],
              ),
            ),
            actions: [
              TextButton(
                //textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL'),
              ),
              TextButton(
                //textColor: Colors.black,
                onPressed: () async {
                  await getUsers();
                  sendEmail(
                      name: finalName, //current user name
                      email: user.email.toString(), // user's email address
                      textbook: txtName, //when api is implemented
                      selleremail: SellerEmail); // seller's email address
                  Navigator.of(context).pop();
                },
                child: Text('SEND EMAIL'),
              ),
            ],
          ),
        );
      },
    );
  }

  //get texbooks
  Future getTextbookResults() async {
    if (widget.dropdownValue == "Search Type") {
      Navigator.of(context).pop();
      HomePage();
    }
    if (widget.dropdownValue == "ISBN") {
      await FirebaseFirestore.instance
          .collection('textbooks')
          .where('ISBN', isEqualTo: widget.searchCriteria.toString())
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                print(document.reference.id);
                searchRefernces.add(document.reference.id);
              },
            ),
          );
    }
    if (widget.dropdownValue == "Author") {
      await FirebaseFirestore.instance
          .collection('textbooks')
          .where('Author', isEqualTo: widget.searchCriteria.toString())
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                print(document.reference.id);
                searchRefernces.add(document.reference.id);
              },
            ),
          );
    }
    if (widget.dropdownValue == "Title") {
      await FirebaseFirestore.instance
          .collection('textbooks')
          .where('Title', isEqualTo: widget.searchCriteria.toString())
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                print(document.reference.id);
                searchRefernces.add(document.reference.id);
              },
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Search Results")),
          ),
        ),
      ),
      body:
          //Container(
          //child:
          FutureBuilder(
        future: getTextbookResults(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: searchRefernces.length,
            itemBuilder: ((context, index) {
              if (searchRefernces.isNotEmpty) {
                return ListTile(
                  leading: GetCover(coverForSale: searchRefernces[index]), // This will turn into photo of textbook
                  title: GetTitle(
                    titleForSale: searchRefernces[index],
                  ), 
                  subtitle:
                      GetCondition(conditionForSale: searchRefernces[index]),
                  trailing: GetPrice(priceForSale: searchRefernces[index]),
                  onTap: () => {
                    showDialogBox(searchRefernces[index])
                  }, // Will be used for "In Negotiations" if done
                );
              } else {
                print("No Results found" + searchRefernces[index]);
                return SizedBox(child: Text("No Results Were Found"));
              }
            }),
          );
        },
      ),
    );
  }
}
