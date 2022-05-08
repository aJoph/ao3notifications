import 'package:ao3notifications/ao3_model.dart';
import 'package:flutter/material.dart';

/// UpdatedBookmark is a ListTile shown in the Updates page.
/// Will open the associated ao3 work linked.
class UpdatedBookmark extends StatelessWidget {
  final String title, author, link;

  /// newChapterCount is the number of new chapters found compared to before.
  /// It will be show in the UpdatedBookmark as:
  /// Text("$newChapterCount updates.")
  final int newChapterCount;
  const UpdatedBookmark({
    Key? key,
    required this.title,
    required this.author,
    required this.link,
    required this.newChapterCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Ao3Model.ao3launchUrl(link),
      child: ListTile(
        title: Text("$title by $author"),
        subtitle: Text("$newChapterCount updates."),
      ),
    );
  }
}
