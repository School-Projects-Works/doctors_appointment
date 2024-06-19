import 'package:doctors_appointment/features/main/views/components/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerWidget {
  const MainPage(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: NavBar()
      ),
      body: child,
    ));
  }
}