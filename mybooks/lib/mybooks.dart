library mybooks;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:riviu_buku/left_drawer.dart';
import 'package:riviu_buku/authentication/menu.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';
import 'components/card.dart';
import 'components/book_wrapper.dart';
import 'upload_form.dart';
import 'components/book_card.dart';  


class MyBookPage extends StatefulWidget {
    final User user;
    const MyBookPage({Key? key, required this.user}) : super(key: key);

    @override
    _MyBookPageState createState() => _MyBookPageState(user);
}

class _MyBookPageState extends State<MyBookPage> {
  final User user;
  List<Book> list_top = [];
  _MyBookPageState(this.user);
Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://127.0.0.1:8000/json/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    

    // melakukan konversi data json menjadi object Product
    List<Book> list_product = [];
    list_top.clear();
    for (var d in data) {
        if (d != null) {
            Book book = Book.fromJson(d);
            list_top.add(book);
            print(book.fields!.user);
            if(book.fields!.user == user.id){
              list_product.add(book);
            }
        }
    }
    list_top.sort((a, b) {
      final ratingA = a.fields?.rating ?? 0.0;
      final ratingB = b.fields?.rating ?? 0.0;
      return ratingB.compareTo(ratingA);
     });
     for (var book in list_top) {
    print(book.fields?.title);
  }
    print("Id User: "+user.id.toString());
    return list_product;
}

@override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(widget.user),
          ),
        ),
      ),
      title: const Text('My Books'),
    ),
    drawer: LeftDrawer(user: widget.user),
    body: FutureBuilder(
      future: fetchProduct(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada data Buku.",
              style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
            ),
          );
        } else {
          return Container(
            color: Color.fromRGBO(248, 247, 255, 1.000), // Set the background color
            child: ListView(
              children: [
                // Widget for displaying top 5 books
                TopBooksWidget(list_top.sublist(0, 5)),

                // Widget for displaying user's books
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final book = snapshot.data![index];
                    return BookCard(book: book, user: user);
                  },
                ),
              ],
            ),
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed:  () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShopFormPage(user: user),
          ),
        ),
      child: Icon(Icons.add),
      backgroundColor: Color.fromRGBO(184,184,255,1.000),
    ),
  );
}
}
class TopBooksWidget extends StatelessWidget {
  final List<Book> topBooks;

  TopBooksWidget(this.topBooks);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top 5 Books",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            height: 200, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 40),
              itemCount: topBooks.length,
              itemBuilder: (context, index) {
                final book = topBooks[index];
                return Container(
                  margin: const EdgeInsets.only(right: 10), // Adjust the right margin as needed
                  child: BuyBookWrappper(book: book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}