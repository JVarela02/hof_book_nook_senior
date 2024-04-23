//import 'dart:js_util';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:the_hof_book_nook/pages/in%20app/home_page.dart';
//import 'package:the_hof_book_nook/pages/in%20app/listing_page.dart';
//import 'package:the_hof_book_nook/pages/in%20app/removetxt_page.dart';
//import 'package:the_hof_book_nook/pages/in%20app/txtinput_page.dart';
//import 'package:the_hof_book_nook/pages/in%20app/support_page.dart';
//import 'package:the_hof_book_nook/pages/sign%20ins/login_page.dart';
//import 'package:the_hof_book_nook/read data/get_credit_info.dart';
//import 'package:the_hof_book_nook/pages/in%20app/notification_page.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
//import 'package:the_hof_book_nook/pages/in%20app/account_page.dart';
import 'package:camera/camera.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});
  //final CameraDescription camera;

  @override
  State<CreditPage> createState() => _CreditPageState();

}

class _CreditPageState extends State<CreditPage> {
   final user = FirebaseAuth.instance.currentUser!;

  List<dynamic> creditIDList = [];
  //List<dynamic> creditsList = [];
  var credits;
  var firstCamera;
  late CameraController controller;
  late Future<void> initControllerFuture;

  Future getCameras() async {
      final cameras = await availableCameras();
      final firstCamera = cameras[0];
      controller = CameraController(firstCamera, ResolutionPreset.medium,);
      initControllerFuture = controller.initialize();
      await initControllerFuture;
      CameraPreview(controller);
      /*await Navigator.of(context).push(MaterialPageRoute(builder: ((context) => DisplayFeedScreen(
        controllers: controller
      )))); */
      showDialog(
              context: context,
              builder: (BuildContext context) {
                return Expanded(
                  child: AlertDialog(
                    title: Text("Chungus"),
                    content: CameraPreview(controller),
                    actions: [
                      TextButton(
                        //textColor: Colors.black,
                        onPressed: () async {
                          await takePicture();
                          //Navigator.of(context).pop();
                        },
                        child: Text('Take Picture'),
                      ),
                    ],
                  ),
                );
              },
            );
      //final image = await controller.takePicture();
      //await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPictureScreen(
      //        imagePath: image.path,)));
      //print(firstCamera);
  }

  Future takePicture() async {
    final cameras = await availableCameras();
      final firstCamera = cameras[0];
      controller = CameraController(firstCamera, ResolutionPreset.medium,);
      initControllerFuture = controller.initialize();
      await initControllerFuture;
      final image = await controller.takePicture();
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPictureScreen(
              imagePath: image.path,)));
      print("WE MADE IT BOYS");
  }

  //get reference ID for credits
  Future getCreditID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              //print(document.reference.id);
              creditIDList.add(document.reference.id);
            },
          ),
        );
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(creditIDList[0]).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var credits = data?['credits'];
      //print(credits);
      //print(creditIDList[0]);
      //print(credits.runtimeType);
      creditIDList.add(credits);
      //print(creditIDList);
       
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Purchase Credits"),
          // leading: IconButton(
          // icon: Icon(Icons.arrow_back, color: Colors.black),
          // onPressed: () {
          //             Navigator.of(context).pop();
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (BuildContext context) {
          //               return accountPage();
          //             }));
          //           }
          // ),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "Af7w1kQowIyXNMx3NJ8GRmx_NA2ueP8wzdF80fvr-O1OhYIpbGZ5c9a-CsxHYu44OgZ2NjrLAR6x8-T6",
                            secretKey:
                                "EJMl0csGNZuMlQ0M53jsMVs0fdJLTtBi0qJE6DOAOI0kZp6Z-Y5_HDIZ-IhtuYXIT57BPblm4VV1ZM1L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '5.00',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '5.00',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '5.00',
                                      "currency": "USD"
                                    }
                                  ],

                                  /* shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },*/
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              getCreditID().then((data) {
                              //getCredits().then((data) {
                                //print(creditIDList);
                              //getCreditID().then((data) {
                                //print(data);
                                //print(creditsList[0]);
                                //print(creditsList[0].runtimeType);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              //.doc(creditIDList[0]);
                              .doc(creditIDList[0]);
                              //print(documents);
                                  documents.update({
                                    'credits': creditIDList[1] + 5,
                              
                              });
                              creditIDList[1] = creditIDList[1] + 5;
                             // });
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    ),
                  },
              child: const Text("Buy Five Dollars")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "Af7w1kQowIyXNMx3NJ8GRmx_NA2ueP8wzdF80fvr-O1OhYIpbGZ5c9a-CsxHYu44OgZ2NjrLAR6x8-T6",
                            secretKey:
                                "EJMl0csGNZuMlQ0M53jsMVs0fdJLTtBi0qJE6DOAOI0kZp6Z-Y5_HDIZ-IhtuYXIT57BPblm4VV1ZM1L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '15.00',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '15.00',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '15.00',
                                      "currency": "USD"
                                    }
                                  ],

                                  /* shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },*/
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + 15,
                              });
                              creditIDList[1] = creditIDList[1] + 15;
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Buy Fifteen Dollars")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "Af7w1kQowIyXNMx3NJ8GRmx_NA2ueP8wzdF80fvr-O1OhYIpbGZ5c9a-CsxHYu44OgZ2NjrLAR6x8-T6",
                            secretKey:
                                "EJMl0csGNZuMlQ0M53jsMVs0fdJLTtBi0qJE6DOAOI0kZp6Z-Y5_HDIZ-IhtuYXIT57BPblm4VV1ZM1L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '20.00',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '20.00',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '20.00',
                                      "currency": "USD"
                                    }
                                  ],

                                  /* shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },*/
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + 20,
                              });
                              creditIDList[1] = creditIDList[1] + 20;
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Buy Twenty Dollars")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "Af7w1kQowIyXNMx3NJ8GRmx_NA2ueP8wzdF80fvr-O1OhYIpbGZ5c9a-CsxHYu44OgZ2NjrLAR6x8-T6",
                            secretKey:
                                "EJMl0csGNZuMlQ0M53jsMVs0fdJLTtBi0qJE6DOAOI0kZp6Z-Y5_HDIZ-IhtuYXIT57BPblm4VV1ZM1L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '50.00',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '50.00',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '50.00',
                                      "currency": "USD"
                                    }
                                  ],

                                  /* shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },*/
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + 50,
                              });
                              creditIDList[1] = creditIDList[1] + 50;
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Buy Fifty Dollars")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "Af7w1kQowIyXNMx3NJ8GRmx_NA2ueP8wzdF80fvr-O1OhYIpbGZ5c9a-CsxHYu44OgZ2NjrLAR6x8-T6",
                            secretKey:
                                "EJMl0csGNZuMlQ0M53jsMVs0fdJLTtBi0qJE6DOAOI0kZp6Z-Y5_HDIZ-IhtuYXIT57BPblm4VV1ZM1L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '75.00',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '75.00',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '75.00',
                                      "currency": "USD"
                                    }
                                  ],

                                  /* shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },*/
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + 75,
                              });
                              creditIDList[1] = creditIDList[1] + 75;
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Buy Seventy Five Dollars")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "Af7w1kQowIyXNMx3NJ8GRmx_NA2ueP8wzdF80fvr-O1OhYIpbGZ5c9a-CsxHYu44OgZ2NjrLAR6x8-T6",
                            secretKey:
                                "EJMl0csGNZuMlQ0M53jsMVs0fdJLTtBi0qJE6DOAOI0kZp6Z-Y5_HDIZ-IhtuYXIT57BPblm4VV1ZM1L",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '100.00',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '100.00',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '100.00',
                                      "currency": "USD"
                                    }
                                  ],

                                  /* shipping address is not required though
                                  "shipping_address": {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },*/
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              getCreditID().then((data) {
                                print(creditIDList);
                                final documents = FirebaseFirestore.instance
                              .collection('users')
                              .doc(creditIDList[0]);
                                  documents.update({
                                    'credits': creditIDList[1] + 100,
                              });
                              creditIDList[1] = creditIDList[1] + 100;
                              });
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
              child: const Text("Buy One Hundred Dollars")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
                  onPressed: () async {
                            await getCreditID();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Expanded(
                                      child: AlertDialog(
                                        title: Text("Chungus"),
                                        content: Text("Current Credits: " + creditIDList[1].toString() + "\n\nCurrent Credits in \nTransactions: "),
                                        actions: [
                                          TextButton(
                                            //textColor: Colors.black,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                    print('Chungus');
                  },
                  child: const Text("View Credits"),),
                  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
                  onPressed: () async {
                            await getCameras();
                  },
                  child: const Text("BEATING FLUTTER TO DEATH WITH HAMMERS"),),
              ]
            )
          )
        );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the Image.file
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

/*class DisplayFeedScreen extends StatelessWidget {
  final CameraController controllers;

  const DisplayFeedScreen({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Center(
        child: Column( 
        children: [
          CameraPreview(controllers),
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,40)
                  ),
                  onPressed: () async {
                    
                  },
                  child: const Text("TAKE PRETTY PICTURE"),
          ),
        ]
        )
      )
    );
  }
} */

