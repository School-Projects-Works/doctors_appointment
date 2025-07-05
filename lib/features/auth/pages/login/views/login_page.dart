import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/views/footer_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Assets.imagesBack),
                                  fit: BoxFit.cover))),
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.white,
                    ))
                  ],
                ),
                // Login form
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: styles.isMobile ? styles.width : 500,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 10,
                                      spreadRadius: 5)
                                ]),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text('Login',
                                      style: styles.body(
                                          desktop: 22,
                                          mobile: 20,
                                          tablet: 21,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor)),
                                  const Divider(
                                    thickness: 2,
                                    height: 20,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextFields(
                                    hintText: 'Email',
                                    prefixIcon: Icons.email,
                                    onSaved: (email) {
                                      ref
                                          .read(loginProvider.notifier)
                                          .setEmail(email!);
                                    },
                                    validator: (email) {
                                      if (email == null || email.isEmpty) {
                                        return 'Email is required';
                                      } else if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email)) {
                                        return 'Invalid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextFields(
                                    hintText: 'Password',
                                    prefixIcon: Icons.lock,
                                    obscureText: obsecureText,
                                    onSaved: (password) {
                                      ref
                                          .read(loginProvider.notifier)
                                          .setPassword(password!);
                                    },
                                    suffixIcon: IconButton(
                                        icon: Icon(obsecureText
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            obsecureText = !obsecureText;
                                          });
                                        }),
                                    validator: (password) {
                                      if (password == null ||
                                          password.isEmpty) {
                                        return 'Password is required';
                                      } else if (password.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text('Forgot password?'))
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  CustomButton(
                                    text: 'Login',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        ref
                                            .read(loginProvider.notifier)
                                            .login(ref: ref, context: context);
                                      }
                                    },
                                    radius: 5,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Don\'t have an account?'),
                                      TextButton(
                                          onPressed: () {
                                            MyRouter(ref: ref, context: context)
                                                .navigateToRoute(
                                                    RouterItem.registerRoute);
                                          },
                                          child: const Text('Register'))
                                    ],
                                  )
                                ],
                              ),
                            ))),
                  ],
                )
              ],
            )),
            const FooterPage(),
          ],
        ));
  }
}
