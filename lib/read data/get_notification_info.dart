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

class GetRead extends StatelessWidget {
  final String readIcon;

  GetRead({required this.readIcon});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: notifications.doc(readIcon).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if ('${data['read']}' == 'true') {
            return Text(' ');
          } else {
            return Icon(Icons.circle);
          }
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetStatus extends StatelessWidget {
  final String newStatus;

  GetStatus({required this.newStatus});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');

    return FutureBuilder<DocumentSnapshot>(
      future: transactions.doc(newStatus).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['status']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetTransactionID extends StatelessWidget {
  final String newTID;

  GetTransactionID({required this.newTID});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');

    return FutureBuilder<DocumentSnapshot>(
      future: transactions.doc(newTID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['transaction_ID']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetDate extends StatelessWidget {
  final String newDate;

  GetDate({required this.newDate});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: transactions.doc(newDate).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['date']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}

class GetTime extends StatelessWidget {
  final String newTime;

  GetTime({required this.newTime});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('notifications');

    return FutureBuilder<DocumentSnapshot>(
      future: transactions.doc(newTime).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['date']} ',
          );
        }
        return Text('Loading ...');
      }),
    );
  }
}
