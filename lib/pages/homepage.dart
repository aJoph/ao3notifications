import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/helpers/bookmark_view.dart';
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
        future: context.read<Ao3Model>().init(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching requests."));
          }
          return const BookmarkView();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<Ao3Model>().updateLibrary(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
