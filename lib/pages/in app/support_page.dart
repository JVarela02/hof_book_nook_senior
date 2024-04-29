//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
// import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
// import 'package:the_hof_book_nook/read%20data/get_textbook_info.dart';
// import 'package:the_hof_book_nook/read%20data/get_account_info.dart';
import 'package:http/http.dart' as http;
import 'package:the_hof_book_nook/read%20data/get_notification_info.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final user = FirebaseAuth.instance.currentUser!;

  final _transactionIDController = TextEditingController();
  final _situationController = TextEditingController();

  @override
  void dispose() {
    _transactionIDController.dispose();
    _situationController.dispose();
    super.dispose();
  }

  Future getfullName() async {
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
    return finalName;
  }

  List<String> myTransactionReferences = [];

  Future getBuyerTransactions() async {
    await FirebaseFirestore.instance
        .collection('transactions')
        .where('buyer_email', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              var data = document.data();
              var transaction_id = data["transaction_ID"].toString();
              print(transaction_id);
              myTransactionReferences.add(transaction_id);
            },
          ),
        );
  }

  Future getSellerTransactions() async {
    await FirebaseFirestore.instance
        .collection('transactions')
        .where('seller_email', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              var data = document.data();
              var transaction_id = data["transaction_ID"].toString();
              print(transaction_id);
              myTransactionReferences.add(transaction_id);
            },
          ),
        );
  }

  Future get_transaction_id(element) async {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');

    var the_id = transactions.doc(element).get();
    return the_id;
  }

  Future errorChecking() async {
    bool check_id = false;

    var typed_id = _transactionIDController.text.toString();
    for (var element in myTransactionReferences) {
      if (typed_id == element) {
        check_id = true;
      } else {
        print("nope");
      }
    }

    //if (check_id == true) {
    //  print("YES IT IS HAHA");
    //} else {
    //  print("NO SIR");
    //}
    var sit_text = _situationController.text.toString();
    var id_text = _transactionIDController.text.toString();

    if (_transactionIDController.text.toString().isEmpty |
        _situationController.text.toString().isEmpty) {
      showEmptyErrorResponseDialogBox();
    } else if (check_id == false) {
      showWrongIdDialogBox();
    } else if ((sit_text.contains('.') |
        sit_text.contains('[') |
        sit_text.contains(']') |
        sit_text.contains('*') |
        sit_text.contains('`'))) {
      showUnallowedCharactersBox();
    } else if ((sit_text.contains('.') |
        id_text.contains('[') |
        id_text.contains(']') |
        id_text.contains('*') |
        id_text.contains('`'))) {
      showUnallowedCharactersBox();
    } else {
      var userName = await getfullName();
      emailSupport(
          username: userName,
          transaction: _transactionIDController.text.toString(),
          user_email: user.email.toString(),
          message: _situationController.text.toString());
    }
  }

  Future emailSupport({
    required String username,
    required String transaction,
    required String user_email,
    required String message,
  }) async {
    final serviceId = 'service_1lu743t';
    final templateId = 'template_0abhf5w';
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
          'username': username,
          'transaction': transaction,
          'user_email': user_email,
          'message': message,
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
            content: Text('The email was successfully sent to support.'),
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

  void showEmptyErrorResponseDialogBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('ERROR'),
            content: Text('Please make sure all information is filled out'),
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

  void showWrongIdDialogBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('ERROR'),
            content: Text('Please enter your valid transaction ID'),
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

  void showUnallowedCharactersBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('ERROR'),
            content: Text('Please do not use the following characters: .[]*`'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child:
                Align(alignment: Alignment.centerLeft, child: Text("Support")),
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 207, 230, 247),
                      border: Border.all(
                          color: Color.fromARGB(255, 235, 235, 235), width: 3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextField(
                        controller: _transactionIDController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Transaction ID",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 207, 230, 247),
                      border: Border.all(
                          color: Color.fromARGB(255, 235, 235, 235), width: 3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextField(
                        controller: _situationController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Situation",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      await getBuyerTransactions();
                      await getSellerTransactions();
                      errorChecking();
                      // emailSupport(username: "Must Fix", user_email: user.email.toString(), transaction: _transactionIDController.text.toString(), message: _situationController.text.toString())
                    },
                    child: Text(
                      "Email Support?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
