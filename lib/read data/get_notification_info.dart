import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetHeader extends StatelessWidget {
  final String newHeader;

  GetHeader({required this.newHeader});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: notifications.doc(newHeader).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['header']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetRecipient extends StatelessWidget {
  final String newRecipient;

  GetRecipient({required this.newRecipient});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: notifications.doc(newRecipient).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['recipient']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetSeller extends StatelessWidget {
  final String newSeller;

  GetSeller({required this.newSeller});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: notifications.doc(newSeller).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['sender']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetMessage extends StatelessWidget {
  final String newMessage;

  GetMessage({required this.newMessage});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: notifications.doc(newMessage).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['message']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}
