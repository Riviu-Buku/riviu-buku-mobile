import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/models/review.dart';
import 'package:homepage/list_book.dart';
import 'package:riviu_buku/left_drawer.dart';
import 'package:review/review_form.dart';
import 'package:profile/screens/other_profilepage.dart';
import 'package:profile/screens/profilepage.dart';

import 'package:provider/provider.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  final Book book;
  final User user;
  ReviewPage({required this.book, required this.user});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late bool isLiked;
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

  Future<bool> fetchLikeStatus() async {
    isLiked = false;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/book-detail/get-liked-user-flutter/'),
      body: jsonEncode(<String, String>{
        'bookId': widget.book.pk.toString(),
        'user': widget.user.username,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      setState(() {
        isLiked = responseData['like'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("If you like the book, click the like button <3."),
        ),
      );
    }

    return isLiked;
  }

  Future<void> updateLikeStatus(bool likeStatus) async {
    // ... your code to update like status on the server ...
    if (likeStatus) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/book-detail/add-like-flutter/'),
        body: jsonEncode(<String, String>{
          'bookId': widget.book.pk.toString(),
          'user': widget.user.username,
        }),
      );
    } else {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/book-detail/add-unlike-flutter/'),
        body: jsonEncode(<String, String>{
          'bookId': widget.book.pk.toString(),
          'user': widget.user.username,
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLikeStatus().then((value) {
      setState(() {
        isLiked = value;
      });
    });
    // print(isLiked);
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
              Text(widget.book.fields?.author ?? ""),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Rating: ${widget.book.fields?.rating}",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                      width: 8), // Adjust the spacing between text and stars

                  RatingBar.builder(
                    initialRating: widget.book.fields?.rating ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20.0, // Adjust the size of the stars
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      // Handle the rating update if needed
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(widget.book.fields?.description ?? ""),
              SizedBox(height: 10),

              //create a like unlike button here using fetchLikeStatus
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Toggle like status
                      setState(() {
                        isLiked = !isLiked;
                      });

                      // Update like status on the server
                      await updateLikeStatus(isLiked);
                    },
                    child: Text(isLiked ? "Unlike" : "Like"),
                  ),

                  SizedBox(width: 8), // Adjust the spacing between buttons

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewFormPage(user: user, book: widget.book),
                        ),
                      );
                    },
                    child: Text("Add Review"),
                  ),
                ],
              ),
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
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true, // Important to prevent rendering issues
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling
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
                              GestureDetector(
                                onTap: () {
                                  if (widget.user.username ==
                                      snapshot.data[index].fields?.name) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilePage(user: widget.user),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherProfilePage(
                                            user: snapshot
                                                .data[index].fields?.name,
                                            authUser: widget.user),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "${snapshot.data[index].fields?.name ?? ""}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${snapshot.data[index].fields?.stars}"),
                              Row(
                                children: [
                                  Text(
                                    "Rating: ${snapshot.data[index].fields?.stars}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Adjust the spacing between text and stars

                                  RatingBar.builder(
                                    initialRating:
                                        snapshot.data[index].fields?.stars ??
                                            0.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize:
                                        20.0, // Adjust the size of the stars
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      // Handle the rating update if needed
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "${snapshot.data[index].fields?.description ?? ""}"),
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
