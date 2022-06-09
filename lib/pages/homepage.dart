import 'package:ao3notifications/helpers/change_username_dialog.dart';
import 'package:ao3notifications/helpers/bookmark_view.dart';
import 'package:ao3notifications/pages/updates_page.dart';
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
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => const UsernameDialog());
            },
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(width: 16.0)
        ],
      ),
      body: const BookmarkView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ));
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
