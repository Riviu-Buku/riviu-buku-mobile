import 'package:flutter/material.dart';
import 'package:riviu_buku/models/book.dart';
import 'package:riviu_buku/models/user.dart';
import 'package:mybooks/mybooks.dart';
class BookCard extends StatelessWidget {
  final Book book;
  final User user;

  const BookCard({
    Key? key,
    required this.book,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? title = book.fields!.title;
    final int? likes = book.fields!.numLikes;
    final double rating = book.fields!.rating ?? 0;
    String description = book.fields!.description ?? "";
    if(description == ""){
      description = "Tidak ada desripsi";
    }
    String stars = "Unrated";
    Color starColor = Colors.black;
    if(rating >= 0.5 && rating < 1.5){
      stars = "⭐";
      starColor = Colors.yellow;
    }else if(rating >= 1.5 && rating < 2.5){
      stars = "⭐⭐";
      starColor = Colors.yellow;
    }else if(rating >= 2.5 && rating < 3.5){
      stars = "⭐⭐⭐";
      starColor = Colors.yellow;
    }else if(rating >= 3.5 && rating < 4.5){
      stars = "⭐⭐⭐⭐";
      starColor = Colors.yellow;
    }else if(rating >= 4.5){
      stars = "⭐⭐⭐⭐⭐";
      starColor = Colors.yellow;
    }
    return InkWell(
      onTap: () => navigateDetailPage(context, book),
      child: Card(
        color: const Color.fromRGBO(255,238,221,1.000),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                  tag: 'poster-$book',
                  child: Image.network(
                    book.fields!.coverImg ?? "",
                    width: 100,
                    height: 150,
                    loadingBuilder: (context, child, loadingProgress) {
                      return Container(
                        color: Color.fromRGBO(184,184,255,1.000),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Hero(
                    tag: 'title-$title',
                    child: Text(
                      title ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Hero(
                    tag: 'description-$description',
                    child: Text(
                      ("Deskripsi: "+ description),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Hero(
                    tag: 'description-$likes',
                    child: Text(
                      ("Likes: "+ likes.toString() ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Hero(
                    tag: 'description-$rating',
                    child: Text(
                      stars,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        color: starColor,
                        fontSize: 12
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateDetailPage(BuildContext context, Book book) {
    final route = MaterialPageRoute(
      builder: (context) {
        return MyBookPage(user: user);
      },
    );
    Navigator.push(context, route);
  }
}