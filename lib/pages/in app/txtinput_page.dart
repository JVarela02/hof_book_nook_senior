import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_hof_book_nook/read%20data/API_route.dart';

class TextbookInputPage extends StatefulWidget {
  const TextbookInputPage({super.key});

  @override
  State<TextbookInputPage> createState() => _TextbookInputPageState();
}

class _TextbookInputPageState extends State<TextbookInputPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> items = <String>["Condition","Like New", "Slightly Used", "Acceptable"];
  String conditionValue = "Condition";

  // input controllers
  final _isbnInputController = TextEditingController();
  final _conditionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _isbnInputController.dispose();
    _conditionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool isbnLengthCorrect() {
    if (_isbnInputController.text.toString().trim().length == 13) {
      return true;
    } else {
      return false;
    }
  }


  Future checkInfo(String tTitle, String tAuthor, String tDescription, String tCover) async {
    if (isbnLengthCorrect()) {
      textbookToFirebase(
        user.email.toString(),
        _isbnInputController.text.toString(),
        conditionValue,
        _priceController.text.toString(),
        tDescription,
        tTitle,
        tAuthor,
        tCover
      );
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Textbook Uploaded"),
            );
          });
    } else {
      if (!isbnLengthCorrect()){ 
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                    "ISBN number is not correct, please make sure the length is 13 characters long and try again "),
              );
            });
      }
    }
  }

  Future textbookToFirebase(String Txtseller, String ISBNnumber,
      String Txtcondition, String Txtprice, String description, String title, String author, String poster) async {
    await FirebaseFirestore.instance.collection("textbooks").add({
      'Seller': Txtseller,
      'ISBN': ISBNnumber,
      'Title' : title,
      'Description' : description,
      'Author' : author,
      'Cover' : poster,
      'Condition': Txtcondition,
      'Price': Txtprice,
      'InNegotiations': false,
    });
  }

  Future getDetails() async {
    Textbook T = await APIRouter().getTextbook(_isbnInputController.text);
    checkInfo(T.title, T.authors, T.description, T.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft, child: Text("Upload Listing")),
          ),
        ),
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
                      controller: _isbnInputController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "ISBN Number",
                      ),
                    ),
                  ),
                ),
              ),

              DropdownButton<String>(
                value: conditionValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged:
                (String? Newalue) {
                  /// This is called when the user selects an item.
                    setState(() {
                      conditionValue = Newalue!;
                    });
                },
                items:
                items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );}).toList(),
                ),

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
                      controller: _priceController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Price",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: getDetails,
                child: Container(
                  height: 50,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 105, 173, 222),
                  ),
                  child: const Center(
                    child: Text(
                      "Upload Listing",
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
