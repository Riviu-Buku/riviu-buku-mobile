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


class MyBookPage extends StatefulWidget {
    final User user;
    const MyBookPage({Key? key, required this.user}) : super(key: key);

    @override
    _MyBookPageState createState() => _MyBookPageState(user);
}

class _MyBookPageState extends State<MyBookPage> {
  final User user;
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
    for (var d in data) {
        if (d != null) {
            Book book = Book.fromJson(d);
            print(book.fields!.user);
            if(book.fields!.user == user.id){
              list_product.add(book);
            }
        }
    }
    print("Id User: "+user.id.toString());
    return list_product;
}

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
            return Stack(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 0,
                    mainAxisExtent: 330,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    height: 200,
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                    child: BuyBookWrappper(book: snapshot.data![index]),
            ),
                  ],
                ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                     onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShopFormPage(user: user),
            ),
          ),
                    backgroundColor: Color.fromRGBO(184,184,255,1.000),
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}