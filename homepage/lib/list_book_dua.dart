import 'package:flutter/material.dart';
import 'package:homepage/recommend_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riviu_buku/models/book.dart';
import 'package:review/reviewpage.dart';
import 'package:riviu_buku/left_drawer.dart';
import 'package:riviu_buku/models/recommended_book.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:riviu_buku/provider/user_provider.dart';

class Searchpage extends StatefulWidget {
  final User user;

  const Searchpage({Key? key, required this.user}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<Searchpage> {
  late List<Book> _allBooks;
  late List<Book> _filteredBooks;
  late List<RecommendedBook> _recommendedBooks;
  TextEditingController _searchController = TextEditingController();

  String latestRecommendedBookTitle = "";
  String latestRecommendedBookAuthor = "";

  @override
  void initState() {
    super.initState();
    _filteredBooks = [];
    _allBooks = [];
    _recommendedBooks = [];
    fetchBook().then((books) {
      setState(() {
        _allBooks = books;
        _filteredBooks = books;
      });
    });
    fetchLatestRecommendedBook().then((recommendedBooks) {
      setState(() {
        _recommendedBooks = recommendedBooks;
      });
    });
  }

  Future<List<RecommendedBook>> fetchLatestRecommendedBook() async {
    var response = await http.get(
        Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/show_recommended_book_json/'),
        headers: {"Content-Type": "application/json"},
      );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<RecommendedBook> listRecommendedBook = [];
    for (var d in data) {
      if (d != null) {
        listRecommendedBook.add(RecommendedBook.fromJson(d));
      }
    }
    return listRecommendedBook; 
  }

  Future<List<Book>> fetchBook() async {
    var url = Uri.parse('https://riviu-buku-d07-tk.pbp.cs.ui.ac.id/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    return listBook;
  }

  void _filterBooks(String query) {
    setState(() {
      _filteredBooks = _allBooks
          .where((book) =>
              book.fields?.title?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Buku',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(147, 129, 255, 1.000),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: LeftDrawer(user: user),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _filterBooks(query);
              },
              decoration: InputDecoration(
                hintText: 'Search by title',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterBooks('');
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: _filteredBooks.isEmpty
                ? Center(
                    child: _searchController.text.isEmpty
                        ? const CircularProgressIndicator()
                        : const Text('Judul buku tidak ditemukan'),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (_, index) => GestureDetector(
                      
                      child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                _filteredBooks[index].fields?.coverImg ?? "",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${_filteredBooks[index].fields?.title}",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 16.0),
          // Menampilkan buku terakhir yang direkomendasikan
          _recommendedBooks.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Rekomendasi Buku',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${_recommendedBooks.last.fields.title} oleh ${_recommendedBooks.last.fields.author}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                )
              : const SizedBox.shrink(),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendedBookForm(user : user),
                ),
              ).then((result) {
                // When RecommendedBookForm is popped, refresh the latest recommended book
                if (result == true) {
                  fetchLatestRecommendedBook();
                }
              });
            },
            child: Text('Rekomendasikan Buku'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
          ),
        ],
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<String> {
  final List<Book> books;
  final User user;

  BookSearchDelegate(this.books, this.user);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

 Widget _buildSearchResults(BuildContext context) {
    final filteredBooks = books
        .where((book) =>
            book.fields?.title?.toLowerCase().contains(query.toLowerCase()) ??
            false)
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: filteredBooks.length,
      itemBuilder: (_, index) => GestureDetector(
        onTap: () {
          // Navigate to the detail item page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ReviewPage(
                  book: filteredBooks[index],
                  user: user,
                );
              },
            ),
          );
        },
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  filteredBooks[index].fields?.coverImg ?? "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${filteredBooks[index].fields?.title}",
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
  }
}