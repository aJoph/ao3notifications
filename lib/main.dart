import 'dart:isolate';

import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/apptheme.dart';
import 'package:ao3notifications/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const Ao3App());
}

class Ao3App extends StatelessWidget {
  const Ao3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Ao3Model(),
      child: MaterialApp(
        title: 'Ao3 Notifications',
        home: Consumer<Ao3Model>(
          builder: (context, model, child) => FutureBuilder(
              future: model.init(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occured',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }

                return const HomePage();
              }),
        ),
        theme: AppTheme.light,
      ),
    );
  }
}
