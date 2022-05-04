import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/helpers/bookmark_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        actions: [
          InkWell(
            onTap: () => Ao3Model.showChangeUsernameDialog(context),
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(width: 16.0)
        ],
      ),
      body: const BookmarkView(),
    );
  }
}
