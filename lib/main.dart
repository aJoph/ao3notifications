import 'package:ao3notifications/ao3_model.dart';
import 'package:ao3notifications/apptheme.dart';
import 'package:ao3notifications/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Ao3Model.init();
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
        home: const HomePage(),
        theme: AppTheme.light,
      ),
    );
  }
}
