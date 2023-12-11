
import 'package:flutter/material.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/left_drawer.dart';

class ReviewPage extends StatelessWidget {
  final Book book;

  ReviewPage({Key? key, required this.book}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Pop navigator untuk kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
      ),
      drawer: LeftDrawer(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Text(
              book.fields.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("Price: ${book.fields.price}"),
            SizedBox(height: 10),
            Text(book.fields.description ?? ""),
            SizedBox(height: 10),
            Text(book.fields.author),
            SizedBox(height: 10),
            Text(book.fields.coverImg ?? ""),
            // Add more details as needed
            */
          ],
        ),
      ),
    );
  }
}
