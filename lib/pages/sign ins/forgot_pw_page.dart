import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {

  // text controllers
  final _emailController = TextEditingController();

  Future passwordReset() async {
    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _emailController.text.trim());
      showDialog(
        context: context, 
        builder: (context){
        return AlertDialog(
          content: Text("Password Reset Link Sent! Please check your spam folder"),
        );
        }
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("Enter your email to receive a reset password link",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20,),
              
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
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Pride Email",
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10,),

            MaterialButton(
            onPressed: passwordReset,
            child: const Text("Reset Password"),
            color: Color.fromARGB(255, 105, 173, 222),
            ),
            ],
          ),
      appBar: AppBar(
        title: Text(""),
      )
    );
  }
}