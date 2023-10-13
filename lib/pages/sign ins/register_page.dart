// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  bool passwordConfirmed() {
    if(_passwordController.text.trim() == _confirmpasswordController.text.trim()){
      return true;
    }
    else {
      return false;
    }
  }

  bool emailPrideConfirmed(){
    if(_emailController.text.trim().contains("@pride.hofstra.edu")){
      return true;
    }
    else{
      return false;
    }
  }

  bool usernameConfirmed(){
    if(_usernameController.text.trim().toLowerCase().contains("h7")){
      return true;
    }
    else{
      return false;
    }
  }

  Future signUp() async{
    // authenticate user
    if (passwordConfirmed() && emailPrideConfirmed() && usernameConfirmed()) {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(), 
    password: _passwordController.text.trim()
    );

    // add user details
    addUserDetails(
      _firstnameController.text.trim(), 
      _lastnameController.text.trim(), 
      _usernameController.text.trim().toLowerCase(), 
      _emailController.text.trim());

    }
    else{
      if( usernameConfirmed() && passwordConfirmed() && !emailPrideConfirmed()) {
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Email is not a pride email, try again"),
        );
      });
      }
      if(usernameConfirmed() && !passwordConfirmed() && emailPrideConfirmed()){
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Passwords do not match, try again"),
        );
      });
      }
      if(!usernameConfirmed() && passwordConfirmed() && emailPrideConfirmed()) {
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("700# must have leading h, try again"),
        );
      });
      }
      if(usernameConfirmed() && !passwordConfirmed() && !emailPrideConfirmed()){
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Passwords do not match and email is not a pride email, try again"),
        );
      });
      }
      if(!usernameConfirmed() && passwordConfirmed() && !emailPrideConfirmed()) {
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Email is not a pride email and 700# does not have leading h, try again"),
        );
      });
      }
      if(!usernameConfirmed() && !passwordConfirmed() && emailPrideConfirmed()){
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Passwords do not match and 700# does not have leading h, try again"),
        );
      });
      }
      if(!usernameConfirmed() && !passwordConfirmed() && !emailPrideConfirmed()){
        showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Passwords do not match and email is not a pride email and username does not have leading h, try again"),
        );
      });
      }
    }
  }

  Future addUserDetails(String firstName, String lastName, String userName, String email) async{
    await FirebaseFirestore.instance.collection("users").add({
      'first name': firstName,
      'last name': lastName,
      'username': userName,
      'email': email,
    });
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

                  const SizedBox(height:15),
             
         
                  //hello children
                  Column(
                    children: [
                      Text(
                        "Nice to",
                        style: GoogleFonts.bigShouldersInlineDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                       Text(
                        "Meet You!",
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
                "Please register below ...",
                style: GoogleFonts.bigShouldersText(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
         
              const SizedBox(height: 20),

              
            //First Name textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _firstnameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "First Name",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height:5),

            //Last Name textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Last Name",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height:5),

              //First Name textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "700# (please include h)",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height:5),
              

              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Pride Email",
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
                    border: Border.all(color: Color.fromARGB(255, 235, 235, 235),
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
         
              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(color: Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),
                ),
              ),
         
              const SizedBox(height: 20),
               
              //sign in button
              GestureDetector(
                onTap: signUp,
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
                    child: Text("Sign Up",
                    style: TextStyle(color: Color.fromARGB(255, 235, 235, 235)),
                    ),
                    ),
                ),
              ),
               
                 const SizedBox(height: 20),
         
              //already a member? Login here
         
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member? ",
                   style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      ),
                      ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: const Text(" Login Now",
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