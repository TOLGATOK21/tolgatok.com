import 'package:flutter/material.dart';
import 'package:flutter_web/screens/desktop/desktop_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'macOS Desktop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DesktopScreen(),
    );
  }
}
