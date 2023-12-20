import 'book_cover3d.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:flutter/material.dart';
import 'package:review/reviewpage.dart';

class BuyBookWrappper extends StatelessWidget {
  final Book book;
  final User user;

  const BuyBookWrappper({
    Key? key,
    required this.book,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateDetailPage(context, book),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BookCover3D(
            imageUrl: book.fields!.coverImg ?? "assets/images/defaultCoverImg.jpg",
          ),
          
        ],
      ),
    );
  }

  void navigateDetailPage(BuildContext context, Book book) {
    final route = MaterialPageRoute(
      builder: (context) {
        return ReviewPage(book: book, user: user);
      },
    );
    Navigator.push(context, route);
  }
}