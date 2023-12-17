import 'book_cover3d.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:flutter/material.dart';

class BuyBookWrappper extends StatelessWidget {
  final Book book;

  const BuyBookWrappper({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
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
}