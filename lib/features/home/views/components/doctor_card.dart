import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/home/state/review_provider.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorCard extends ConsumerWidget {
  const DoctorCard(this.doctor, {super.key});
  final UserModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var reviewsStream = ref.watch(reviewStreamProvider(doctor.id!));
    return InkWell(
      onTap: () {},
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
                child: Image.network(
                  doctor.userImage!,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                doctor.userName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.title(
                    color: primaryColor, desktop: 18, tablet: 16, mobile: 14),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    DoctorMetaData.fromMap(doctor.userMetaData!)
                        .doctorSpeciality!,
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
                    doctor.userStatus == 'active'
                        ? Icons.circle
                        : Icons.circle_outlined,
                    size: 15,
                    color: doctor.userStatus == 'active'
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    doctor.userStatus == 'active' ? 'Active' : 'Inactive',
                    style: styles.subtitle(
                        color: doctor.userStatus == 'active'
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
                  var totalRating =
                      data.map((e) => e.rating).reduce((a, b) => a + b);
                  //get the average rating
                  var averageRating = (totalRating / data.length);
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
              onPressed: () {},
              color: secondaryColor,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
