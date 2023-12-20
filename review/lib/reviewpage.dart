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
import 'package:expandable_text/expandable_text.dart';
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
  bool isExpanded = false;
  Future<List<Review>> fetchReview() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!

    var url = Uri.parse(
        'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/book-detail/get-review/${widget.book.pk}'
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
      // Uri.parse('http://127.0.0.1:8000/book-detail/get-liked-user-flutter/'),
      Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/book-detail/get-liked-user-flutter/'),
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
        // Uri.parse('http://127.0.0.1:8000/book-detail/add-like-flutter/'),
        Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/book-detail/add-like-flutter/'),
        body: jsonEncode(<String, String>{
          'bookId': widget.book.pk.toString(),
          'user': widget.user.username,
        }),
      );
    } else {
      final response = await http.post(
        // Uri.parse('http://127.0.0.1:8000/book-detail/add-unlike-flutter/'),
        Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/book-detail/add-unlike-flutter/'),
        body: jsonEncode(<String, String>{
          'bookId': widget.book.pk.toString(),
          'user': widget.user.username,
        }),
      );
    }
  }

  Future<void> deleteReview(int reviewID) async {
    // ... your code to update like status on the server ...    
    final response = await http.post(
      // Uri.parse('http://127.0.0.1:8000/book-detail/delete-review-flutter/'),
      Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/book-detail/delete-review-flutter/'),
      body: jsonEncode(<String, String>{
        'reviewID': reviewID.toString(),
      }),
    );

    final responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Succesfully delete review."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("If you like the book, click the like button <3."),
        ),
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
        title: Text('Detail Review',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
      ),
      drawer: LeftDrawer(user: user),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image on the left side
                Image.network(
                  widget.book.fields?.coverImg ?? "",
                  height: 150,
                  width: 100,
                ),
                SizedBox(width: 20), // Adjust the spacing between image and text

                // Text elements on the right side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.fields?.title ?? "",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(widget.book.fields?.author ?? "",
                      style: TextStyle(
                              fontSize: 16.0,
                              
                            ),),
                      SizedBox(height: 10),
                      Text(
                        "${widget.book.fields?.rating} out of 5.0",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10), // Adjust the spacing between text and stars
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
                ),
              ],
            ),
        // Add other widgets as needed, e.g., like/unlike button
              SizedBox(height: 10),
              Container(
                child: ExpandableText(
                      widget.book.fields?.description ?? "",
                      expandText: 'show more',
                      collapseText: 'show less',
                      maxLines: 3,
                      linkColor: Colors.blue,
                  )
              ),
              //create a like unlike button here using fetchLikeStatus
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                              backgroundColor: isLiked ?
                                  Color.fromRGBO(184, 184, 255, 1.000) :
                                  Color.fromRGBO(254, 231, 192, 1),
                              foregroundColor: Colors.black,
                            ),
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

                  SizedBox(width: 10), // Adjust the spacing between buttons

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromRGBO(254, 231, 192, 1),
                              foregroundColor: Colors.black,
                            ),
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
                  SizedBox(height: 10),
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
                      child: Padding(
                        padding: EdgeInsets.all(20.0), // Add 20 pixels of padding on all sides
                        child: Text(
                          "Tidak ada data review. Jadilah yang pertama untuk mereview buku ini!",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 238, 221, 1), // Background color
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                            child: Stack(
                              children: [
                                Padding(
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
                                                    authUser: widget.user,
                                                     ),
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
                                      Row(
                                        children: [
                                          Text(
                                            "Rating: ${snapshot.data[index].fields?.stars}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          RatingBar.builder(
                                            initialRating:
                                                snapshot.data[index].fields?.stars ?? 0.0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20.0,
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
                                      const SizedBox(height: 10),
                                      Text("${snapshot.data[index].fields?.description ?? ""}"),
                                    ],
                                  ),
                                ),
                                if (snapshot.data[index].fields?.name == widget.user.username)
                                  Positioned(
                                    top: 20,
                                    right: 10,
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () async {
                                          // Replace with the actual review ID you want to delete
                                          int reviewID = snapshot.data[index].pk;

                                          // Call the deleteReview function
                                          await deleteReview(reviewID);

                                          // Navigate to ReviewPage after successful deletion
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReviewPage(
                                                book: widget.book,
                                                user: widget.user,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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