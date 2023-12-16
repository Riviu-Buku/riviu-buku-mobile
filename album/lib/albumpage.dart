import 'package:flutter/material.dart';
import 'package:riviu_buku/models/album.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlbumDetailsPage extends StatefulWidget {
  final Album album;

  AlbumDetailsPage({Key? key, required this.album}) : super(key: key);

  @override
  _AlbumDetailsPageState createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  Future<List<Book>> fetchBooksForAlbum(Album album) async {
    var url = Uri.parse('http://127.0.0.1:8000/json/');
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.fields.name),
      ),
      body: FutureBuilder(
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
                  Text(widget.album.fields.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  // TODO: Implement the rest of your UI here
                  Expanded(
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
                            // TODO: Implement your functionality here
                            print('Book clicked');
                          },
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Image.network(
                                    snapshot.data![index].fields?.coverImg ?? "",
                                    fit: BoxFit.cover, // this will resize and crop the image to fit the box
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
              ),
            );
          }
        },
      ),
    );
  }
}