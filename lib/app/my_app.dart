import 'package:e_commerce/app/app_routes.dart';
import 'package:e_commerce/presentation/screens/bottom_nav_wrapper.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomNavWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
