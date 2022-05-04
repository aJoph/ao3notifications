import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:flutter/material.dart';

class BookmarkTile extends StatelessWidget {
  final Work work;
  const BookmarkTile({Key? key, required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const Text("djasoidj"),
    );
    // return ListTile(
    //   title: Text("${work.title} by ${work.author}"),
    //   subtitle: Text(work.description),
    // );
  }
}
