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
      body: ListView.builder(
        itemCount: context.read<Ao3Model>().bookmarks.length,
        itemBuilder: (context, index) {
          return Text("Article.");
        },
      ),
    );
  }
}
