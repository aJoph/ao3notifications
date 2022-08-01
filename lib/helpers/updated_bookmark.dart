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
    final texto = updateCount > 1 ? "updates" : "update";

    return InkWell(
      onTap: () => Ao3Model.ao3launchUrl(link),
      child: Card(
        color: Theme.of(context).colorScheme.onInverseSurface,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth - 16,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "$title by $author",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      "$updateCount $texto since last refresh",
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // child: ListTile(
      //   title: Text("$title by $author"),
      //   subtitle: Text("$updateCount updates."),
      // ),
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
