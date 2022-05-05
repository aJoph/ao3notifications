import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/helpers/bookmark_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bookmarks = context.watch<Ao3Model>().bookmarks;

    return ListView.builder(
      itemCount: _bookmarks.length,
      itemBuilder: (context, index) {
        return BookmarkTile(work: _bookmarks[index]);
      },
    );
  }
}
