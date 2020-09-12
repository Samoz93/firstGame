import 'package:firebase_core/firebase_core.dart';
import 'package:firstgame/Base/Locator.dart';
import 'package:firstgame/Screens/MainPage.dart';
import 'package:firstgame/Services/AuthProvider.dart';
import 'package:firstgame/Widget/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  runApp(MyApp());
}

final auth = AuthProvider();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ViewModelBuilder<AuthProvider>.reactive(
        builder: (ctx, model, ch) =>
            model.isBusy ? LoadingWidget() : MainPage(),
        viewModelBuilder: () => Get.find<AuthProvider>(),
        onModelReady: (v) => v.signIn(),
      ),
    );
  }
}
