import 'package:flutter/material.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:homepage/list_book.dart';
import 'package:profile/screens/create_profile_form.dart';
// import 'package:profile/screens/update_profile_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtherProfilePage extends StatefulWidget {
  final String user;
  final User authUser;
  OtherProfilePage({required this.user, required this.authUser});

  @override
  _OtherProfilePageState createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  late Future<List<Book>> _likedBooks;
  late Future<Map<String, String>> _user;
  late Map<String, String> userMap;

  @override
  void initState() {
    super.initState();
    _likedBooks = fetchLikedBooks();
    _user = fetchProfileUser();
  }

  Future<Map<String, String>> fetchProfileUser() async {
    final response = await http.post(
      Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/profile/get-profile-user/'),
      body: jsonEncode(<String, String>{
        'user': widget.user,
      }),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      userMap = {
        "name": responseData["name"],
        "avatar": responseData["avatar"],
        "email": responseData["email"],
        "bio": responseData["bio"],
        "handphone": responseData["handphone"],
        "address": responseData["address"]
      };
      return userMap;
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  Future<List<Book>> fetchLikedBooks() async {
    final response = await http.post(
      Uri.parse(
          'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/profile/get-books-liked-by-user-flutter/'),
      body: jsonEncode(<String, String>{
        'user': widget.user,
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
      backgroundColor: Colors.white,
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/elips-profile.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              SizedBox(height: 8.0),
              FutureBuilder(
                future: _user,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, String> profileUser =
                        snapshot.data as Map<String, String>;

                    Widget avatarWidget = profileUser["avatar"] != null
                        ? Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset:
                                      Offset(0, 3), // Offset in x and y axes
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/${profileUser["avatar"]}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset:
                                      Offset(0, 3), // Offset in x and y axes
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar-default.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        // Text(
                        //   'My Profile',
                        //   style: TextStyle(color: Colors.white)),
                        SizedBox(height: 8.0),
                        avatarWidget,
                        SizedBox(height: 12.0),
                        if (profileUser["name"] != null)
                          Text(
                            '${profileUser["name"]}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        Text(
                          '@${widget.user}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        if (profileUser["bio"] != null)
                          Text(
                            '"${profileUser["bio"]}"',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (profileUser["email"] != null)
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
                                Text('${profileUser["email"]}'),
                              ],
                            ),
                          ),
                        if (profileUser["handphone"] != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icon-handphone.png',
                                width: 15.0,
                                height: 15.0,
                              ),
                              SizedBox(width: 8.0),
                              Text('${profileUser["handphone"]}'),
                            ],
                          ),
                        if (profileUser["address"] != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icon-address.png',
                                width: 15.0,
                                height: 15.0,
                              ),
                              SizedBox(width: 8.0),
                              Text('${profileUser["address"]}'),
                            ],
                          ),
                        SizedBox(height: 16),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 25),
              Text(
                'Favorite Books',
                style: TextStyle(
                  color: Color.fromRGBO(90, 83, 131, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FutureBuilder(
                future: _likedBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Book> likedBooks = snapshot.data as List<Book>;
                    if (likedBooks.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "This user didn't have any liked books",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: likedBooks.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewPage(
                                      user: widget.authUser,
                                      book: likedBooks[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                child: Card(
                                  // elevation: 3,
                                  margin: EdgeInsets.all(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 224, 200, 255),
                                          Color.fromARGB(255, 255, 247, 226),
                                          Color.fromARGB(255, 229, 218, 255),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: Image.network(
                                              likedBooks[index]
                                                      .fields
                                                      ?.coverImg ??
                                                  '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            likedBooks[index].fields?.title ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            likedBooks[index].fields?.author ??
                                                "",
                                            style: TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
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
