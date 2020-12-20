import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'detailscreen.dart';
import 'book.dart';

class MainScreen extends StatefulWidget {
 

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List bookcoverList;
  double screenHeight, screenWidth;
  
  String titlecenter = "Loading Book...";


  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Available Book'),       
      ),
      body: Column(
        children: [
          Divider(color: Colors.green),
          bookcoverList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: RefreshIndicator(
                      key: refreshKey,
                      color: Colors.red,
                      onRefresh: () async {
                        _loadBook();
                      },
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(bookcoverList.length, (index) {
                          return Padding(
                              padding: EdgeInsets.all(1),
                              child: Card(
                                  child: InkWell(
                                onTap: () => _loadBookDetail(index),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              height: screenHeight / 4.5,
                                              width: screenWidth / 1.2,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "http://slumberjer.com/bookdepo/bookcover/${bookcoverList[index]['cover']}.jpg",
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth / 2,
                                                ),
                                              )),
                                          Positioned(
                                            child: Container(
                                                //color: Colors.white,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        bookcoverList[index]
                                                            ['rating'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Icon(Icons.star,
                                                        color: Colors.black),
                                                  ],
                                                )),
                                            bottom: 10,
                                            right: 10,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                  
                                      Text(
                                        bookcoverList[index]['booktitle'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    
                                      Text("RM " +
                                          bookcoverList[index]['price']
                                      ),
                                    ],
                                  ),
                                ),
                              )));
                        }),
                      )))
        ],
      ),
    ));
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

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(
                  books: books,
                )));
  }


}