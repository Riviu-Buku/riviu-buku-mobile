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
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/json/'));

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
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        book.Book selectedBook = _books[_selectedBooks[index]]!;
        book.Fields bookFields = selectedBook.fields!;
        return GestureDetector(
          onTap: () {
            // TODO: Implement onTap functionality if needed
          },
          child: Card(
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
                    Text((bookFields.title) ?? 'Default Title'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
    var url = Uri.parse('http://127.0.0.1:8000/album/create-album-flutter/');

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

      // Parse the JSON response and return the Album object
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return album.Album.fromJson(jsonResponse['album']);
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
        title: Text('Create a new album'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter album name',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter album description',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16.0),
            Text('Search for books:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for books',
              ),
              onChanged: (value) {
                // Call fetchBooks when the search query changes
                setState(() {});
              },
            ),
            SizedBox(height: 16.0),
            Text('Add books to your album', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
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
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Image.network(
                                      snapshot.data![index].fields?.coverImg ?? "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text((snapshot.data![index].fields?.title) ?? 'Default Title'),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (snapshot.data![index].pk != null) {
                                          _selectedBooks.add(snapshot.data![index].pk!);
                                          _books[snapshot.data![index].pk!] = snapshot.data![index];
                                        }
                                      });
                                    },
                                    child: Text('Add to Album'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context){
                            return ReviewPage(
                            book: snapshot.data![index], user: user,
                            );
                            }
                            ),
                            );
                                      },
                                    child: Text('View Book'),
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
            Text('Selected Books:', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 200, // Adjust the height as needed
              child: buildSelectedBooks(),
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO: Implement create album functionality
                album.Album createdAlbum = await createAlbum();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlbumDetailsPage(album: createdAlbum, user: user)),
                );
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}