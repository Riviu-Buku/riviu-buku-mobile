import 'package:flutter/material.dart';
import 'package:riviu_buku/models/album.dart' as album;
import 'package:riviu_buku/models/book.dart' as book;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAlbumPage extends StatefulWidget {
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<book.Book> _selectedBooks = [];

  Future<List<book.Book>> fetchBooks() async {
    var url = Uri.parse('http://127.0.0.1:8000/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<book.Book> list_book = [];
    for (var d in data) {
      if (d != null) {
        list_book.add(book.Book.fromJson(d));
      }
    }
    return list_book;
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
        book.Fields bookFields = _selectedBooks[index].fields!;
        print(bookFields.toJson());
        return GestureDetector(
          onTap: () {
            // TODO: Implement onTap functionality if needed
          },
          child: Card(
            child: Column(
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
          ),
        );
      },
    );
  }





  Future<void> createAlbum() async {
    var url = Uri.parse('http://127.0.0.1:8000/album/create-album'); // replace with your Django server URL

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'books': _selectedBooks,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then the album was created successfully.
      print('Album created successfully');
    } else {
      // If the server returns an error response, then the album was not created.
      print('Failed to create album');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // TODO: Implement search functionality
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
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (snapshot.data![index].pk != null) {
                                    _selectedBooks.add(snapshot.data![index]);
                                  }
                                });
                              },
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Image.network(
                                        snapshot.data![index].fields?.coverImg ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text((snapshot.data![index].fields?.title) ?? 'Default Title'),
                                  ],
                                ),
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
              onPressed: () {
                // TODO: Implement create album functionality
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
