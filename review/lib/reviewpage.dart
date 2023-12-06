import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/models/review.dart';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/left_drawer.dart';

import 'package:provider/provider.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';

class ReviewPage extends ConsumerStatefulWidget {
  final Book book;
  final User user;
   ReviewPage({required this.book, required this.user});

  @override
  _ReviewPageState createState () => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
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
    for (var d in data) {
        if (d != null) {
            list_review.add(Review.fromJson(d));
        }
    }
    return list_review;
}

    @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Review'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: LeftDrawer(user: user),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //shows login username and password here
              // Text(
              //   //TODO: cara nampilin user
              //   widget.user.username,
              //   style: TextStyle(
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),

              Text(
                widget.book.fields?.title ?? "",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Image.network(
                widget.book.fields?.coverImg ?? "",
                height: 200,
                width: 150,
              ),
              SizedBox(height: 10),
              Text("Rating: ${widget.book.fields?.rating}"),
              SizedBox(height: 10),
              Text(widget.book.fields?.description ?? ""),
              SizedBox(height: 10),
              Text(widget.book.fields?.author ?? ""),
              SizedBox(height: 10),
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
                    return ListView.builder(
                      shrinkWrap: true, // Important to prevent rendering issues
                      physics: NeverScrollableScrollPhysics(), // Disable scrolling
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data[index].fields?.name ?? ""}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${snapshot.data[index].fields?.stars}"),
                              const SizedBox(height: 10),
                              Text("${snapshot.data[index].fields?.description ?? ""}"),
                            ],
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
      ),
    );
  }
}