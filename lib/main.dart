import 'package:flutter/material.dart';
import 'package:itc_community/my_app.dart';
import 'package:itc_community/data/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initSharedPreference();

  runApp(const MyApp());
}
