import 'package:doctors_appointment/core/constatnts/doctor_specialty.dart';
import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/core/views/custom_drop_down.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.watch(userProvider);
      ref.read(udateUserProvider.notifier).setUser(user);
    });

    return Container(
        color: Colors.white,
        width: double.infinity,
        height: styles.height,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'User Profile'.toUpperCase(),
                style: styles.title(
                    fontFamily: 'Raleway', desktop: 20, color: primaryColor),
              ),
              const Divider(
                height: 20,
                thickness: 5,
                color: primaryColor,
              ),
              SizedBox(
                width: styles.width >= 700
                    ? 650
                    : styles.width >= 900
                        ? 800
                        : styles.isMobile
                            ? styles.width
                            : 1000,
                child: (styles.width >= 700) ? buildLarge() : buildSmall(),
              ),
            ],
          ),
        ));
  }

  Widget buildLarge() {
    var user = ref.watch(userProvider);
    var notifier = ref.read(udateUserProvider.notifier);
    var styles = Styles(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                        image: user.userImage != null ||
                                ref.watch(selectedUserImageProvider) != null
                            ? DecorationImage(
                                image: ref.watch(selectedUserImageProvider) !=
                                        null
                                    ? MemoryImage(
                                        ref.watch(selectedUserImageProvider)!)
                                    : user.userImage != null
                                        ? NetworkImage(user.userImage!)
                                        : const AssetImage(Assets.imagesAdmin),
                                fit: BoxFit.cover)
                            : null),
                    child: user.userImage == null &&
                            ref.watch(selectedUserImageProvider) == null
                        ? const Icon(
                            Icons.person,
                            size: 100,
                          )
                        : null,
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                      onPressed: () {
                        notifier.changeImage(ref);
                      },
                      child: const Text('Change Image')),
                  const SizedBox(height: 20),
                  if (user.userRole == 'Doctor')
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: 220,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(5),
                        // active and inactive status
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Doctor Status',
                            style: styles.body(),
                          ),
                          subtitle: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  notifier.changeStatus(
                                      ref.watch(selectedUserImageProvider) !=
                                          null,
                                      'Active');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: ref
                                                      .watch(udateUserProvider)
                                                      .userStatus !=
                                                  null &&
                                              ref
                                                      .watch(udateUserProvider)
                                                      .userStatus!
                                                      .toLowerCase() ==
                                                  'active'
                                          ? Border.all(
                                              color: Colors.green, width: 1)
                                          : null),
                                  child: Text(
                                    'Active',
                                    style: styles.body(
                                        color: Colors.green,
                                        desktop: 14,
                                        mobile: 12,
                                        tablet: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  notifier.changeStatus(
                                      ref.watch(selectedUserImageProvider) !=
                                          null,
                                      'Inactive');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: ref
                                                      .watch(udateUserProvider)
                                                      .userStatus !=
                                                  null &&
                                              ref
                                                      .watch(udateUserProvider)
                                                      .userStatus!
                                                      .toLowerCase() ==
                                                  'inactive'
                                          ? Border.all(
                                              color: Colors.red, width: 1)
                                          : null),
                                  child: Text(
                                    'Inactive',
                                    style: styles.body(
                                        color: Colors.red,
                                        desktop: 14,
                                        mobile: 12,
                                        tablet: 13),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'User Name',
                          style: styles.body(),
                        ),
                        subtitle: CustomTextFields(
                          hintText: 'Name',
                          controller:
                              TextEditingController(text: user.userName),
                          validator: (name) {
                            if (name == null || name.length < 2) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            notifier.setName(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        title: Text(
                          'User Email',
                          style: styles.body(),
                        ),
                        subtitle: CustomTextFields(
                          controller: TextEditingController(text: user.email),
                          isReadOnly: true,
                          onChanged: (email) {
                            notifier.setEmail(email);
                          },
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                          title: Text('User Gender', style: styles.body()),
                          subtitle: CustomDropDown(
                            value: user.userGender,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gender is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setGender(value);
                            },
                            items: ['Male', 'Female']
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          )),
                      const SizedBox(height: 5),
                      if (user.userRole == 'Doctor')
                        ListTile(
                            title: Text('Specialization', style: styles.body()),
                            subtitle: CustomDropDown(
                              value:
                                  user.userMetaData!['doctorSpeciality'] ?? '',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Specialization is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                notifier.setSpecialization(value);
                              },
                              items: specialties
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                            )),
                      const SizedBox(height: 5),
                      //years of experience
                      if (user.userRole == 'Doctor')
                        ListTile(
                          title:
                              Text('Years of Experience', style: styles.body()),
                          subtitle: CustomTextFields(
                            hintText: 'Years of Experience',
                            isDigitOnly: true,
                            controller: TextEditingController(
                                text: user.userMetaData!['doctorExperience'] ??
                                    ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Years of Experience is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setYearOfExperience(value);
                            },
                          ),
                        ),
                      const SizedBox(height: 5),
                      //doctor hospital
                      if (user.userRole == 'Doctor')
                        ListTile(
                          title: Text('Hospital', style: styles.body()),
                          subtitle: CustomTextFields(
                            hintText: 'Hospital',
                            controller: TextEditingController(
                                text: user.userMetaData!['hospitalName'] ?? ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Hospital is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setHospital(value);
                            },
                          ),
                        ),

                      //for patient add blood group, weight and height
                      if (user.userRole == 'Patient')
                        ListTile(
                          title: Text('Blood Group', style: styles.body()),
                          subtitle: CustomDropDown(
                            value:
                                user.userMetaData!['patientBloodGroup'] ?? '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Blood Group is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setBloodGroup(value);
                            },
                            items: bloodGroups
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 5),
                      if (user.userRole == 'Patient')
                        ListTile(
                          title: Text('Weight', style: styles.body()),
                          subtitle: CustomTextFields(
                            hintText: 'Weight',
                            isDigitOnly: true,
                            controller: TextEditingController(
                                text:
                                    user.userMetaData!['patientWeight'] ?? ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Weight is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setWeight(value);
                            },
                          ),
                        ),
                      const SizedBox(height: 5),
                      if (user.userRole == 'Patient')
                        ListTile(
                          title: Text('Height', style: styles.body()),
                          subtitle: CustomTextFields(
                            hintText: 'Height',
                            isDigitOnly: true,
                            controller: TextEditingController(
                                text:
                                    user.userMetaData!['patientHeight'] ?? ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Height is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setHeight(value);
                            },
                          ),
                        ),
                    ]),
              )
            ],
          ),
          const SizedBox(height: 5),
          CustomButton(
              text: 'Update Profile',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // _formKey.currentState!.save();

                  CustomDialogs.showDialog(
                      message: 'Are you sure you want to update your profile?',
                      secondBtnText: 'Update',
                      onConfirm: () {
                        notifier.updateUser(context: context, ref: ref);
                      });
                }
              })
        ],
      ),
    );
  }

  Widget buildSmall() {
    var user = ref.watch(userProvider);
    var notifier = ref.read(udateUserProvider.notifier);
    var styles = Styles(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1),
                image: user.userImage != null ||
                        ref.watch(selectedUserImageProvider) != null
                    ? DecorationImage(
                        image: ref.watch(selectedUserImageProvider) != null
                            ? MemoryImage(ref.watch(selectedUserImageProvider)!)
                            : user.userImage != null
                                ? NetworkImage(user.userImage!)
                                : const AssetImage(Assets.imagesAdmin),
                        fit: BoxFit.cover)
                    : null),
            child: user.userImage == null &&
                    ref.watch(selectedUserImageProvider) == null
                ? const Icon(
                    Icons.person,
                    size: 100,
                  )
                : null,
          ),
          const SizedBox(height: 5),
          TextButton(
              onPressed: () {
                notifier.changeImage(ref);
              },
              child: const Text('Change Image')),
          const SizedBox(height: 20),
          if (user.userRole == 'Doctor')
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5),
                // active and inactive status
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Doctor Status',
                    style: styles.body(),
                  ),
                  subtitle: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          notifier.changeStatus(
                              ref.watch(selectedUserImageProvider) != null,
                              'Active');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: ref.watch(udateUserProvider).userStatus !=
                                          null &&
                                      ref
                                              .watch(udateUserProvider)
                                              .userStatus!
                                              .toLowerCase() ==
                                          'active'
                                  ? Border.all(color: Colors.green, width: 1)
                                  : null),
                          child: Text(
                            'Active',
                            style: styles.body(
                                color: Colors.green,
                                desktop: 14,
                                mobile: 12,
                                tablet: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          notifier.changeStatus(
                              ref.watch(selectedUserImageProvider) != null,
                              'Inactive');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: ref.watch(udateUserProvider).userStatus !=
                                          null &&
                                      ref
                                              .watch(udateUserProvider)
                                              .userStatus!
                                              .toLowerCase() ==
                                          'inactive'
                                  ? Border.all(color: Colors.red, width: 1)
                                  : null),
                          child: Text(
                            'Inactive',
                            style: styles.body(
                                color: Colors.red,
                                desktop: 14,
                                mobile: 12,
                                tablet: 13),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ListTile(
            title: Text(
              'User Name',
              style: styles.body(),
            ),
            subtitle: CustomTextFields(
              hintText: 'Name',
              controller: TextEditingController(text: user.userName),
              validator: (name) {
                if (name == null || name.length < 2) {
                  return 'Name is required';
                }
                return null;
              },
              onChanged: (value) {
                notifier.setName(value);
              },
            ),
          ),
          const SizedBox(height: 5),
          ListTile(
            title: Text(
              'User Email',
              style: styles.body(),
            ),
            subtitle: CustomTextFields(
              controller: TextEditingController(text: user.email),
              isReadOnly: true,
              onChanged: (email) {
                notifier.setEmail(email);
              },
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 5),
          ListTile(
              title: Text('User Gender', style: styles.body()),
              subtitle: CustomDropDown(
                value: user.userGender,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setGender(value);
                },
                items: ['Male', 'Female']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              )),
          const SizedBox(height: 5),
          if (user.userRole == 'Doctor')
            ListTile(
                title: Text('Specialization', style: styles.body()),
                subtitle: CustomDropDown(
                  value: user.userMetaData!['doctorSpeciality'] ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Specialization is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    notifier.setSpecialization(value);
                  },
                  items: specialties
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                )),
          const SizedBox(height: 5),
          //years of experience
          if (user.userRole == 'Doctor')
            ListTile(
              title: Text('Years of Experience', style: styles.body()),
              subtitle: CustomTextFields(
                hintText: 'Years of Experience',
                isDigitOnly: true,
                controller: TextEditingController(
                    text: user.userMetaData!['doctorExperience'] ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Years of Experience is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setYearOfExperience(value);
                },
              ),
            ),
          const SizedBox(height: 5),
          //doctor hospital
          if (user.userRole == 'Doctor')
            ListTile(
              title: Text('Hospital', style: styles.body()),
              subtitle: CustomTextFields(
                hintText: 'Hospital',
                controller: TextEditingController(
                    text: user.userMetaData!['hospitalName'] ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hospital is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setHospital(value);
                },
              ),
            ),

          //for patient add blood group, weight and height
          if (user.userRole == 'Patient')
            ListTile(
              title: Text('Blood Group', style: styles.body()),
              subtitle: CustomDropDown(
                value: user.userMetaData!['patientBloodGroup'] ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Blood Group is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setBloodGroup(value);
                },
                items: bloodGroups
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
            ),
          const SizedBox(height: 5),
          if (user.userRole == 'Patient')
            ListTile(
              title: Text('Weight', style: styles.body()),
              subtitle: CustomTextFields(
                hintText: 'Weight',
                isDigitOnly: true,
                controller: TextEditingController(
                    text: user.userMetaData!['patientWeight'] ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Weight is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setWeight(value);
                },
              ),
            ),
          const SizedBox(height: 5),
          if (user.userRole == 'Patient')
            ListTile(
              title: Text('Height', style: styles.body()),
              subtitle: CustomTextFields(
                hintText: 'Height',
                isDigitOnly: true,
                controller: TextEditingController(
                    text: user.userMetaData!['patientHeight'] ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Height is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setHeight(value);
                },
              ),
            ),

          const SizedBox(height: 5),
          CustomButton(
              text: 'Update Profile',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  CustomDialogs.showDialog(
                      message: 'Are you sure you want to update your profile?',
                      secondBtnText: 'Update',
                      onConfirm: () {
                        notifier.updateUser(context: context, ref: ref);
                      });
                }
              })
        ],
      ),
    );
  }
}
