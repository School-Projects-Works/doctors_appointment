import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  List<Map<String, String>> data = [
    {
      'image': Assets.imagesSlide1,
      'title': 'Create an Accout',
      'description':
          'Create an account as a patient or a doctor to get started. Every User will be verified by the admin before they can use the app'
    },
    {
      'image': Assets.imagesSlide2,
      'title': 'Book an appointment',
      'description':
          'Book an appointment with a doctor of your choice. You can also book an appointment for someone else. Doctors will be able to see your appointment and accept or reject it. You will be notified of the status of your appointment. You can also cancel the appointment if you want to.'
    },
    {
      'image': Assets.imagesSlide3,
      'title': 'Get a prescription',
      'description':
          'Get a prescription from the doctor after your appointment. You can also get a prescription for someone else. The prescription will be available for you to download and print. You can also view the prescription at any time in the app.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    return CarouselSlider(
      options: CarouselOptions(
          height: styles.height * 0.6,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal),
      items: data.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: styles.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(i['image']!), fit: BoxFit.cover),
                  color: Colors.amber),
              child: Container(
                  width: styles.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: styles.height * 0.6,
                  color: Colors.black.withOpacity(0.1),
                  child: SizedBox(
                    width: styles.isMobile
                        ? styles.width * 0.8
                        : styles.width * 0.4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          i['title']!,
                          style: styles.title(
                              color: Colors.white,
                              mobile: 45,
                              desktop: 60,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          i['description']!,
                          style: styles.body(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )),
            );
          },
        );
      }).toList(),
    );
  }
}
