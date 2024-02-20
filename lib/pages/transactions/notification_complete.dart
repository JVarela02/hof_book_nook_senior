//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';



class NotifCompletePage extends StatefulWidget {
  const NotifCompletePage();
  @override
  State<NotifCompletePage> createState() => NotifCompletePageState();
}

class NotifCompletePageState extends State<NotifCompletePage> {
  NotifCompletePageState();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Notification Complete")),
          ),
        ),
      ),
      body: 
      Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Expanded(
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/Hello_Pengu.png',
                            scale: 3,
                            ),
                          ),

                          SizedBox(height: 15),
                                      
                          Align(
                            alignment: Alignment.center,
                            child: Text("Hello! You have already completed your step for this notification! \n Please wait for a new notification! ",
                            style: GoogleFonts.merriweather(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
            ),
          )
      ));}}