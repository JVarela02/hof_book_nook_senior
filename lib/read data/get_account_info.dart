import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFullName extends StatelessWidget {
  final String fullName;

  GetFullName({required this.fullName});

  @override
  Widget build(BuildContext context) {

    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');



    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(fullName).get(),
      builder: ((context, snapshot) 
    {
      if(snapshot.connectionState == ConnectionState.done) {
        Map<String,dynamic> data = 
          snapshot.data!.data() as Map<String, dynamic>;
        return Text('${data['first name']} ' + data['last name'],);
      }
      return Text('Loading ...');
    }),
    );
  }
}

class GetuserName extends StatelessWidget {
  final String userName;

  GetuserName({required this.userName});

  @override
  Widget build(BuildContext context) {

    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');


    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userName).get(),
      builder: ((context, snapshot) 
    {
      if(snapshot.connectionState == ConnectionState.done) {
        Map<String,dynamic> data = 
          snapshot.data!.data() as Map<String, dynamic>;
        return Text('@'+ data['username']);
      }
      return Text('Loading ...');
    }),
    );
  }
}


