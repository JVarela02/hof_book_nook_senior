import 'package:flutter/material.dart';
import 'pages/sign ins/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/main_page.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super (key: key);

  @override 

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color.fromARGB(255, 105, 173, 222),
        secondary:Color.fromARGB(255, 0, 12, 81),
      ), ),
      //home: LoginPage(showRegisterPage: () {  },),
      home: MainPage(),
    );
  }
}