import 'package:doctors_appointment/core/views/footer_page.dart';
import 'package:doctors_appointment/features/home/views/components/doctors_section.dart';
import 'package:doctors_appointment/features/home/views/components/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  LandingPage(),
                  SizedBox(height: 20),
                  DoctorSection(),
                  SizedBox(height: 20),
                  FooterPage(),
                ],
              ),
            ],
          ),
        ));
  }
}
