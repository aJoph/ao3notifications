import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/bookmark_icon.dart';
import 'package:ao3notifications/models/ao3_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bookmarks = context.watch<Ao3Model>().bookmarks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ao3 Notifications"),
      ),
      body: ListView.builder(
        itemCount: _bookmarks.length,
        itemBuilder: (context, index) {
          return BookmarkIcon(
            title: _bookmarks[index].title,
            author: _bookmarks[index].author,
            description: _bookmarks[index].description,
            link: Ao3Client.getURLfromWorkID(
              _bookmarks[index].workID,
            ),
          );
        },
      ),
    );
  }
}
