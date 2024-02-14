
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';

class AuthCodePage extends StatefulWidget {
  const AuthCodePage({Key? key}) : super(key: key);

  @override
  State<AuthCodePage> createState() => _AuthCodePageState();
}

class _AuthCodePageState extends State<AuthCodePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // input controllers
  final _authcodeController = TextEditingController();
  var attempts = 0;

  //

  @override
  void dispose() {
    _authcodeController.dispose();
    super.dispose();
  }


  Future getCode() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email);
    var querySnapshot = await collection.get();
    var code = 0;
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      code = data['auth'];
    }
    return code;
  }


  Future verifyUser() async{
    var code = await getCode(); 
    int input = int.parse(_authcodeController.text);

    if (input != code){
      attempts = attempts + 1;
      if(attempts >= 3) {
        await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage(showRegisterPage: () {  },
                          );
                        },
                      ),
                    );
        }
      else{
      print(attempts);
      int tries = (3 - attempts);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Wrong Code: You have " + tries.toString() + " attempts to try again"),
            );
          });
      }
    }

    else{
      Navigator.of(context).pop();
      Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }));
    }
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Authentication")),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage(
                            showRegisterPage: () {},
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 230, 247),
                    border: Border.all(
                        color: Color.fromARGB(255, 235, 235, 235), width: 3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: TextField(
                      controller: _authcodeController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Authentication Code",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: verifyUser,
                child: Container(
                  height: 50,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 105, 173, 222),
                  ),
                  child: const Center(
                    child: Text(
                      "Verify Identity",
                      style:
                          TextStyle(color: Color.fromARGB(255, 235, 235, 235)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 