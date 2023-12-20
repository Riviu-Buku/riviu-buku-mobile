import 'package:flutter/material.dart';
import 'package:riviu_buku/models/album.dart' as album_model;
import 'package:riviu_buku/models/book.dart' as book_model;
import 'package:riviu_buku/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:album/albumspage.dart';
import 'package:review/reviewpage.dart';

import 'albumpage.dart';

class EditAlbumPage extends StatefulWidget {
  final album_model.Album album;
  final User user;
  EditAlbumPage({Key? key,  required this.user, required this.album}) : super(key: key);

  @override
  _EditAlbumPageState createState() => _EditAlbumPageState();
}

class _EditAlbumPageState extends State<EditAlbumPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<int> _selectedBooks = [];
  Map<int, book_model.Book> _books = {};

  @override
  void initState() {
    super.initState();
    _selectedBooks = List.from(widget.album.fields.books);
    _nameController.text = widget.album.fields.name;
    _descriptionController.text = widget.album.fields.description;
  }

  Future<List<book_model.Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/'));

    if (response.statusCode == 200) {
      List<book_model.Book> books = book_model.bookFromJson(response.body);

      // Add each book to the _books map for easy access
      _books = Map.fromIterable(books, key: (book) => book.pk, value: (book) => book);

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
    return FutureBuilder(
      future: fetchBooks(),
      builder: (context, AsyncSnapshot<List<book_model.Book>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GridView.builder(
            itemCount: _selectedBooks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final int bookId = _selectedBooks[index];

              // Check if book details are available in the _books map
              if (_books.containsKey(bookId)) {
                final book_model.Book selectedBook = _books[bookId]!;
                final book_model.Fields bookFields = selectedBook.fields!;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context){
                            return ReviewPage(
                              book: snapshot.data![index], user: widget.user,
                            );
                          }
                      ),
                    );
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
                                _books.remove(bookId);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Handle the case when book details are not available
                return Container(
                  // You can display a loading indicator or any placeholder widget
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
      },
    );
  }



  Future<void> updateAlbum() async {
    var url = Uri.parse(
        'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/album/edit-album-flutter/${widget.album.fields.slug}/');

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'pk': widget.album.pk,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'books': _selectedBooks,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then the album was updated successfully.
      print('Album updated successfully');
    } else {
      // If the server returns an error response, then the album was not updated.
      print('Failed to update album');
    }
  }

  // Function to delete the album
  Future<void> deleteAlbum() async {
    var url = Uri.parse(
        'https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/album/delete-album-flutter/${widget.album.fields.slug}/');

    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then the album was deleted successfully.
      print('Album deleted successfully');

    } else {
      // If the server returns an error response, then the album was not deleted.
      print('Failed to delete album');
    }
  }

  // Build the delete button
  Widget buildDeleteButton() {
    return ElevatedButton(
      onPressed: () {
        // Show a confirmation dialog before deleting the album
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Album'),
              content: Text('Are you sure you want to delete this album?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Dismiss the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Delete the album and dismiss the dialog
                    deleteAlbum();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlbumsPage(user: widget.user)),
                    );
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: Text('Delete Album'),
    );
  }


  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit album'),
        actions: [
          // Add the delete button to the app bar
          buildDeleteButton(),
        ],
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
                builder: (context, AsyncSnapshot<List<book_model.Book>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 200,
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
                onPressed: () {
                  // TODO: Implement create album functionality
                  updateAlbum();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlbumDetailsPage(album: widget.album, user: user)),
                  );
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}