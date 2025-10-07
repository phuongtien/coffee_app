// app.dart - App configuration
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee & Billboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.home,
      routes: Routes.getRoutes(),
    );
  }
}