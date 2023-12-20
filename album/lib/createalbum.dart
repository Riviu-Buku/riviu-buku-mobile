import 'package:flutter/material.dart';
import 'package:riviu_buku/models/album.dart' as album;
import 'package:riviu_buku/models/book.dart' as book;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/user.dart';
import 'package:album/albumspage.dart';
import 'package:review/reviewpage.dart';

import 'albumpage.dart';

class CreateAlbumPage extends StatefulWidget {
  final User user;
  CreateAlbumPage({Key? key, required this.user}) : super(key: key);
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();

}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<int> _selectedBooks = [];
  Map<int, book.Book> _books = {};

  Future<List<book.Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/'));

    if (response.statusCode == 200) {
      List<book.Book> books = book.bookFromJson(response.body);
      return books.where((book) {
        if (book.fields?.title == null) {
          print('Title is null for book: ${book.pk}');
        }
        if (_searchController.text == null) {
          print('Search query is null');
        }
        return book.fields?.title?.toLowerCase().contains(_searchController.text.toLowerCase() ?? '') ?? false;
      }).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Widget buildSelectedBooks() {
    return GridView.builder(
      itemCount: _selectedBooks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        book.Book selectedBook = _books[_selectedBooks[index]]!;
        book.Fields bookFields = selectedBook.fields!;
        return GestureDetector(
          onTap: () {
            // TODO: Implement onTap functionality if needed
          },
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Image.network(
                        bookFields.coverImg ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      (bookFields.title) ?? 'Default Title',
                      style: TextStyle(color: Color.fromARGB(255, 107, 66, 117)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Color.fromRGBO(147, 129, 255, 1.000)),
                    onPressed: () {
                      setState(() {
                        _selectedBooks.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<album.Album> createAlbum() async {
    var url = Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/album/create-album-flutter/');

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'books': _selectedBooks,
        'user': widget.user.username,
      }),
    );

    if (response.statusCode == 201) {
      // If the server returns a 201 Created response, the album was created successfully.
      print('Album created successfully');

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> albumList = json.decode(jsonResponse['album']);
      Map<String, dynamic> albumMap = albumList[0];

      return album.Album.fromJson(albumMap);
    } else {
      // If the server returns an error response, print the error message and return null.
      print('Failed to create album: ${response.statusCode}');
      return album.Album(model: '', pk: 0, fields: album.Fields(name: '', slug: '', user: 0, description: '', coverImage: '', books: []));
    }
  }



  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a new album',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 191, 156, 239),
              Color.fromARGB(255, 216, 191, 247),
              Color.fromARGB(255, 255, 223, 182),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter album name',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter album description',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Search for books:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for books',
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                  ),
                  onChanged: (value) {
                    // Call fetchBooks when the search query changes
                    setState(() {});
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Add books to your album',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                ),
                FutureBuilder(
                  future: fetchBooks(),
                  builder: (context, AsyncSnapshot<List<book.Book>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 500,
                            child: GridView.builder(
                              itemCount: snapshot.data!.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Image.network(
                                          snapshot.data![index].fields?.coverImg ?? "",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        (snapshot.data![index].fields?.title) ?? 'Default Title',
                                        style: TextStyle(color: Color.fromARGB(255, 107, 66, 117)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (snapshot.data![index].pk != null) {
                                              _selectedBooks.add(snapshot.data![index].pk!);
                                              _books[snapshot.data![index].pk!] = snapshot.data![index];
                                            }
                                          });
                                        },
                                        child: Text(
                                          'Add to Album',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return ReviewPage(
                                                    book: snapshot.data![index], user: user,
                                                  );
                                                }
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'View Book',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Selected Books:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Container(
                  height: 200, // Adjust the height as needed
                  child: buildSelectedBooks(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Check if title and description are not empty and at least one book is selected
                    if (_nameController.text.trim().isEmpty ||
                        _descriptionController.text.trim().isEmpty ||
                        _selectedBooks.isEmpty) {
                      // Show a dialog or a snackbar to inform the user about the missing information
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Incomplete Information'),
                            content: Text('Please enter album title and description, and select at least one book.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // All conditions are met, proceed with creating the album
                      album.Album createdAlbum = await createAlbum();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlbumDetailsPage(album: createdAlbum, user: user)),
                      );
                    }
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}