import 'package:flutter/material.dart';
import 'package:riviu_buku/models/album.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:review/reviewpage.dart';
import 'package:album/editalbum.dart';
import 'package:album/albumspage.dart';

class AlbumDetailsPage extends StatefulWidget {
  final Album album;
  final User user;
  AlbumDetailsPage({Key? key, required this.user, required this.album}) : super(key: key);

  @override
  _AlbumDetailsPageState createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  Future<List<Book>> fetchBooksForAlbum(Album album) async {
    var url = Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> list_book = [];
    for (var d in data) {
      if (d != null && album.fields.books.contains(d['pk'])) {
        list_book.add(Book.fromJson(d));
      }
    }
    return list_book;
  }

  bool canEditAlbum() {
    // Check if the current user is the one who made the album
    print(widget.album.fields.user + widget.user.id);
    return widget.album.fields.user == widget.user.id;
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.album.fields.name,
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(147, 129, 255, 1.000),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumsPage(user: widget.user),
              ),
            );
          },
        ),
        actions: [
          if (canEditAlbum())
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAlbumPage(user: widget.user, album: widget.album),
                  ),
                );
              },
            ),
        ],
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
        child: FutureBuilder(
          future: fetchBooksForAlbum(widget.album),
          builder: (context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.album.fields.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
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
                            child: Card(
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}