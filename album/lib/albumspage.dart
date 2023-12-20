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
    final response = await http.get(Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/album/json/'));

    if (response.statusCode == 200) {
      List<Album> albums = albumFromJson(response.body);
      return albums.where((album) => album.fields.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }


  void viewAlbum(Album album, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlbumDetailsPage(album: album, user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Albums: Your Personal Book Collections',
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
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Gather, organize, and share. Albums are an ideal way to group books.',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto', color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Search albums...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Album>>(
                  future: fetchAlbums(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error disini: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        padding: EdgeInsets.all(10.0),
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
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Image.network(
                                    snapshot.data![index].fields.coverImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data![index].fields.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          snapshot.data![index].fields.description,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => viewAlbum(snapshot.data![index], user),
                                          child: Text(
                                            'View Album',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                                color: Colors.white
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(255, 112, 165, 208),
                                          ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateAlbumPage(user: user)),
          );
        },
        tooltip: 'Create an Album',
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 112, 165, 208),
      ),
    );
  }
}