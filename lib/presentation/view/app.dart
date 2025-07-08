import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/routes/app_routes.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies Application',
      initialRoute: AppRoutes.homeScreen,
      routes: AppRoutes.routes,
    );
  }
}