import 'package:ao3notifications/ao3_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Updates")),
      body: const UpdatesListView(),
    );
  }
}

class UpdatesListView extends StatelessWidget {
  const UpdatesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updates = context.watch<Ao3Model>().notifications;

    if (updates.isEmpty) return const NoUpdatesFound();

    return ListView.builder(
      itemCount: updates.length,
      itemBuilder: (context, index) {
        return updates[index];
      },
    );
  }
}

class NoUpdatesFound extends StatelessWidget {
  const NoUpdatesFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No updates found.",
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
