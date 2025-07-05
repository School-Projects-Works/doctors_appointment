import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/core/constatnts/doctor_specialty.dart';
import 'package:doctors_appointment/core/constatnts/regions.dart';
import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/core/views/custom_drop_down.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/core/views/footer_page.dart';
import 'package:doctors_appointment/features/auth/pages/register/state/registration_provider.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/routes/router_item.dart';
import '../../../../../utils/styles.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
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
                                  fit: BoxFit.fill))),
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
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: styles.isMobile ? styles.width : 500,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.1),
                                          blurRadius: 10,
                                          spreadRadius: 5)
                                    ]),
                                child: () {
                                  if (ref.watch(regPagesProvider) == 0) {
                                    return buildUserInit();
                                  } else if (ref.watch(regPagesProvider) == 1) {
                                    return buildAddressSection();
                                  } else {
                                    if (ref
                                            .watch(userRegistrationProvider)
                                            .userRole ==
                                        'Doctor') {
                                      return buildDoctorMetaData();
                                    } else {
                                      return buildPatientMetaData();
                                    }
                                  }
                                  //return buildPatientMetaData();
                                }()))),
                  ],
                )
              ],
            )),
            const FooterPage(),
          ],
        ));
  }

  Widget buildUserInit() {
    var provider = ref.watch(userRegistrationProvider);
    var notifier = ref.read(userRegistrationProvider.notifier);
    var styles = Styles(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('User Registration',
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
              Row(
                children: [
                  Radio<String>(
                      value: 'Patient',
                      activeColor: primaryColor,
                      groupValue: provider.userRole,

                      // fillColor: WidgetStateProperty.all(
                      //     primaryColor),
                      onChanged: (value) {
                        notifier.setUserRole(value);
                      }),
                  const Text('I am a patient'),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Radio<String>(
                      value: 'Doctor',
                      activeColor: primaryColor,
                      groupValue: provider.userRole,
                      onChanged: (value) {
                        notifier.setUserRole(value);
                      }),
                  const Text('I am a doctor'),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Full Name',
                prefixIcon: Icons.person,
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                onSaved: (name) {
                  notifier.setName(name!);
                },
              ),
              const SizedBox(height: 20),
              CustomDropDown(
                  items: ['Male', 'Female']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  label: 'Gender',
                  prefixIcon: Icons.male,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'User gender is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    notifier.setGender(value);
                  }),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Email',
                prefixIcon: Icons.email,
                onSaved: (email) {
                  notifier.setEmail(email!);
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
                label: 'Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                isDigitOnly: true,
                validator: (phone) {
                  if (phone == null || phone.isEmpty) {
                    return 'Phone number is required';
                  } else if (phone.length != 10) {
                    return 'Phone number must be exactly 10 characters';
                  }
                  return null;
                },
                onSaved: (phone) {
                  notifier.setPhone(phone!);
                },
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Password',
                prefixIcon: Icons.lock,
                obscureText: obsecureText,
                suffixIcon: IconButton(
                    icon: Icon(
                        obsecureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obsecureText = !obsecureText;
                      });
                    }),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Password is required';
                  } else if (password.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (password) {
                  notifier.setPassword(password!);
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (provider.userRole == null) {
                      CustomDialogs.toast(
                        message: 'Select user role',
                        type: DialogType.error,
                      );
                    } else {
                      _formKey.currentState!.save();
                      notifier.moveToAddress(ref: ref);
                    }
                  }
                },
                radius: 5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        MyRouter(ref: ref, context: context)
                            .navigateToRoute(RouterItem.loginRoute);
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final _formKeyForAddress = GlobalKey<FormState>();
  Widget buildAddressSection() {
    var notifier = ref.read(regAddressProvider.notifier);
    var styles = Styles(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKeyForAddress,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ref.read(regPagesProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text('User Registration',
                        textAlign: TextAlign.center,
                        style: styles.body(
                            desktop: 22,
                            mobile: 20,
                            tablet: 21,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Address Line 1',
                prefixIcon: Icons.location_on,
                validator: (address) {
                  if (address == null || address.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
                onSaved: (address) {
                  notifier.setAddress(address!);
                },
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'City',
                prefixIcon: Icons.location_city,
                validator: (city) {
                  if (city == null || city.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
                onSaved: (p0) => notifier.setCity(p0!),
              ),
              const SizedBox(height: 20),
              CustomDropDown(
                label: 'Region/State',
                items: regionsInGhana
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                prefixIcon: Icons.location_city,
                onChanged: (state) {
                  notifier.setRegion(state);
                },
                validator: (state) {
                  if (state == null || state.isEmpty) {
                    return 'Region is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (_formKeyForAddress.currentState!.validate()) {
                    _formKeyForAddress.currentState!.save();
                    notifier.moveToMetaData(ref: ref);
                  }
                },
                radius: 5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        MyRouter(ref: ref, context: context)
                            .navigateToRoute(RouterItem.loginRoute);
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final _formKeyForPatient = GlobalKey<FormState>();

  Widget buildPatientMetaData() {
    var styles = Styles(context);
    var provider = ref.watch(regPatientMetaDataProvider);
    var notifier = ref.read(regPatientMetaDataProvider.notifier);
    return SingleChildScrollView(
        child: Form(
            key: _formKeyForPatient,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            ref.read(regPagesProvider.notifier).state = 1;
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text('User Registration',
                            textAlign: TextAlign.center,
                            style: styles.body(
                                desktop: 22,
                                mobile: 20,
                                tablet: 21,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      ),
                    ],
                  ),

                  const Divider(
                    thickness: 2,
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  //date of birth
                  CustomTextFields(
                    label: 'Date of Birth',
                    prefixIcon: Icons.calendar_today,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
                          if (date != null) {
                            notifier.setDateOfBirth(date);
                          }
                        }),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year - 18),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(DateTime.now().year - 18));
                      if (date != null) {
                        notifier.setDateOfBirth(date);
                      }
                    },
                    validator: (date) {
                      if (date == null || date.isEmpty) {
                        return 'Date of birth is required';
                      }
                      return null;
                    },
                    controller:
                        TextEditingController(text: provider.patientDOB ?? ''),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    label: 'Occupation',
                    prefixIcon: Icons.work,
                    validator: (occupation) {
                      if (occupation == null || occupation.isEmpty) {
                        return 'Occupation is required';
                      }
                      return null;
                    },
                    onSaved: (occupation) {
                      notifier.setOccupation(occupation!);
                    },
                  ),
                  const SizedBox(height: 20),
                  //BLOOD GROUP dropdown
                  CustomDropDown(
                    label: 'Blood Group',
                    items: bloodGroups
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    prefixIcon: Icons.bloodtype,
                    onChanged: (value) {
                      notifier.setBloodGroup(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Blood group is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //weight and height in a row
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextFields(
                        label: 'Weight (kg)',
                        prefixIcon: Icons.line_weight,
                        keyboardType: TextInputType.number,
                        isDigitOnly: true,
                        validator: (weight) {
                          if (weight == null || weight.isEmpty) {
                            return 'Weight is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          notifier.setWeight(value!);
                        },
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: CustomTextFields(
                        label: 'Height (cm)',
                        prefixIcon: Icons.height,
                        keyboardType: TextInputType.number,
                        isDigitOnly: true,
                        validator: (height) {
                          if (height == null || height.isEmpty) {
                            return 'Height is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          notifier.setHeight(value!);
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (_formKeyForPatient.currentState!.validate()) {
                        _formKeyForPatient.currentState!.save();
                        notifier.registerUser(
                            ref: ref,
                            form: _formKeyForPatient,
                            context: context);
                      }
                    },
                    radius: 5,
                  ),
                ]))));
  }

  final _formKeyForDoctor = GlobalKey<FormState>();
  Widget buildDoctorMetaData() {
    var styles = Styles(context);

    var notifier = ref.read(regDoctorMetaDataProvider.notifier);
    return SingleChildScrollView(
        child: Form(
            key: _formKeyForDoctor,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            ref.read(regPagesProvider.notifier).state = 1;
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text('User Registration',
                            textAlign: TextAlign.center,
                            style: styles.body(
                                desktop: 22,
                                mobile: 20,
                                tablet: 21,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      ),
                    ],
                  ),

                  const Divider(
                    thickness: 2,
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  //doctor speciality dropdown
                  CustomDropDown(
                    label: 'Speciality',
                    items: specialties
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    prefixIcon: Icons.medical_services,
                    onChanged: (value) {
                      notifier.setSpeciality(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Speciality is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //years of experience
                  CustomTextFields(
                    label: 'Years of Experience',
                    prefixIcon: Icons.work,
                    keyboardType: TextInputType.number,
                    isDigitOnly: true,
                    max: 2,
                    validator: (experience) {
                      if (experience == null || experience.isEmpty) {
                        return 'Experience is required';
                      }
                      return null;
                    },
                    onSaved: (experience) {
                      notifier.setExperience(experience!);
                    },
                  ),
                  const SizedBox(height: 20),
                  //hospital name
                  CustomTextFields(
                    label: 'Hospital Name',
                    prefixIcon: Icons.local_hospital,
                    validator: (hospital) {
                      if (hospital == null || hospital.isEmpty) {
                        return 'Hospital name is required';
                      }
                      return null;
                    },
                    onSaved: (hospital) {
                      notifier.setHospital(hospital!);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (_formKeyForDoctor.currentState!.validate()) {
                        _formKeyForDoctor.currentState!.save();
                        notifier.registerUser(
                            ref: ref,
                            form: _formKeyForDoctor,
                            context: context);
                      }
                    },
                    radius: 5,
                  ),
                ]))));
  }
}
