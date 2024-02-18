import 'dart:convert';
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