// ignore_for_file: prefer_const_literals_to_create_immutables
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_hof_book_nook/auth/auth_code_page.dart';
//import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
//import '../../main.dart';
import 'forgot_pw_page.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);
  // const LoginPage({Key? key}) : super(key: key);
 
  @override
  State<LoginPage> createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {
 
  // text controllers
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _authcodeController = TextEditingController();

    int codeGenerator(var loggedemail) {
    int code = Random().nextInt(89999) + 10000; 
    print(code);
    sendCode(loggedemail, code);
    return code;
  }

  Future getfullName(loggedemail) async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: loggedemail);
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


  // send auth code to DB 
  Future codeToDatabase(var loggedemail, int authcode) async {
    var documentIDList = [];
    await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: loggedemail).get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print("reference id is " + document.reference.id);
              documentIDList.add(document.reference.id);
            },
          ),
        );
    var user_name = await getfullName(loggedemail);
    final document = FirebaseFirestore.instance.collection('users').doc(documentIDList[0]);
    document.update({'auth': authcode,});


    // email user 
    emailAuth(name: user_name, code: authcode, email:loggedemail);

    }

  // email auth code to user 
  Future emailAuth(
    {required name,
    required code,
    required email,}
  ) async {
    final serviceId = 'service_1lu743t';
    final templateId = 'template_1pu7cem';
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
          'first_name': name,
          'code': code,
          'user_email' : email
        }
      }),
    );
    print(response.body);
  }

  sendCode(var loggedemail,int code) {
    codeToDatabase(loggedemail, code);
    Navigator.of(context).pop();
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
        return AuthCodePage();
      })); 
  }


 
  Future signIn() async{
    if(_loginController.text.contains("pride.hofstra.edu"))
      {print("logging in with email");
        try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginController.text.trim(),
          password: _passwordController.text.trim()
          );
        codeGenerator(_loginController.text.trim());
        } on Exception {
        showDialog(context: context, builder: (context){
              return const AlertDialog(
                content: Text("No matching email and password was found"),
              );
            });
      }}
      else
        {if(_loginController.text.toLowerCase().contains("h7")){
          print("Logging in with username");
          var collection = FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _loginController.text.trim());
            var querySnapshot = await collection.get();
            var emailLogin = "";
          for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();
          var emailAdd = data['email'];
          emailLogin = emailAdd;
          } 
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailLogin,
              password: _passwordController.text.trim()
              );
            codeGenerator(emailLogin);
            } on Exception {
            showDialog(context: context, builder: (context){
                  return const AlertDialog(
                    content: Text("No matching email and password was found"),
                  );
                });
          }
        }
        else{
            print("Error in Logging in");
            showDialog(context: context, builder: (context){
                  return const AlertDialog(
                    content: Text("Please enter a valid username/email"),
                  );
          });
        }} 
  }  
 
  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
   _authcodeController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView (
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png',
                  scale: 3,
                  ),

                  // const SizedBox(height:5),
         
                  //hello children
                  Column(
                    children: [
                      Text(
                        "Welcome",
                        style: GoogleFonts.bigShouldersInlineDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                       Text(
                        "Back!",
                        style: GoogleFonts.bigShouldersInlineDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ],
                  ),
         
                  
                ],
              ),

              const SizedBox(height:10),
         
                  Text(
                    "Please sign-in to your account",
                    style: GoogleFonts.bigShouldersText(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
         
                const SizedBox(height: 20),
         
              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: const Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _loginController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Pride Email or H700#",
                      ),
                    ),
                  ),
                ),
              ),
               
              const SizedBox(height:5),
         
              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: const Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                    ),
                  ),
                ),
              ),
         
              const SizedBox(height: 15),


              // forgot password? rest it now

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Forgot Password? ",
                   style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      ),
                      ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: const Text(" Reset Here",
                        style: TextStyle(
                          color: Color.fromARGB(255, 105, 173, 222),
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                ],
              ),

              const SizedBox(height:10),
               
              //sign in button
              GestureDetector(
                onTap: signIn,
                child: Container(
                  height: 50,
                  width: 110,
                  decoration: BoxDecoration(
                    color:Color.fromARGB(255, 105, 173, 222),
                    border: Border.all(color: Colors.white,
                      width: 3),
                      borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text("Sign In",
                    style: TextStyle(color: Colors.white),
                    ),
                    ),
                ),
              ),

              const SizedBox(height: 20),


              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member? ",
                   style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      ),
                      ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: const Text(" Register Now",
                        style: TextStyle(
                          color: Color.fromARGB(255, 105, 173, 222),
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                ],
              ),
         
               
            ]),
          ),
        ),
      ),
 
 
      appBar: AppBar(
        title: Text(""),
      )
    );
  }
}
