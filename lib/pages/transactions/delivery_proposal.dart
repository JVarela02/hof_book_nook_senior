import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:the_hof_book_nook/pages/in%20app/active_transactions.dart';
// import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:the_hof_book_nook/repeated_functions.dart';

class DeliveryProposalPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  const DeliveryProposalPage(this.transactionData, this.transactionReference,
      this.notificationReference);
  @override
  State<DeliveryProposalPage> createState() => DeliveryProposalPageState(
      this.transactionData,
      this.transactionReference,
      this.notificationReference);
}

class DeliveryProposalPageState extends State<DeliveryProposalPage> {
  final Map<String, dynamic> transactionData;
  final String transactionReference;
  final String notificationReference;
  DeliveryProposalPageState(this.transactionData, this.transactionReference,
      this.notificationReference);

  final user = FirebaseAuth.instance.currentUser!;

  var times = [
    "Select Exchange Time",
    "Please select a date and location first"
  ];
  var locations = [
    "Select Location",
    "Adams Hall",
    "Alliance Hall",
    "Au Bon Pain",
    "Axinn Library Reception",
    "Barnard Hall",
    "Berliner Hall",
    "Bill of Rights Hall",
    "Bits & Bytes",
    "Breslin Hall",
    "Brower Hall",
    "Calkins Hall",
    "Colonial Square",
    "Constitution Hall",
    "C.V Starr Hall",
    "Davison Hall",
    "Dunkin' in the Quad",
    "Einstein Bagels",
    "Emily Lowe Hall",
    "Enterprise Hall",
    "Estabrook Hall",
    "Freshens",
    "Gittleson Hall",
    "Graduate Residence Hall",
    "Hagedorn Hall",
    "Hauser Hall",
    "Heger Hall",
    "Hof USA",
    "Koppelman Hall",
    "Kushner Hall",
    "Margiotta Hall",
    "Mason Hall / Gallon Wing",
    "McEwen Hall",
    "Monroe Lecture Hall",
    "Nassau Hall",
    "Phillips Hall",
    "Physical Education Hall",
    "Shapiro Hall",
    "Science and Innovation Center",
    "Student Center - Starbucks",
    "Stuyvesant Hall",
    "Suffolk Hall",
    "The Netherlands",
    "Vander Poel Hall",
    "Weed Hall",
    "Weller Hall"
  ];
  String locationValue = "Select Location";
  String timeValue = "Select Exchange Time";

  getTimes(String location, String date) {
    print("In Get Time");
    print("location is " + location);
    print("date selected is " + date);
    var splitDate = date.split(":");
    print(splitDate);
    String day = splitDate[0];
    print("day is " + day);

    if (location != "Select Location" && date == "Select Date") {
      print("location selected but not the date");
      times = ["Select Exchange Time", "Please select a date as well first"];
    } else if (location == "Select Location" && date != "Select Date") {
      print("date selected but not location");
      times = [
        "Select Exchange Time",
        "Please select a location as well first"
      ];
    } else if (location == "Adams Hall" ||
        location == "Barnard Hall" ||
        location == "Berliner Hall" ||
        location == "Breslin Hall" ||
        location == "Brower Hall" ||
        location == "Calkins Hall" ||
        location == "C.V Starr Hall" ||
        location == "Davison Hall" ||
        location == "Emily Lowe Hall" ||
        location == "Gittleson Hall" ||
        location == "Hagedorn Hall" ||
        location == "Hauser Hall" ||
        location == "Heger Hall" ||
        location == "Koppelman Hall" ||
        location == "Kushner Hall" ||
        location == "Margiotta Hall" ||
        location == "Mason Hall / Gallon Wing" ||
        location == "McEwen Hall" ||
        location == "Monroe Lecture Center" ||
        location == "Phillips Hall" ||
        location == "Physical Education Center" ||
        location == "Roosevelt Hall" ||
        location == "Shapiro Family Hall" ||
        location == "Science and Innovation Center" ||
        location == "Weed Hall" ||
        location == "Weller Hall") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Wednesday" ||
          day == "Thursday" ||
          day == "Friday") {
        times = [
          "Select Exchange Time",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "Please select a different location for this day"
        ];
      }
    } else if (location == "Au Bon Pain") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Wednesday" ||
          day == "Thursday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM"
        ];
      } else if (day == "Friday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "Please select a different location for this day"
        ];
      }
    } else if (location == "Student Center - Starbucks") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Wednesday" ||
          day == "Thursday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM"
        ];
      }
    } else if (location == "Bits & Bytes" || location == "Einstein Bagels") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Wednesday" ||
          day == "Thursday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM"
        ];
      } else if (day == "Friday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "Please select a different location for this day"
        ];
      }
    } else if (location == "Dunkin' in the Quad") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Wednesday" ||
          day == "Thursday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM"
        ];
      } else if (day == "Friday") {
        times = [
          "Select Exchange Time",
          "7:30 AM",
          "7:45 AM",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "Please select a different location for this day"
        ];
      }
    } else if (location == "Freshens") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Thursday" ||
          day == "Friday") {
        times = [
          "Select Exchange Time",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM"
        ];
      } else if (day == "Wednesday") {
        times = [
          "Select Exchange Time",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM",
          "9:00 PM",
          "9:15 PM",
          "9:30 PM",
          "9:45 PM",
          "10:00 PM",
          "10:15 PM",
          "10:30 PM",
          "10:45 PM",
          "11:00 PM",
          "11:15 PM",
          "11:30 PM",
          "11:45 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM"
        ];
      }
    } else if (location == "Hof USA") {
      times = [
        "Select Exchange Time",
        "6:00 PM",
        "6:15 PM",
        "6:30 PM",
        "6:45 PM",
        "7:00 PM",
        "7:15 PM",
        "7:30 PM",
        "7:45 PM",
        "8:00 PM",
        "8:15 PM",
        "8:30 PM",
        "8:45 PM",
        "9:00 PM",
        "9:15 PM",
        "9:30 PM",
        "9:45 PM",
        "10:00 PM",
        "10:15 PM",
        "10:30 PM",
        "10:45 PM",
        "11:00 PM",
        "11:15 PM",
        "11:30 PM",
        "11:45 PM",
        "12:00 AM",
        "12:15 AM",
        "12:30 AM",
        "12:45 AM"
      ];
    } else if (location == "Axinn Library Reception") {
      if (day == "Monday" ||
          day == "Tuesday" ||
          day == "Wednesday" ||
          day == "Thursday" ||
          day == "Friday") {
        times = [
          "Select Exchange Time",
          "8:00 AM",
          "8:15 AM",
          "8:30 AM",
          "8:45 AM",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM",
          "9:00 PM",
          "9:15 PM",
          "9:30 PM",
          "9:45 PM",
          "10:00 PM",
          "10:15 PM",
          "10:30 PM",
          "10:45 PM"
        ];
      } else if (day == "Saturday") {
        times = [
          "Select Exchange Time",
          "9:00 AM",
          "9:15 AM",
          "9:30 AM",
          "9:45 AM",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM",
          "9:00 PM",
          "9:15 PM",
          "9:30 PM",
          "9:45 PM",
          "10:00 PM",
          "10:15 PM",
          "10:30 PM",
          "10:45 PM"
        ];
      } else {
        times = [
          "Select Exchange Time",
          "10:00 AM",
          "10:15 AM",
          "10:30 AM",
          "10:45 AM",
          "11:00 AM",
          "11:15 AM",
          "11:30 AM",
          "11:45 AM",
          "12:00 PM",
          "12:15 PM",
          "12:30 PM",
          "12:45 PM",
          "1:00 PM",
          "1:15 PM",
          "1:30 PM",
          "1:45 PM",
          "2:00 PM",
          "2:15 PM",
          "2:30 PM",
          "2:45 PM",
          "3:00 PM",
          "3:15 PM",
          "3:30 PM",
          "3:45 PM",
          "4:00 PM",
          "4:15 PM",
          "4:30 PM",
          "4:45 PM",
          "5:00 PM",
          "5:15 PM",
          "5:30 PM",
          "5:45 PM",
          "6:00 PM",
          "6:15 PM",
          "6:30 PM",
          "6:45 PM",
          "7:00 PM",
          "7:15 PM",
          "7:30 PM",
          "7:45 PM",
          "8:00 PM",
          "8:15 PM",
          "8:30 PM",
          "8:45 PM",
          "9:00 PM",
          "9:15 PM",
          "9:30 PM",
          "9:45 PM",
          "10:00 PM",
          "10:15 PM",
          "10:30 PM",
          "10:45 PM"
        ];
      }
    } else if (location == "Alliance Hall" ||
        location == "Bill of Rights Hall" ||
        location == "Colonial Square" ||
        location == "Constitution Hall" ||
        location == "Enterprise Hall" ||
        location == "Estabrook Hall" ||
        location == "Graduate Residence Hall" ||
        location == "Nassau Hall" ||
        location == "The Netherlands" ||
        location == "Stuyvesant Hall" ||
        location == "Suffolk Hall" ||
        location == "Vander Poel Hall") {
      times = [
        "Select Exchange Time",
        "7:30 AM",
        "7:45 AM",
        "8:00 AM",
        "8:15 AM",
        "8:30 AM",
        "8:45 AM",
        "9:00 AM",
        "9:15 AM",
        "9:30 AM",
        "9:45 AM",
        "10:00 AM",
        "10:15 AM",
        "10:30 AM",
        "10:45 AM",
        "11:00 AM",
        "11:15 AM",
        "11:30 AM",
        "11:45 AM",
        "12:00 PM",
        "12:15 PM",
        "12:30 PM",
        "12:45 PM",
        "1:00 PM",
        "1:15 PM",
        "1:30 PM",
        "1:45 PM",
        "2:00 PM",
        "2:15 PM",
        "2:30 PM",
        "2:45 PM",
        "3:00 PM",
        "3:15 PM",
        "3:30 PM",
        "3:45 PM",
        "4:00 PM",
        "4:15 PM",
        "4:30 PM",
        "4:45 PM",
        "5:00 PM",
        "5:15 PM",
        "5:30 PM",
        "5:45 PM",
        "6:00 PM",
        "6:15 PM",
        "6:30 PM",
        "6:45 PM",
        "7:00 PM",
        "7:15 PM",
        "7:30 PM",
        "7:45 PM",
        "8:00 PM",
        "8:15 PM",
        "8:30 PM",
        "8:45 PM",
        "9:00 PM",
        "9:15 PM",
        "9:30 PM",
        "9:45 PM",
        "10:00 PM",
        "10:15 PM",
        "10:30 PM",
        "10:45 PM"
      ];
    } else {
      print("Dont change anything");
    }
  }

  DateTime selectedDate = DateTime.now();
  String selectedDateText = "Select Date";
  var dateInEpoch;

  selectDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 7)))
        .then((value) {
      setState(() {
        selectedDate = value!;
        int turnToEpoch = selectedDate.millisecondsSinceEpoch;
        dateInEpoch = turnToEpoch;
        selectedDateText = DateFormat('EEEE: MMM d, yyyy').format(selectedDate);
        getTimes(locationValue, selectedDateText);
      });
    });
  }

  sendAppt(String location, String date, String time) async {
    var splitDate = date.split(":");
    print(splitDate);
    String meet = splitDate[1];
    // update transaction status to "counter-offer" & Meet-up Time
    final transaction_document = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionReference);

    if (user.email == transactionData['seller_email']) {
      transaction_document.update({
        'status': "Meetup-Offer",
      });
    } else {
      transaction_document.update({
        'status': "Meetup-Counter",
      });
    }

    transaction_document.update({
      'meetup': [location, meet, time, int.parse(dateInEpoch)],
    });

    print("transactions updated");

    // create a new notification for opposite person
    if (user.email == transactionData['seller_email']) {
      sendNotification(
          transactionData['transaction_ID'],
          transactionData['seller'] + " has chosen a meet-up time",
          transactionData['seller'] +
              " has chosen a meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              ". Please confirm wether or not the date and time works for you otherwise send a meetup date counter-offer",
          transactionData['buyer_email'],
          transactionData['seller_email']);
      print("new notification uploaded");
    } else {
      sendNotification(
          transactionData['transaction_ID'],
          transactionData['buyer'] + " has chosen an alternative meet-up time",
          transactionData['buyer'] +
              " has chosen a different meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              ". Please confirm wether or not the date and time works for you otherwise send a meetup date counter-offer",
          transactionData['seller_email'],
          transactionData['buyer_email']);
      print("new notification uploaded");
    }

    // send alternative person email
    if (user.email == transactionData['seller_email']) {
      await emailNotification(
          header: "Update for transaction " +
              transactionData['transaction_ID'].toString(),
          message: transactionData['seller'] +
              " has chosen a meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              " Please go to the app to confirm if the date and time works for you or to send an alternative meetup date offer..",
          sender_name: transactionData['seller'],
          receiver_name: transactionData['buyer'],
          receiver_email: transactionData['buyer_email']);
      print("email sent");
    } else {
      await emailNotification(
          header: "Update for transaction " +
              transactionData['transaction_ID'].toString(),
          message: transactionData['buyer'] +
              " has chosen an alternative meet-up date to complete the purchase of " +
              transactionData['forSale']['Title'] +
              " Please go to the app to confirm if the date and time works for you or to send an alternative meetup date offer..",
          sender_name: transactionData['buyer'],
          receiver_name: transactionData['seller'],
          receiver_email: transactionData['seller_email']);
      print("email sent");
    }

    // update notification to "read" and pop back to right page
    if (notificationReference != "0") {
      final notification_document = FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationReference);
      notification_document.update({
        'read': true,
      });
      // send back to navigation page
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return NotificationPage();
      }));
      print("notification updated");
    } else {
      print("ha nope no notification");
      // send back to transaction page

      Navigator.pop(context);
      Navigator.pop(context);
      //Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ActTransPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Setup Delivery Date Order #" +
                      transactionData['transaction_ID'].toString())),
            ),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Expanded(
                child: Center(
              child: Column(
                children: [
                  Text(
                    "Transaction #" +
                        transactionData['transaction_ID'].toString(),
                    style: GoogleFonts.merriweather(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "For Sale Book: ",
                        style: GoogleFonts.merriweather(
                          fontSize: 15,
                        ),
                      ),
                      Image.network(
                        transactionData['forSale']['Cover'],
                        scale: 3,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 275),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              transactionData['forSale']['Title'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "by " + transactionData['forSale']['Author'],
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  DropdownButton(
                    value: locationValue,
                    underline: Container(
                      height: 2,
                      color: Color.fromARGB(255, 105, 173, 222),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: locations.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: GoogleFonts.merriweather(
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      // This is called when the user selects an item.
                      setState(() {
                        locationValue = newValue!;
                      });
                      await getTimes(locationValue, selectedDateText);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await selectDate();
                      //getTimes(locationValue, selectedDateText);
                    },
                    child: Text(
                      selectedDateText,
                      //style: TextStyle(color: Colors.white),
                      style: GoogleFonts.merriweather(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButton(
                    value: timeValue,
                    underline: Container(
                      height: 2,
                      color: Color.fromARGB(255, 105, 173, 222),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: times.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: GoogleFonts.merriweather(
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      // This is called when the user selects an item.
                      setState(() {
                        timeValue = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      sendAppt(locationValue, selectedDateText, timeValue);
                      //getTimes(locationValue, selectedDateText);
                    },
                    child: Text(
                      "Send Meet-Up Time Offer",
                      /*style: GoogleFonts.merriweather(
                                fontSize: 15,
                                color: Colors.white
                              ),*/
                    ),
                  ),
                ],
              ),
            )),
          ),
        )));
  }
}
