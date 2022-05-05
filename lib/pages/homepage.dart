import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/helpers/bookmark_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<Ao3Model>().updateLibrary();
    debugPrint("Username: " + context.read<Ao3Model>().username);
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
