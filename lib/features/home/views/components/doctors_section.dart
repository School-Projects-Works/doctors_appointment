import 'package:doctors_appointment/core/views/custom_button.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/home/state/doctors_provider.dart';
import 'package:doctors_appointment/features/home/views/components/doctor_card.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/pages/register/data/user_model.dart';

class DoctorSection extends ConsumerStatefulWidget {
  const DoctorSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DoctorSectionState();
}

class _DoctorSectionState extends ConsumerState<DoctorSection> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var doctorStream = ref.watch(dcotorsStreamProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if ((styles.smallerThanTablet &&
                      !ref.watch(isSearchingProvider)) ||
                  !styles.smallerThanTablet)
                Text(
                  'Our Doctors',
                  style: styles.title(
                      color: primaryColor, desktop: 26, tablet: 22, mobile: 18),
                ),
              // if ((styles.smallerThanTablet &&
              //         !ref.watch(isSearchingProvider)) ||
              //     !styles.smallerThanTablet)
              const Spacer(),
              if ((styles.smallerThanTablet &&
                      ref.watch(isSearchingProvider)) ||
                  !styles.smallerThanTablet)
                SizedBox(
                    width: styles.isMobile
                        ? 300
                        : styles.isTablet
                            ? 450
                            : 500,
                    child: CustomTextFields(
                      hintText: 'Search Doctors',
                      onChanged: (value) {
                        ref
                            .read(doctorsFilterProvider.notifier)
                            .filterDoctors(value);
                      },
                    )),
              const SizedBox(width: 10),
              if (styles.smallerThanTablet)
                IconButton(
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      backgroundColor: WidgetStateProperty.all(primaryColor)),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state =
                        !ref.watch(isSearchingProvider);
                  },
                  icon: Icon(ref.watch(isSearchingProvider)
                      ? Icons.cancel
                      : Icons.search),
                ),
            ],
          ),
          const SizedBox(height: 20),
          doctorStream.when(data: (data) {
            var data = ref.watch(doctorsFilterProvider);
            if (data.filter.isEmpty) {
              return const SizedBox(
                  height: 200, child: Center(child: Text('No doctor found ')));
            }
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: styles.isMobile
                      ? 2
                      : styles.isTablet
                          ? 3
                          : 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: styles.isMobile
                      ? 10
                      : styles.isTablet
                          ? 20
                          : 30,
                  mainAxisSpacing: 10),
              itemCount: data.filter.length,
              itemBuilder: (context, index) {
                var doctor = data.filter[index];
                return DoctorCard(doctor);
               },
            );
          }, error: (error, stack) {
            return SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(child: Text(error.toString())));
          }, loading: () {
            return const SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
          })
        ],
      ),
    );
  }
}
