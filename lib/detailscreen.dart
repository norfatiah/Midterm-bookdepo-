import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'book.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Books books;

  const DetailScreen({Key key, this.books}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

 class _DetailScreenState extends State<DetailScreen>{
  double screenHeight, screenWidth;
  List bookcoverList;
  String titlecenter = "Loading Book...";
  String type = "Book";
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
       resizeToAvoidBottomPadding: false,
      body: Column(children: [
        Row(
          children: List.generate(bookcoverList.length, (index) {
          return Padding(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CachedNetworkImage(
                                       imageUrl:
                                               "http://slumberjer.com/bookdepo/bookcover/${widget.books.cover}.jpg",
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  
                                                  
                                                ),
                                              ),
                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Book Id: " +
                            bookcoverList[index]
                            ['bookid'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                         Text(
                            bookcoverList[index]
                            ['booktitle'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),   
                        Text(
                            bookcoverList[index]
                            ['author'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                        Text("RM " +
                            bookcoverList[index]['price']
                             ),  
                        Text( "Rating Book : " +
                            bookcoverList[index]['rating'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                        Text(
                            bookcoverList[index]['publisher'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                        Text(
                            bookcoverList[index]['isbn'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                            
                        Text(
                            bookcoverList[index]['cover'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                         ],
                    ),
                  ],
                ),
              ));
          }), 
        ),
      ],
      ),    
    );
  }


  Future<void> _loadBook() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {
          "location": "Changlun",
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookcoverList = null;
        setState(() {
          titlecenter = "No Book Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          bookcoverList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadBookDetail(int index) {
    print(bookcoverList[index]['bookid']);
     Books books = new Books(
        bookid: bookcoverList[index]['bookid'],
        booktitle: bookcoverList[index]['booktitle'],
        author: bookcoverList[index]['author'],
        price: bookcoverList[index]['price'],
        description: bookcoverList[index]['description'],
        rating: bookcoverList[index]['rating'],
        publisher: bookcoverList[index]['publisher'],
        isbn: bookcoverList[index]['isbn'],
        cover: bookcoverList[index]['cover'],
        );

  }

}

