import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkIcon extends StatelessWidget {
  final String title, author, description, link;
  final int chapterCount;
  const BookmarkIcon({
    Key? key,
    required this.title,
    required this.author,
    required this.description,
    this.chapterCount = 1,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(link),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              Text(author),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }
}
