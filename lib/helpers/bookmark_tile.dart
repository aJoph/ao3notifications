import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkTile extends StatelessWidget {
  final Work work;
  const BookmarkTile({Key? key, required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${work.title} by ${work.author}"),
      subtitle: Text(work.description),
      onTap: () => _launchUrl(
        Ao3Client.getURLfromWorkID(work.workID),
      ), // TODO: Implement onTap for ListTiles
    );
  }

  void _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }
}
