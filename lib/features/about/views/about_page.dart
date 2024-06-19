import 'package:doctors_appointment/core/views/footer_page.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                width: styles.isMobile ? double.infinity : styles.width * 0.6,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          Assets.imagesLogoWhite,
                          width: styles.width * 0.3,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About Us',
                                  style: styles.title(
                                      color: primaryColor, desktop: 30)),
                              const SizedBox(height: 20),
                              Markdown(
                                  shrinkWrap: true,
                                  selectable: true,
                                  data:
                                      "HealthHub is a revolutionary web and mobile application designed to transform the healthcare experience by streamlining the process of scheduling and managing medical appointments. Our platform serves as a bridge between patients and healthcare providers, offering a user-friendly, efficient, and secure environment for all your healthcare needs.At HealthHub, we understand the complexities and challenges of managing healthcare appointments.",
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                        color: Colors.black,
                                        height: 2,
                                        fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    //markdown
                    FutureBuilder(
                        future: getAboutFile(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('Error loading about page');
                          }
                          return Markdown(
                            shrinkWrap: true,
                            selectable: true,
                            data: snapshot.data!,
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              h1: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              h2: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              h3: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              h4: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500),
                              h5: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        })
                  ],
                ),
              ),
            )),
            const FooterPage()
          ],
        ));
  }

  Future<String> getAboutFile() async {
    return await rootBundle.loadString(Assets.docsAbout);
  }
}
