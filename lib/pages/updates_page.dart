import 'package:flutter/material.dart';

// TODO: Implement notifications page and notificationtile.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Updates")),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return const Text("To be implemented");
        }),
      ),
    );
  }
}
