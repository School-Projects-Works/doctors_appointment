import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/home/state/doctors_provider.dart';
import 'package:doctors_appointment/features/home/state/review_provider.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/data/review_model.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/generate_appointment_fee.dart'
    show generateAppointmentFee;

class ViewDoctor extends ConsumerStatefulWidget {
  const ViewDoctor({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewUserState();
}

class _ViewUserState extends ConsumerState<ViewDoctor> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var doctorStream = ref.watch(doctorsStreamProvider);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: doctorStream.when(
        data: (dat) {
          var doctor = ref
              .watch(doctorsFilterProvider)
              .items
              .where((element) => element.id == widget.userId)
              .firstOrNull;
          if (doctor == null) {
            return const Center(child: Text('Doctor not found'));
          }
          var reviewsStream = ref.watch(reviewStreamProvider(doctor.id!));
          return reviewsStream.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => styles.width > 700
                  ? _buildLargeScreen(doctor, reviews: [])
                  : _buildSmallScreen(doctor, reviews: []),
              data: (data) {
                return styles.width > 700
                    ? _buildLargeScreen(doctor, reviews: data)
                    : _buildSmallScreen(doctor, reviews: data);
              });
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildLargeScreen(UserModel user,
      {required List<ReviewModel> reviews}) {
    double appointmentFee = generateAppointmentFee(
        DoctorMetaData.fromMap(user.userMetaData!).doctorSpeciality ?? '');
    var styles = Styles(context);
    var metaData = DoctorMetaData.fromMap(user.userMetaData!);
    var address = UserAddressModel.fromMap(user.userAddress!);
    var totalRating = reviews.isNotEmpty
        ? reviews.map((e) => e.rating).reduce((a, b) => a + b)
        : 1;
    //get the average rating
    var averageRating =
        reviews.isNotEmpty ? (totalRating / reviews.length) : (totalRating / 1);
    var appointmentProvider = ref.watch(appointmentBookingProvider);
    return SizedBox(
      width: styles.width * .8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //left side
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                          image: user.userImage != null
                              ? DecorationImage(
                                  image: user.userImage != null
                                      ? NetworkImage(user.userImage!)
                                      : const AssetImage(Assets.imagesAdmin),
                                  fit: BoxFit.cover)
                              : null),
                      child: user.userImage == null
                          ? Image.asset(Assets.imagesAdmin)
                          : null,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.userName!,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 26,
                          tablet: 22,
                          mobile: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      metaData.doctorSpeciality!,
                      style: styles.title(
                          color: Colors.blue,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                    const SizedBox(height: 5),
                    //years of experience
                    Text(
                      ' ${metaData.doctorExperience} years of experience',
                      style: styles.title(
                          color: secondaryColor,
                          desktop: 16,
                          tablet: 15,
                          mobile: 13,
                          fontFamily: 'Raleway'),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: primaryColor,
                    ),
                    const SizedBox(height: 10),

                    //address
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          address.city!,
                          style: styles.title(
                              color: primaryColor,
                              desktop: 16,
                              tablet: 15,
                              mobile: 13,
                              fontFamily: 'Raleway'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    //phone number
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          user.userPhone!,
                          style: styles.title(
                              color: primaryColor,
                              desktop: 16,
                              tablet: 15,
                              mobile: 13,
                              fontFamily: 'Raleway'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    //email
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            user.email!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styles.title(
                                color: primaryColor,
                                desktop: 16,
                                tablet: 15,
                                mobile: 13,
                                fontFamily: 'Raleway'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //rating
                    Row(
                      children: [
                        for (var i = 0; i < averageRating.toInt(); i++)
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                        const SizedBox(width: 5),
                        Text(
                          '(${averageRating.toStringAsFixed(1)})',
                          style: styles.subtitle(
                              color: Colors.black,
                              desktop: 18,
                              fontFamily: 'Raleway',
                              tablet: 16,
                              mobile: 15),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    //reviews
                    const SizedBox(height: 10),
                    //book appointment
                    if (appointmentProvider != null &&
                        appointmentProvider.doctorId.isNotEmpty)
                      CustomTextFields(
                        onTap: () {
                          //pick date
                          //show date picker
                          showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 30)),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(appointmentBookingProvider.notifier)
                                  .setDate(value);
                            }
                          });
                        },
                        controller: TextEditingController(
                            text: appointmentProvider.date.isNotEmpty
                                ? appointmentProvider.date
                                : ''),
                        hintText: 'Pick Date',
                        isReadOnly: true,
                      ),
                    const SizedBox(height: 15),
                    if (appointmentProvider != null &&
                        appointmentProvider.doctorId.isNotEmpty)
                      CustomTextFields(
                        hintText: 'Pick Time',
                        onTap: () {
                          //pick time
                          //show time picker
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(appointmentBookingProvider.notifier)
                                  .setTime(value.format(context));
                            }
                          });
                        },
                        controller: TextEditingController(
                            text: appointmentProvider != null
                                ? appointmentProvider.time
                                : ''),
                        isReadOnly: true,
                      ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Appointment Fee: ',
                          style: styles.subtitle(
                              color: Colors.black,
                              desktop: 18,
                              fontFamily: 'Raleway',
                              tablet: 16,
                              mobile: 15),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'GH₵${appointmentFee.toStringAsFixed(2)}',
                          style: styles.subtitle(
                              color: Colors.cyan,
                              desktop: 18,
                              fontFamily: 'Raleway',
                              tablet: 16,
                              mobile: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      color: primaryColor,
                      onPressed: () {
                        if (ref.watch(userProvider).id != null) {
                          if (ref.watch(userProvider).id == user.id) {
                            CustomDialogs.toast(
                              message:
                                  'You can not book appointment with yourself',
                            );
                            return;
                          }
                          if (appointmentProvider == null ||
                              appointmentProvider.doctorId.isEmpty) {
                            ref
                                .read(appointmentBookingProvider.notifier)
                                .setDoctor(user);
                          } else {
                            if (appointmentProvider.date.isEmpty ||
                                appointmentProvider.time.isEmpty) {
                              CustomDialogs.toast(
                                message: 'Please select date and time',
                              );
                              return;
                            } else {
                              _bookAppointment(context, appointmentFee);
                            }
                          }
                        } else {
                          CustomDialogs.toast(
                            message: 'Please login to book appointment',
                          );
                        }
                      },
                      text: 'Proceed Make Payment',
                    )
                  ],
                ),
              ),
            ),
          ),
          //right side for reviews

          //Listview of reviews
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Reviews',
                        style: styles.title(
                            color: primaryColor,
                            desktop: 26,
                            tablet: 22,
                            mobile: 18)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          var review = reviews[index];
                          return Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    for (var i = 0; i < review.rating; i++)
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '(${review.rating.toStringAsFixed(1)})',
                                      style: styles.subtitle(
                                          color: Colors.black,
                                          desktop: 18,
                                          fontFamily: 'Raleway',
                                          tablet: 16,
                                          mobile: 15),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  review.review,
                                  style: styles.subtitle(
                                      color: Colors.black,
                                      desktop: 18,
                                      fontFamily: 'Raleway',
                                      tablet: 16,
                                      mobile: 15),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'By ${review.userName}',
                                  style: styles.subtitle(
                                      color: Colors.black,
                                      desktop: 18,
                                      fontFamily: 'Raleway',
                                      tablet: 16,
                                      mobile: 15),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
          if (styles.width > 1500) Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _buildSmallScreen(UserModel user,
      {required List<ReviewModel> reviews}) {
    var styles = Styles(context);
    double appointmentFee = generateAppointmentFee(
        DoctorMetaData.fromMap(user.userMetaData!).doctorSpeciality ?? '');
    var metaData = DoctorMetaData.fromMap(user.userMetaData!);
    var address = UserAddressModel.fromMap(user.userAddress!);
    var totalRating = reviews.isNotEmpty
        ? reviews.map((e) => e.rating).reduce((a, b) => a + b)
        : 1;
    //get the average rating
    var averageRating =
        reviews.isNotEmpty ? (totalRating / reviews.length) : (totalRating / 1);
    var appointmentProvider = ref.watch(appointmentBookingProvider);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                      image: user.userImage != null
                          ? DecorationImage(
                              image: user.userImage != null
                                  ? NetworkImage(user.userImage!)
                                  : const AssetImage(Assets.imagesAdmin),
                              fit: BoxFit.cover)
                          : null),
                  child: user.userImage == null
                      ? Image.asset(Assets.imagesAdmin)
                      : null,
                ),
                const SizedBox(height: 5),
                Text(
                  user.userName!,
                  style: styles.title(
                      color: primaryColor,
                      desktop: 26,
                      tablet: 22,
                      mobile: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  metaData.doctorSpeciality!,
                  style: styles.title(
                      color: Colors.blue,
                      desktop: 20,
                      tablet: 18,
                      mobile: 16,
                      fontFamily: 'Raleway'),
                ),
                const SizedBox(height: 5),
                //years of experience
                Text(
                  ' ${metaData.doctorExperience} years of experience',
                  style: styles.title(
                      color: secondaryColor,
                      desktop: 20,
                      tablet: 18,
                      mobile: 16,
                      fontFamily: 'Raleway'),
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: primaryColor,
                ),
                const SizedBox(height: 10),

                //address
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      address.city!,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                //phone number
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.userPhone!,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                //email
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.email!,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                //rating
                Row(
                  children: [
                    for (var i = 0; i < averageRating.toInt(); i++)
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    const SizedBox(width: 5),
                    Text(
                      '(${averageRating.toStringAsFixed(1)})',
                      style: styles.subtitle(
                          color: Colors.black,
                          desktop: 18,
                          fontFamily: 'Raleway',
                          tablet: 16,
                          mobile: 15),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    return Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              for (var i = 0; i < review.rating; i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              const SizedBox(width: 5),
                              Text(
                                '(${review.rating.toStringAsFixed(1)})',
                                style: styles.subtitle(
                                    color: Colors.black,
                                    desktop: 18,
                                    fontFamily: 'Raleway',
                                    tablet: 16,
                                    mobile: 15),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            review.review,
                            style: styles.subtitle(
                                color: Colors.black,
                                desktop: 18,
                                fontFamily: 'Raleway',
                                tablet: 16,
                                mobile: 15),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'By ${review.userName}',
                            style: styles.subtitle(
                                color: Colors.black,
                                desktop: 18,
                                fontFamily: 'Raleway',
                                tablet: 16,
                                mobile: 15),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        //book appointment
        if (appointmentProvider != null &&
            appointmentProvider.doctorId.isNotEmpty)
          CustomTextFields(
            onTap: () {
              //pick date
              //show date picker
              showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              ).then((value) {
                if (value != null) {
                  ref.read(appointmentBookingProvider.notifier).setDate(value);
                }
              });
            },
            controller: TextEditingController(
                text: appointmentProvider.date.isNotEmpty
                    ? appointmentProvider.date
                    : ''),
            hintText: 'Pick Date',
            isReadOnly: true,
          ),
        const SizedBox(height: 15),
        if (appointmentProvider != null &&
            appointmentProvider.doctorId.isNotEmpty)
          CustomTextFields(
            hintText: 'Pick Time',
            onTap: () {
              //pick time
              //show time picker
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                if (value != null) {
                  ref
                      .read(appointmentBookingProvider.notifier)
                      .setTime(value.format(context));
                }
              });
            },
            controller: TextEditingController(
                text: appointmentProvider != null
                    ? appointmentProvider.time
                    : ''),
            isReadOnly: true,
          ),

        const SizedBox(height: 2),
        //appointment fee
        Row(
          children: [
            Text(
              'Appointment Fee: ',
              style: styles.subtitle(
                  color: Colors.black,
                  desktop: 18,
                  fontFamily: 'Raleway',
                  tablet: 16,
                  mobile: 15),
            ),
            const SizedBox(width: 5),
            Text(
              'GH₵${appointmentFee.toStringAsFixed(2)}',
              style: styles.subtitle(
                  color: Colors.black,
                  desktop: 18,
                  fontFamily: 'Raleway',
                  tablet: 16,
                  mobile: 15),
            ),
          ],
        ),
        const SizedBox(height: 15),
        CustomButton(
          color: primaryColor,
          onPressed: () {
            if (ref.watch(userProvider).id != null) {
              if (ref.watch(userProvider).id == user.id) {
                CustomDialogs.toast(
                  message: 'You can not book appointment with yourself',
                );
                return;
              }
              if (appointmentProvider == null ||
                  appointmentProvider.doctorId.isEmpty) {
                ref.read(appointmentBookingProvider.notifier).setDoctor(user);
              } else {
                if (appointmentProvider.date.isEmpty ||
                    appointmentProvider.time.isEmpty) {
                  CustomDialogs.toast(
                    message: 'Please select date and time',
                  );
                  return;
                } else {
                  _bookAppointment(context, appointmentFee);
                }
              }
            } else {
              CustomDialogs.toast(
                message: 'Please login to book appointment',
              );
            }
          },
          text: 'Proceed Make Payment',
        )
      ],
    );
  }

  void _bookAppointment(BuildContext context, double amount) async {
    await FlutterPaystackPlus.openPaystackPopup(
      publicKey: 'pk_test_f065c28fb056e6cc0d1760a4e9b350b5377634e2',
      customerEmail: ref.watch(userProvider).email ?? 'user@doc-app.com',
      context: context,
      secretKey: 'sk_test_422a72101187d3e0229adc06b4e8d9ece30c6d36',
      plan: '-Your-plan-configured-from-your-dashboard-',
      amount: (amount).toString(),
      reference: DateTime.now().millisecondsSinceEpoch.toString(),
      currency: 'GHS',
      callBackUrl: "example.com/callback",
      onClosed: () {
        CustomDialogs.toast(
          message: 'Payment cancelled',
        );
      },
      onSuccess: () async {
        ref
            .read(appointmentBookingProvider.notifier)
            .book(ref: ref, context: context);
      },
    );
  }
}
