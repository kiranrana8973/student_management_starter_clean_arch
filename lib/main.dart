import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_management_starter/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await HiveService().init();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
