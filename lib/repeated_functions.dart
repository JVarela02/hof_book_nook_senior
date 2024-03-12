import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

Future sendNotification(int transaction_ID, var header, var message, var recipient, var sender) async {
    final notification = <String, dynamic> {
      "header" : header,
      "message" : message,
      "read" : "false",
      "recipient" : recipient,
      "sender" : sender,
      "transaction_ID" : transaction_ID
    };
    var db = FirebaseFirestore.instance;
    db.collection("notifications").doc().set(notification);
  }

Future emailNotification({
    required String header,
    required String message,
    required String sender_name,
    required String receiver_name,
    required String receiver_email
  }) async {
    final serviceId = 'service_1lu743t';
    final templateId = 'template_n3y35so';
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
          'header': header,
          'to_name' : receiver_name,
          'from_name': sender_name,
          'message' : message,
          'receiver_email' : receiver_email
        }
      }),
    );
    print(response.body);
  }

final user = FirebaseAuth.instance.currentUser!;
Future getLastName() async {
  var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var lastName = data['last name'];
      return lastName;
    }
}

    Future confirmUniqueID(var code, String where) async {
    List<dynamic> references = [];
    if(where == "transactions"){
      await FirebaseFirestore.instance
          .collection('transactions')
          .where('transaction_ID', isEqualTo: code)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                //print(document.reference.id);
                references.add(document.reference.id);
              },
            ),
          );
    }
    else if(where == "textbooks"){
      await FirebaseFirestore.instance
          .collection('textbooks')
          .where('Textbook ID', isEqualTo: code)
          .get()
          .then(
            (snapshot) => snapshot.docs.forEach(
              (document) {
                //print(document.reference.id);
                references.add(document.reference.id);
              },
            ),
          );
    }

    if (references.length > 1) {
      return false;
    } else {
      return true;
    }
  }


  Future idGenerator(int lengthRandom) async {
    String lastName = await getLastName();
    if(lengthRandom == 6){
      int code = Random().nextInt(899999) + 100000;
      bool unique = await confirmUniqueID(code, "transactions");
      if (unique == true) {
        print("Code Created = " + code.toString());
        return code;
      } else {      
        idGenerator(6);
      }
    }

    else if(lengthRandom == 3){
      int code = Random().nextInt(899) + 100;
      String id = lastName + code.toString();
      bool unique = await confirmUniqueID(id, "textbooks");
      if (unique == true) {
        // print("Code Created = " + id);
        return id;
      } else {
        idGenerator(3);
      }
    }

    else{
      int code = Random().nextInt(89999) + 10000;
      return code;
    }
  }