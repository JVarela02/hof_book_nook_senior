/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
// const {logger} = require("firebase-functions");

const {onRequest} = require("firebase-functions/v2/https");

// const {onDocumentCreated} = require("firebase-functions/v2/firestore");

// The Firebase Admin SDK to access Firestore.

const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

const emailjs = require("@emailjs/nodejs");

initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original

exports.testsendemail = onRequest(async (req, res) => {
  emailjs.init({
    publicKey: "",
    blockHeadless: true,
  });
  console.log(req);
  const transactionreferences = [];
  const emailRef = await getFirestore()
      .collection("transactions").get().then((snapshot) =>
        snapshot.docs.forEach((document) => {
          console.log(document.id, "=>", document.data());
          transactionreferences.push(document.data());
        }));
  console.log("HERE'S THE TRANSACTION REFERENCES ARRAY");
  Object.keys(transactionreferences).forEach((key) => {
    const timestamp = transactionreferences[key].meetup[3];
    const now = Date.now();
    const tomorrow = new Date();
    const receiver1 = transactionreferences[key].buyer_email;
    const receiver2 = transactionreferences[key].sender_email;
    const location = transactionreferences[key].meetup[0];
    const time = transactionreferences[key].meetup[2];
    const templateID = "template_n3y35so";
    // const url = new URL("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = "service_1lu743t";
    // const userId = "O7K884SMxRo1npb9t";
    const themessage = `It looks like you have a
    meetup tooday at ${location} at ${time}! 
    If you are bringing a book, make sure to bring it
    with you for the exchange to happen smoothly!
    Please check the app for further instructions!`;
    const templateParams1 = {
      header: "It's your Meetup Date!",
      message: themessage,
      sender_name: receiver1,
      receiver_name: receiver2,
      receiver_email: receiver2,
    };
    const templateParams2 = {
      header: "It's your Meetup Date!",
      message: themessage,
      sender_name: receiver2,
      receiver_name: receiver1,
      receiver_email: receiver1,
    };
    if (timestamp >= now && timestamp <= tomorrow) {
      console.log("YESSIR IT IS!!!");
      emailjs.send(serviceId, templateID, templateParams1, {
        publicKey: "O7K884SMxRo1npb9t",
      }).then((response) => {
        console.log("SUCCESS!", response.status, response.text);
      }, (err) => {
        console.log("FAILED...", err);
      },
      );

      emailjs.send(serviceId, templateID, templateParams2, {
        publicKey: "O7K884SMxRo1npb9t",
      }).then((response) => {
        console.log("SUCCESS!", response.status, response.text);
      }, (err) => {
        console.log("FAILED...", err);
      },
      );
    }
    tomorrow.setDate(tomorrow.getDate() + 1);
    console.log(transactionreferences[key].meetup[3]);
  });
  console.log("ITS DONE");
  res = emailRef;
  return (res);
});
