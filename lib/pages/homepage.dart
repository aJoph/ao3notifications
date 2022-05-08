import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/helpers/bookmark_view.dart';
import 'package:ao3notifications/pages/updates_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: FutureBuilder(
        future: context.watch<Ao3Model>().initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching requests."));
          }
          return const BookmarkView();
        },
      ),
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
