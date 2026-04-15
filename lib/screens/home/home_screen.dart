import 'package:flutter/material.dart';
import 'package:flutter_web/widgets/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web'),
      ),
      body: const ResponsiveLayout(
        mobile: _MobileBody(),
        tablet: _TabletBody(),
        desktop: _DesktopBody(),
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  const _MobileBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hoş Geldiniz - Mobil'),
    );
  }
}

class _TabletBody extends StatelessWidget {
  const _TabletBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hoş Geldiniz - Tablet'),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  const _DesktopBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hoş Geldiniz - Masaüstü'),
    );
  }
}
