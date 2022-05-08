import 'package:ao3notifications/helpers/updated_bookmark.dart';
import 'package:flutter/material.dart';

// TODO: Implement notifications page and notifications tile.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Updates")),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return const Text(
              "Someday, I'll conquer the land and have you slayed.");
        }),
        //   return const UpdatedBookmark(
        //       title: title,
        //       author: author,
        //       link: link,
        //       newChapterCount: newChapterCount);
        // }),
      ),
    );
  }
}
