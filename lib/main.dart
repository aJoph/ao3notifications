import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/apptheme.dart';
import 'package:ao3notifications/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  Hive.initFlutter();
  runApp(const Ao3App());
}

class Ao3App extends StatelessWidget {
  const Ao3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ao3 Notifications',
      home: ChangeNotifierProvider(
        create: (context) => Ao3Model(),
        child: const HomePage(),
      ),
      theme: AppTheme.light,
    );
  }
}
