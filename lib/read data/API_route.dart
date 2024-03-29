// import 'package:the_hof_book_nook/main.dart';
// import 'package:the_hof_book_nook/pages/in app/home_page.dart';
// import 'package:the_hof_book_nook/pages/in app/txtinput_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


var splittedTitle = [];
var splittedAuthor = [];

splitInfo(var title, var author){
  splittedTitle = title.toString().split(' ');
  splittedTitle.add(title);

  splittedAuthor = author.toString().split(' ');
  splittedAuthor.add(author);
}

class APIRouter
{

  Future<Textbook> getTextbook(String query) async
  {
    var result = await http.get(Uri.parse("https://www.googleapis.com/books/v1/volumes?q=" + query + "&maxResults=1"));
    var response = json.decode(result.body)['items'] as List<dynamic>;
    print("API Call: https://www.googleapis.com/books/v1/volumes?q=" + query + "&maxResults=1");
    print(response);
    print(response.map((e) => e['volumeInfo']['title']));
    print(response.map((e) => e['volumeInfo']['authors'][0]));
    // print(response.map((e) => e['volumeInfo']['description']));

    String fullTitle = (response.map((e) => e['volumeInfo']['title']).toList()[0]).toString();
    String fullAuthor = (response.map((e) => e['volumeInfo']['authors'][0]).toList()[0]).toString();

    splitInfo(fullTitle.toLowerCase(), fullAuthor.toLowerCase());

    //print(response.map((e) => e['volumeInfo']['imageLinks']['smallThumbnail']));
    try{return response.map((e) => Textbook(
          e['volumeInfo']['title'] ,
          splittedTitle,
          splittedAuthor,
          e['volumeInfo']['authors'][0], 
          e['volumeInfo']['description'],
          e['volumeInfo']['imageLinks']['smallThumbnail'] 
        )).toList()[0];} catch(e){
          try{return response.map((e) => Textbook(
          e['volumeInfo']['title'] ,
          splittedTitle,
          splittedAuthor,
          e['volumeInfo']['authors'][0], 
          "Description was Unavailable",
          e['volumeInfo']['imageLinks']['smallThumbnail'] 
        )).toList()[0];}catch(e){
          try{return response.map((e) => Textbook(
          e['volumeInfo']['title'] ,
          splittedTitle,
          splittedAuthor,
          e['volumeInfo']['authors'][0], 
          e['volumeInfo']['description'],
          "https://books.google.com/books/content?id=zyTCAlFPjYC&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE73AuY_TaGIi529M67qgjWVg2w3fzNQZd9tKzmlSo9RZnHZXPQ66-eHfBSVKwTrN4yjs0AH-sFmjLgC_WuTMI25NcdpztP-Uafs3JalOuGnZfnoIRyhrPknrsJErqk0u2Ykn7&source=gbs_api" 
        )).toList()[0];}catch(e){
        return response.map((e) => Textbook(
          e['volumeInfo']['title'] ,
          splittedTitle,
          splittedAuthor,
          e['volumeInfo']['authors'][0], 
          "Description Unavailable",
          "https://books.google.com/books/content?id=zyTCAlFPjYC&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE73AuY_TaGIi529M67qgjWVg2w3fzNQZd9tKzmlSo9RZnHZXPQ66-eHfBSVKwTrN4yjs0AH-sFmjLgC_WuTMI25NcdpztP-Uafs3JalOuGnZfnoIRyhrPknrsJErqk0u2Ykn7&source=gbs_api" 
        )).toList()[0];
        }
        }
        }
  }
}

class Textbook
{
  String title;
  List titleSplit;
  List authorSplit;
  String authors;
  String description;
  String image;
  Textbook(this.title, this.titleSplit, this.authorSplit, this.authors, this.description, this.image);
}
