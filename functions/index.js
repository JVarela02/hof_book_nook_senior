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

// const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");

// const {onDocumentCreated} = require("firebase-functions/v2/firestore");

// The Firebase Admin SDK to access Firestore.

const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

const emailjs = require("@emailjs/nodejs");
// const express = require("express");
// const app = express();

initializeApp();

// const port = process.env.PORT || 8080;
// app.listen(port, () => {
//  console.log(`Rest API started successfully`);
// });

exports.scheduleMeetupEmail = onSchedule("0 * * * *", async (event) => {
  function epoch(date) {
    return Date.parse(date);
  }
  // https://stackoverflow.com/questions/1050720/how-to-add-hours-to-a-date-object
  // eslint-disable-next-line no-extend-native
  Date.prototype.addHours = function(h) {
    this.setTime(this.getTime() + (h*60*60*1000));
    console.log("IN ADD HOURS");
    console.log(epoch(this));
    console.log("OUT ADD HOURS");
    return epoch(this);
  };
  const keyreferences = [];
  const keyRef = await getFirestore()
      .collection("shhhh").get().then((snapshot) =>
        snapshot.docs.forEach((document) => {
          console.log(document.id, "=>", document.data());
          keyreferences.push(document.data());
        }));
  console.log("HERES THE KEY REF");
  console.log(keyRef);
  console.log(keyreferences);
  const privkey = keyreferences[0].nothing_to_see_here;
  emailjs.init({
    publicKey: "O7K884SMxRo1npb9t",
    privateKey: privkey,
  });
  const transactionreferences = [];
  const emailRef = await getFirestore()
      .collection("transactions").get().then((snapshot) =>
        snapshot.docs.forEach((document) => {
          console.log(document.id, "=>", document.data());
          transactionreferences.push(document.data());
        }));
  console.log("HERE'S THE TRANSACTION REFERENCES ARRAY");
  console.log(emailRef);
  Object.keys(transactionreferences).forEach((key) => {
    console.log(transactionreferences[key].sent_email);
    console.log(transactionreferences[key]);
    const timestamp = transactionreferences[key].meetup[3];
    const now = Date.now();
    const tomorrow1 = new Date();
    const tomorrow = tomorrow1.addHours(1);
    const receiver1 = transactionreferences[key].buyer_email;
    const receiver2 = transactionreferences[key].seller_email;
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
    console.log("TIMESTAMP", timestamp);
    console.log("NOW", now);
    console.log("TOMORROW", tomorrow);
    if (timestamp >= now && timestamp <= tomorrow) {
      console.log("YESSIR IT IS!!!");
      emailjs.send(serviceId, templateID, templateParams1, {
        publicKey: "O7K884SMxRo1npb9t",
        privateKey: privkey,
      }).then((response) => {
        console.log("SUCCESS!", response.status, response.text);
      }, (err) => {
        console.log("FAILED...", err);
      },
      );
      emailjs.send(serviceId, templateID, templateParams2, {
        publicKey: "O7K884SMxRo1npb9t",
        privateKey: privkey,
      }).then((response) => {
        console.log("SUCCESS!", response.status, response.text);
      }, (err) => {
        console.log("FAILED!!!", err);
      },
      );
    }
  });
  console.log("ITS DONE");
});

// exports.testsendemail = onRequest(async (req, res) => {
//  const keyreferences = [];
//  const keyRef = await getFirestore()
//      .collection("shhhh").get().then((snapshot) =>
//        snapshot.docs.forEach((document) => {
//          console.log(document.id, "=>", document.data());
//          keyreferences.push(document.data());
//        }));
//  console.log("HERES THE KEY REF");
//  console.log(keyRef);
//  console.log(keyreferences);
//  const privkey = keyreferences.nothing_to_see_here;
//  emailjs.init({
//    publicKey: "O7K884SMxRo1npb9t",
//    privateKey: privkey,
//  });
//  const transactionreferences = [];
//  const emailRef = await getFirestore()
//      .collection("transactions").get().then((snapshot) =>
//        snapshot.docs.forEach((document) => {
//          console.log(document.id, "=>", document.data());
//          transactionreferences.push(document.data());
//        }));
//  console.log("HERE'S THE TRANSACTION REFERENCES ARRAY");
//  console.log(emailRef);
//  Object.keys(transactionreferences).forEach((key) => {
//    console.log(transactionreferences[key]);
//    const timestamp = transactionreferences[key].meetup[3];
//    function epoch(date) {
//      return Date.parse(date);
//    }
//    const now = Date.now();
//    const tomorrow1 = new Date();
//    tomorrow1.setDate(tomorrow1.getDate() + 1);
//    const tomorrow = epoch(tomorrow1);
//    const receiver1 = transactionreferences[key].buyer_email;
//    const receiver2 = transactionreferences[key].seller_email;
//    const location = transactionreferences[key].meetup[0];
//    const time = transactionreferences[key].meetup[2];
//    const templateID = "template_n3y35so";
//    // const url = new URL("https://api.emailjs.com/api/v1.0/email/send");
//    const serviceId = "service_1lu743t";
//    // const userId = "O7K884SMxRo1npb9t";
//    const themessage = `It looks like you have a
//    meetup tooday at ${location} at ${time}!
//    If you are bringing a book, make sure to bring it
//    with you for the exchange to happen smoothly!
//    Please check the app for further instructions!`;
//    const templateParams1 = {
//      header: "It's your Meetup Date!",
//      message: themessage,
//      sender_name: receiver1,
//      receiver_name: receiver2,
//      receiver_email: receiver2,
//    };
//    const templateParams2 = {
//      header: "It's your Meetup Date!",
//      message: themessage,
//      sender_name: receiver2,
//      receiver_name: receiver1,
//      receiver_email: receiver1,
//    };
//    console.log("TIMESTAMP", timestamp);
//    console.log("NOW", now);
//    console.log("TOMORROW", tomorrow);
//    if (timestamp >= now && timestamp <= tomorrow) {
//      console.log("YESSIR IT IS!!!");
//      emailjs.send(serviceId, templateID, templateParams1, {
//        publicKey: "O7K884SMxRo1npb9t",
//        privateKey: "",
//      }).then((response) => {
//        console.log("SUCCESS!", response.status, response.text);
//      }, (err) => {
//        console.log("FAILED...", err);
//      },
//      );

//      emailjs.send(serviceId, templateID, templateParams2, {
//        publicKey: "O7K884SMxRo1npb9t",
//        privateKey: "",
//      }).then((response) => {
//        console.log("SUCCESS!", response.status, response.text);
//      }, (err) => {
//        console.log("FAILED!!!", err);
//      },
//      );
//    }
//  });
//  console.log("ITS DONE");
//  res.send("have fuN!!");
// });
