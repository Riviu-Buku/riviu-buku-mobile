import 'package:flutter/material.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:homepage/list_book.dart';
import 'package:review/reviewpage.dart';
import 'package:profile/screens/create_profile_form.dart';
import 'package:profile/screens/update_profile_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Book>> _likedBooks;
  late Map<String, String> userMap;
  late User userNow;
  late Future<List<User>> _user;

  @override
  void initState() {
    super.initState();
    _likedBooks = fetchLikedBooks();
    _user = fetchProfileUser();
  }

  Future<List<User>> fetchProfileUser() async {
    var url = Uri.parse(
        'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/profile/get-profile-user/${widget.user.id}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final responseData2 = jsonDecode(utf8.decode(response.bodyBytes));
      List<User> list_user = [];
      list_user.add(User.fromJson(responseData2));
      return list_user;
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  Future<List<Book>> fetchLikedBooks() async {
    final response = await http.post(
      Uri.parse(
          'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/profile/get-books-liked-by-user-flutter/'),
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

                    Widget avatarWidget = snapshot.data![0].avatar != ""
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
                                'assets/images/${snapshot.data![0].avatar}',
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

                    // return Column(
                    //   children: [
                    //     avatarWidget,
                    //   ],
                    // );
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
                        if (snapshot.data![0].name != "")
                          Text(
                            '${snapshot.data![0].name}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        Text(
                          '@${widget.user.username}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        if (snapshot.data![0].bio != "")
                          Text(
                            '"${snapshot.data![0].bio}"',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (snapshot.data![0].email != "")
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
                                Text('${snapshot.data![0].email}'),
                              ],
                            ),
                          ),
                        if (snapshot.data![0].handphone != "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icon-handphone.png',
                                width: 15.0,
                                height: 15.0,
                              ),
                              SizedBox(width: 8.0),
                              Text('${snapshot.data![0].handphone}'),
                            ],
                          ),
                        if (snapshot.data![0].address != "")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icon-address.png',
                                width: 15.0,
                                height: 15.0,
                              ),
                              SizedBox(width: 8.0),
                              Text('${snapshot.data![0].address}'),
                            ],
                          ),
                        SizedBox(height: 16),
                        if (snapshot.data![0].email == "")
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromRGBO(255, 216, 190, 1.000),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompleteProfileFormPage(
                                      user: snapshot.data![0]),
                                ),
                              );
                            },
                            child: Text("Complete Profile"),
                          )
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(254, 231, 192, 1),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileFormPage(
                                    user: widget.user,
                                    // email: profileUser['email'].toString(),
                                    // handphone:
                                    //     profileUser['handphone'].toString(),
                                    // bio: profileUser['bio'].toString(),
                                    // address:
                                    //     profileUser['address'].toString(),
                                    // name: profileUser['name'].toString(),
                                    // avatar: profileUser['avatar'].toString()
                                    email: snapshot.data![0].email.toString(),
                                    handphone:
                                        snapshot.data![0].handphone.toString(),
                                    bio: snapshot.data![0].bio.toString(),
                                    address:
                                        snapshot.data![0].address.toString(),
                                    name: snapshot.data![0].name.toString(),
                                    avatar: snapshot.data![0].avatar.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Text("Edit Profile"),
                          ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 25),
              Text(
                'My Favorite Books',
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
                            "You don't have any liked books, let's explore more!",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Homepage(user: widget.user),
                                ),
                              );
                            },
                            child: Text(
                              "More books",
                              style: TextStyle(
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
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
                                      user: widget.user,
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
                                          Color.fromARGB(255, 255, 237, 220),
                                          Color.fromARGB(255, 243, 241, 252),
                                          Color.fromARGB(255, 229, 218, 255),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(255, 189, 161, 220)
                                                  .withOpacity(0.4),
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
