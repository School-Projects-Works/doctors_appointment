import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/home/state/doctors_provider.dart';
import 'package:doctors_appointment/features/home/state/review_provider.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorCard extends ConsumerStatefulWidget {
  const DoctorCard(this.doctor, {super.key});
  final UserModel doctor;

  @override
  ConsumerState<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends ConsumerState<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var reviewsStream = ref.watch(reviewStreamProvider(widget.doctor.id!));
    var appointmentBookingProviderProvider =
        ref.watch(appointmentBookingProvider);
    return Stack(
      children: [
        InkWell(
          onTap: () {
            MyRouter(contex: context, ref: ref)
                .navigateToNamed(item: RouterItem.viewUserRoute, pathParms: {
              'id': widget.doctor.id!,
            }, extra: {
              'isDoctor': 'true',
              'hasBookButton': 'true'
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.doctor.userImage != null
                        ? Image.network(
                            widget.doctor.userImage!,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          )
                        : const Icon(
                            Icons.person,
                            size: 100,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.doctor.userName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.title(
                        color: primaryColor,
                        desktop: 18,
                        tablet: 16,
                        mobile: 14),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        DoctorMetaData.fromMap(widget.doctor.userMetaData!)
                                .doctorSpeciality ??
                            '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styles.subtitle(
                            color: Colors.blueAccent,
                            desktop: 16,
                            fontFamily: 'Raleway',
                            tablet: 14,
                            mobile: 12),
                      ),
                      const Spacer(),
                      //blinking icon to indecate active and inactive
                      Icon(
                        widget.doctor.userStatus == 'active'
                            ? Icons.circle
                            : Icons.circle_outlined,
                        size: 15,
                        color: widget.doctor.userStatus == 'active'
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.doctor.userStatus == 'active'
                            ? 'Active'
                            : 'Inactive',
                        style: styles.subtitle(
                            color: widget.doctor.userStatus == 'active'
                                ? Colors.green
                                : Colors.red,
                            desktop: 13,
                            fontFamily: 'Raleway',
                            tablet: 12,
                            mobile: 11),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //review section... stars
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: reviewsStream.when(data: (data) {
                      //get all ratings and sum them up
                      var totalRating = data.isNotEmpty
                          ? data.map((e) => e.rating).reduce((a, b) => a + b)
                          : 1;
                      //get the average rating
                      var averageRating = data.isNotEmpty
                          ? (totalRating / data.length)
                          : (totalRating / 1);
                      return Row(
                        children: [
                          for (var i = 0; i < averageRating.toInt(); i++)
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                          const SizedBox(width: 5),
                          Text(
                            '(${averageRating.toStringAsFixed(1)})',
                            style: styles.subtitle(
                                color: Colors.black,
                                desktop: 14,
                                fontFamily: 'Raleway',
                                tablet: 12,
                                mobile: 10),
                          )
                        ],
                      );
                    }, error: (error, stack) {
                      return const SizedBox.shrink();
                    }, loading: () {
                      return const LinearProgressIndicator();
                    })),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Book Appointment',
                  onPressed: () {
                    if (widget.doctor.userStatus!.toLowerCase() == 'active') {
                      ref
                          .read(appointmentBookingProvider.notifier)
                          .setDoctor(widget.doctor);
                    } else {
                      CustomDialogs.toast(
                        message: 'Doctor is currently inactive',
                      );
                    }
                  },
                  color: secondaryColor,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Visibility(
            visible: appointmentBookingProviderProvider != null &&
                appointmentBookingProviderProvider.doctorId == widget.doctor.id,
            child: Container(
              decoration: const BoxDecoration(color: primaryColor),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(appointmentBookingProvider.notifier)
                                .clear();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('Book Appointment',
                            style: styles.title(
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                desktop: 22,
                                tablet: 18,
                                mobile: 16)),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      'You have selected ${widget.doctor.userName}, who is a ${DoctorMetaData.fromMap(widget.doctor.userMetaData!).doctorSpeciality}, from ${DoctorMetaData.fromMap(widget.doctor.userMetaData!).hospitalName}',
                      style: styles.title(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          desktop: 16,
                          tablet: 14,
                          mobile: 13),
                    ),

                    //pick date and time
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextFields(
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
                            text: appointmentBookingProviderProvider != null
                                ? appointmentBookingProviderProvider.date
                                : ''),
                        hintText: 'Pick Date',
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextFields(
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
                            text: appointmentBookingProviderProvider != null
                                ? appointmentBookingProviderProvider.time
                                : ''),
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Book Appointment',
                      onPressed: () {
                        if (ref.watch(userProvider).id != null) {
                          if (ref.watch(userProvider).id == widget.doctor.id) {
                            CustomDialogs.toast(
                              message:
                                  'You can not book appointment with yourself',
                            );
                            return;
                          }
                          ref
                              .read(appointmentBookingProvider.notifier)
                              .book(ref: ref, context: context);
                        } else {
                          CustomDialogs.toast(
                            message: 'Please login to book appointment',
                          );
                        }
                      },
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
