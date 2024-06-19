import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/core/views/footer_page.dart';
import 'package:doctors_appointment/features/contact/state/provider.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: styles.smallerThanTablet ? 10 : 20,
                        vertical: styles.smallerThanTablet ? 10 : 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Contact Us',
                              style: styles.title(color: primaryColor)),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5))
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.email,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('das@aamusted.com',
                                              style: styles.body(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('+233 123 456 7890',
                                              style: styles.body(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.chat,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('+233 123 456 7890',
                                              style: styles.body(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(width: 20),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5))
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('123, Kumasi, Ghana',
                                              style: styles.body(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.add_box,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('P.O. Box 123',
                                              style: styles.body(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_city,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('Tanoso Kumasi, Ghana',
                                              style: styles.body(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          const SizedBox(height: 20),
                          //contact form
                          Container(
                            width: styles.isMobile ? double.infinity : 650,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(.5))),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextFields(
                                      hintText: 'Enter your name',
                                      validator: (name){
                                        if(name==null ||name.isEmpty){
                                          return 'Name cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        ref.read(newMessageProvider.notifier).setName(value);
                                      },
                                      label: 'Name',
                                      prefixIcon: Icons.person),
                                  const SizedBox(height: 25),
                                  CustomTextFields(
                                      hintText: 'Enter your email',
                                      validator: (email){
                                        if(email==null ||email.isEmpty){
                                          return 'Email cannot be empty';
                                        }else if(!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(email)){
                                          return 'Invalid email';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        ref.read(newMessageProvider.notifier).setEmail(value);
                                      },
                                      label: 'Email',
                                      prefixIcon: Icons.email),
                                  const SizedBox(height: 25),
                                  CustomTextFields(
                                      hintText: 'Enter your message',
                                      validator: (message){
                                        if(message==null ||message.isEmpty){
                                          return 'Message cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        ref.read(newMessageProvider.notifier).setMessage(value);
                                      },
                                      label: 'Message',
                                      prefixIcon: Icons.message,
                                      maxLines: 5),
                                  const SizedBox(height: 25),
                                  CustomButton(
                                    text: 'Send Message',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        ref.read(newMessageProvider.notifier).sendMessage(ref:ref,form:_formKey);
                                      }
                                    },
                                    color: secondaryColor,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ))),
            const FooterPage()
          ],
        ));
  }
}
