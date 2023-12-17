import 'package:album/albumpage.dart';
import 'package:album/createalbum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riviu_buku/models/album.dart';
import 'package:riviu_buku/models/user.dart';

class AlbumsPage extends StatefulWidget {
  final User user;

  AlbumsPage({Key? key, required this.user}) : super(key: key);

  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  String _searchQuery = '';

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/album/json/'));

    if (response.statusCode == 200) {
      List<Album> albums = albumFromJson(response.body);
      return albums.where((album) => album.fields.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }


  void viewAlbum(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlbumDetailsPage(album: album)),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums: Your Personal Book Collections'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Gather, organize, and share. Albums are an ideal way to group books.',
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Search albums...",
              ),
            ),
            Expanded(
              // Wrap the FutureBuilder in an Expanded widget
              child: FutureBuilder<List<Album>>(
                future: fetchAlbums(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error disini: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // change this number to adjust the number of items in a row
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Image.network(
                                    snapshot.data![index].fields.coverImage,
                                    fit: BoxFit.cover),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data![index].fields.name,
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Text(
                                          snapshot
                                              .data![index].fields.description,
                                          style:
                                              TextStyle(color: Colors.white)),
                                      ElevatedButton(
                                        onPressed: () =>
                                            viewAlbum(snapshot.data![index]),
                                        child: Text('View Album'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create album functionality
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateAlbumPage(user: user)),
          );
        },
        tooltip: 'Create an Album',
        child: Icon(Icons.add),
      ),
    );
  }
}
