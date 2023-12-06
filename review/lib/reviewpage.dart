// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/models/review.dart';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/left_drawer.dart';

class ReviewPage extends StatefulWidget {
  final Book book;
  const ReviewPage({Key? key, required this.book}) : super(key: key);

  @override
  _ReviewPageState createState () => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
Future<List<Review>> fetchReview() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://127.0.0.1:8000/book-detail/get-review/${widget.book.pk}'
        // TODO: 
        // 'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/'
        );
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Review> list_review = [];
    //TODO: Comment line dibawah (hanya nampilin 1 buku)
    // list_book.add(Book.fromJson(data[0]));

    //TODO: Uncomment line dibawah buat nampilin semua data buku (berat 100>)
    for (var d in data) {
        if (d != null) {
            list_review.add(Review.fromJson(d));
        }
    }
    return list_review;
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Detail Review'),
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
          Text(
            widget.book.fields?.title ?? "", // Add null check
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text("Price: ${widget.book.fields?.price}"), // Add null check
          SizedBox(height: 10),
          Text(widget.book.fields?.description ?? ""),
          SizedBox(height: 10),
          Text(widget.book.fields?.author ?? ""),
          SizedBox(height: 10),
          Text(widget.book.fields?.coverImg ?? ""),
          // Add more details as needed

          // Add a FutureBuilder for reviews
          FutureBuilder(
            future: fetchReview(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                    "Tidak ada data review.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                );
              } else {
                // Use the fetched data in the ListView.builder
                return Container(
                  height: 400, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        // Navigate to the detail review page
                        // You may want to create a ReviewDetailPage for this
                        // and pass the review details to it
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ReviewDetailPage(
                        //       review: snapshot.data[index],
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.data[index].fields?.name ?? ""}", // Add null check
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("${snapshot.data[index].fields?.stars}"), // Add null check
                            const SizedBox(height: 10),
                            Text("${snapshot.data[index].fields?.description ?? ""}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
  }
}
