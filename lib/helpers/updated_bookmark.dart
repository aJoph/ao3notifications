import 'package:ao3notifications/models/ao3_model.dart';
import 'package:flutter/material.dart';

/// UpdatedBookmark is a ListTile shown in the Updates page.
/// Will open the associated ao3 work linked.
class UpdatedBookmark extends StatelessWidget {
  final String title, author, link;

  /// updateCount is the number of new chapters found compared to before.
  /// It will be show in the UpdatedBookmark as:
  /// Text("$updateCount updates.")
  final int updateCount;

  const UpdatedBookmark({
    Key? key,
    required this.title,
    required this.author,
    required this.link,
    required this.updateCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Ao3Model.ao3launchUrl(link),
      child: ListTile(
        title: Text("$title by $author"),
        subtitle: Text("$updateCount updates."),
      ),
    );
  }

  factory UpdatedBookmark.fromJson(Map<String, dynamic> json) {
    return UpdatedBookmark(
      title: json['title'] as String,
      author: json['author'] as String,
      link: json['link'] as String,
      updateCount: json['updateCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'link': link,
      'updateCount': updateCount,
    };
  }
}
