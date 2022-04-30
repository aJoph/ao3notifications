import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/bookmark_icon.dart';
import 'package:ao3notifications/helpers/bookmark_view.dart';
import 'package:ao3notifications/models/ao3_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ao3 Notifications"),
      ),
      body: const BookmarkView(),
    );
  }
}
