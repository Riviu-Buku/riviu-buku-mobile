import 'package:flutter/material.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:profile/screens/create_profile_form.dart';
// import 'package:profile/screens/update_profile_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Book>> _likedBooks;

  @override
  void initState() {
    super.initState();
    _likedBooks = fetchLikedBooks();
  }

  Future<List<Book>> fetchLikedBooks() async {
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/profile/get-books-liked-by-user-flutter/'),
      body: jsonEncode(<String, String>{
        'user': widget.user.username,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey("liked_books")) {
        String likedBooksJson = responseData["liked_books"];
        List<dynamic> data = json.decode(likedBooksJson);
        List<Book> books = data.map((json) => Book.fromJson(json)).toList();
        return books;
      } else {
        throw Exception('Missing "liked_books" key in response');
      }
    } else {
      throw Exception('Failed to load liked books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 238, 221, 1.000),
      appBar: AppBar(
        title: Text(
          'Riviu Buku',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('Profile'),
            SizedBox(height: 8.0),
            if (widget.user.avatar.isNotEmpty)... {
              Container(
                width: 100.0,
                height: 100.0,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/${widget.user.avatar}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            } else ... {
              Container(
                width: 100.0,
                height: 100.0,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar-default.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            },
            SizedBox(height: 12.0),
            if (widget.user.name.isNotEmpty)
              Text(
                '${widget.user.name}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              '@${widget.user.username}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            if (widget.user.bio.isNotEmpty)
              Text(
                '"${widget.user.bio}"',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (widget.user.email.isNotEmpty)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon-email.png',
                      width: 15.0,
                      height: 15.0,
                    ),
                    SizedBox(width: 8.0),
                    Text('${widget.user.email}'),
                  ],
                ),
              ),
            if (widget.user.handphone.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon-handphone.png',
                    width: 15.0,
                    height: 15.0,
                  ),
                  SizedBox(width: 8.0),
                  Text('${widget.user.handphone}'),
                ],
              ),
            if (widget.user.address.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon-address.png',
                    width: 15.0,
                    height: 15.0,
                  ),
                  SizedBox(width: 8.0),
                  Text('${widget.user.address}'),
                ],
              ),
            SizedBox(height: 16),
            if (widget.user.email.isEmpty ||
                widget.user.handphone.isEmpty ||
                widget.user.address.isEmpty) ... {
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompleteProfileFormPage(user: widget.user),
                    ),
                  );
                },
                child: Text("Complete Profile"),
              ),
            },
            // } else ... {
            //   ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => EditProfileFormPage(user: widget.user),
            //         ),
            //       );
            //     },
            //     child: Text("Edit Profile"),
            //   ),
            // },
            SizedBox(height: 16),
            Text('Liked Books'),
            FutureBuilder(
              future: _likedBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Book> likedBooks = snapshot.data as List<Book>;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: likedBooks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              likedBooks[index].fields?.coverImg ?? '',
                              height: 80,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(likedBooks[index].fields?.title ?? ""),
                            subtitle:
                                Text(likedBooks[index].fields?.author ?? ""),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(
                                      user: widget.user,
                                      book: likedBooks[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
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
