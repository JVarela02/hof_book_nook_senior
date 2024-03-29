// import 'dart:html';
//import 'package:the_hof_book_nook/auth/auth_code_page.dart';
import 'package:the_hof_book_nook/auth/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import '../pages/in app/home_page.dart';
 
class MainPage extends StatelessWidget {
  const MainPage({Key? key}): super(key:key);
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if(snapshot.hasData){
            // return AuthCodePage();
          //  return HomePage();
          //}
          //else{
            return AuthPage();
          //}
        },
      ),
    );
  }
 
}
