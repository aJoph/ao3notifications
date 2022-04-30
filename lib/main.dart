import 'package:ao3notifications/app_theme.dart';
import 'package:ao3notifications/models/ao3_model.dart';
import 'package:ao3notifications/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// TODO: Update permissions in the android manifest and Info.plist so that URLLauncher can work.
void main() {
  Ao3Model.init();
  Hive.openBox("username");
  Hive.openBox("bookmarks");
  runApp(const Ao3App());
}

class Ao3App extends StatelessWidget {
  const Ao3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ao3',
      home: ChangeNotifierProvider(
        create: (context) => Ao3Model(),
        child: const HomePage(),
      ),
      theme: AppTheme.light,
    );
  }
}
