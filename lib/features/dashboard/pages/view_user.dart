import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/dashboard/state/main_provider.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewUser extends ConsumerWidget {
  const ViewUser({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);

    return SizedBox(
      width: styles.width,
      height: styles.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: styles.width < 700
                  ? styles.width * .95
                  : styles.width >= 700 && styles.width <= 1500
                      ? styles.width * .9
                      : styles.width * 0.6,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(width: 10),
                      Text(
                        'USER DETAILS',
                        style: styles.title(
                            color: primaryColor,
                            mobile: 20,
                            desktop: 25,
                            tablet: 22),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 3,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 20),
                  // styles.width <= 700
                  //     ? buildSmallScreen(context, styles, ref)
                  //     : buildLargeScreen(context, styles, ref)
                  Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 10,
                      children: [
                        imageBuilder(styles, user),
                        buildUserDetails(styles, user),
                        buildOtherDetails(styles, user, ref)
                      ]),
                  if (user.userRole!.toLowerCase() == 'doctor')
                    buildReview(styles, user, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReview(Styles styles, UserModel user, WidgetRef ref) {
    var reviews = ref
        .watch(reviewsProvider)
        .where((element) => element.doctorId == user.id)
        .toList();
    return Column(
      children: [
        Text('Reviews', style: styles.title(color: primaryColor)),
        const SizedBox(height: 10),
        if (reviews.isNotEmpty)
          for (var review in reviews)
            ListTile(
              title: Text(
                review.userName,
                style: styles.body(
                    color: primaryColor, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                review.review,
                style: styles.body(color: Colors.grey),
              ),
            )
      ],
    );
  }

  Widget imageBuilder(Styles styles, UserModel user) {
    return Container(
      width: 200,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: user.userImage != null
            ? DecorationImage(
                image: NetworkImage(user.userImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: user.userImage == null
          ? Image.asset(user.userGender == 'Male'
              ? Assets.imagesMale
              : Assets.imagesFemale)
          : null,
    );
  }

  Widget buildUserDetails(Styles styles, UserModel user) {
    UserAddressModel? address = user.userAddress != null
        ? UserAddressModel.fromMap(user.userAddress!)
        : null;
    var lableStyle =
        styles.body(color: Colors.grey, mobile: 14, desktop: 14, tablet: 14);
    var infoStyle = styles.body(
        color: primaryColor,
        fontFamily: 'Raleway',
        desktop: 16,
        tablet: 15,
        mobile: 14,
        fontWeight: FontWeight.w500);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Full Name: ', style: lableStyle),
              const SizedBox(width: 5),
              Expanded(
                child: Text(user.userName ?? '', style: infoStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Email: ', style: lableStyle),
              const SizedBox(width: 5),
              Expanded(
                child: Text(user.email ?? '', style: infoStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Phone: ', style: lableStyle),
              const SizedBox(width: 5),
              Expanded(
                child: Text(user.userPhone ?? '', style: infoStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          //address
          if (address != null) Text('Address: ', style: infoStyle),
          if (address != null)
            Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Column(children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          address.address ?? '',
                          style: infoStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          address.city ?? '',
                          style: infoStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        address.region ?? '',
                        style: infoStyle,
                      ),
                    ],
                  ),
                ])),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildOtherDetails(Styles styles, UserModel user, WidgetRef ref) {
    DoctorMetaData? doctorMetaData = user.userRole!.toLowerCase() == 'doctor'
        ? DoctorMetaData.fromMap(user.userMetaData!)
        : null;
    PatientMetaData? patientMetaData = user.userRole!.toLowerCase() != 'doctor'
        ? PatientMetaData.fromMap(user.userMetaData!)
        : null;
    var rating = ref.read(reviewsProvider.notifier).getRating(user.id!);
    var lableStyle =
        styles.body(color: Colors.grey, mobile: 14, desktop: 14, tablet: 14);
    var infoStyle = styles.body(
        color: primaryColor,
        fontFamily: 'Raleway',
        desktop: 16,
        tablet: 15,
        mobile: 14,
        fontWeight: FontWeight.w500);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 320,
      child: doctorMetaData != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Specialization: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        doctorMetaData.doctorSpeciality ?? '',
                        style: infoStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Experience: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${doctorMetaData.doctorExperience} Years',
                      style: infoStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //hospital
                Row(
                  children: [
                    Text(
                      'Hospital: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        doctorMetaData.hospitalName ?? '',
                        style: infoStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //rating
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        Icons.star,
                        color: i < rating
                            ? Colors.amber
                            : Colors.grey.withOpacity(0.5),
                      ),
                    const SizedBox(width: 5),
                    Text(
                      rating.toStringAsFixed(1),
                      style: infoStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: user.userStatus!.toLowerCase() == 'active'
                          ? Colors.green
                          : user.userStatus!.toLowerCase() == 'inactive'
                              ? Colors.grey
                              : Colors.red),
                  child: Text(
                    user.userStatus ?? '',
                    style: styles.body(color: Colors.white),
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Occupation: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        patientMetaData!.occupation ?? '',
                        style: infoStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Date Of Birth: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      patientMetaData.patientDOB ?? '',
                      style: infoStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Blood Group: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      patientMetaData.patientBloodGroup ?? '',
                      style: infoStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Weight: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${patientMetaData.patientWeight}Kg',
                      style: infoStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Height: ',
                      style: lableStyle,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${patientMetaData.patientHeight}Cm',
                      style: infoStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: user.userStatus!.toLowerCase() == 'active'
                          ? Colors.green
                          : user.userStatus!.toLowerCase() == 'inactive'
                              ? Colors.grey
                              : Colors.red),
                  child: Text(
                    user.userStatus ?? '',
                    style: styles.body(color: Colors.white),
                  ),
                )
              ],
            ),
    );
  }
}
