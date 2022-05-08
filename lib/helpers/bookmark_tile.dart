import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/ao3_model.dart';
import 'package:flutter/material.dart';

class BookmarkTile extends StatelessWidget {
  final Work work;
  const BookmarkTile({Key? key, required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${work.title} by ${work.author}"),
      subtitle: Text(work.description),
      onTap: () => Ao3Model.ao3launchUrl(
        Ao3Client.getURLfromWorkID(work.workID),
      ),
    );
  }
}
