import 'package:firebase_core/firebase_core.dart';
import 'package:firstgame/Services/AuthProvider.dart';
import 'package:firstgame/Services/Get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'Screens/GamePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupSingletons();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final auth = AuthProvider();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => auth..signIn(),
      builder: (context, child) => GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: GamePage(),
      ),
    );
  }
}
