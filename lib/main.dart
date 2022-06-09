import 'package:ao3notifications/models/ao3_model.dart';
import 'package:ao3notifications/apptheme.dart';
import 'package:ao3notifications/pages/authpage.dart';
import 'package:ao3notifications/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/ao3_model.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Ao3Model(),
      child: const Ao3App(),
    ),
  );
}

class Ao3App extends StatelessWidget {
  const Ao3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ao3 Notifications',
      home: FutureBuilder(
          future: context.watch<Ao3Model>().initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            return context.watch<Ao3Model>().username == null
                ? const AuthPage()
                : const HomePage();
          }),
      theme: AppTheme.light.copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 153, 0, 0))),
    );
  }
}
