import 'package:data_table_2/data_table_2.dart';
import 'package:doctors_appointment/core/views/custom_drop_down.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/dashboard/state/main_provider.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DoctorsPage extends ConsumerStatefulWidget {
  const DoctorsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends ConsumerState<DoctorsPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var styles = Styles(context);
    var doctorsList = ref.watch(doctorFilterProvider);
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: styles.isDesktop
                    ? styles.width * .5
                    : styles.isMobile
                        ? styles.width * .8
                        : styles.width * 55,
                child: CustomTextFields(
                  hintText: 'Serch for Doctor',
                  onChanged: (value) {
                    ref
                        .read(doctorFilterProvider.notifier)
                        .filterDoctors(value);
                  },
                  suffixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: doctorsList.pages.isEmpty
                ? const Center(child: Text('No Doctor Found'))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        headingRowColor: WidgetStateProperty.all(primaryColor),
                        minWidth: 600,
                        columns: [
                          DataColumn2(
                            label: Text(
                              'IMAGE',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                              label: Text(
                                'NAME',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              size: ColumnSize.L),
                          DataColumn(
                            label: Text(
                              'SPECIALTY',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'HOSPITAL',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn2(
                              label: Text(
                                'STATUS',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              numeric: false,
                              size: ColumnSize.S),
                          DataColumn(
                            label: Text(
                              'CREATED AT',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text(
                              'ACTION',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            numeric: false,
                          ),
                        ],
                        rows: doctorsList.pages.isNotEmpty
                            ? doctorsList.pages[doctorsList.page].map((doctor) {
                                var metaData = DoctorMetaData.fromMap(
                                    doctor.userMetaData!);
                                return DataRow(cells: [
                                  DataCell(Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    margin: const EdgeInsets.all(2),
                                    child: doctor.userImage != null
                                        ? Image.network(
                                            doctor.userImage!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.asset(
                                            doctor.userGender == 'Male'
                                                ? Assets.imagesMale
                                                : Assets.imagesFemale,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                  )),
                                  DataCell(Text(doctor.userName ?? '')),
                                  DataCell(
                                      Text(metaData.doctorSpeciality ?? '')),
                                  DataCell(Text(metaData.hospitalName ?? '')),
                                  DataCell(Container(
                                      width: 122,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: doctor.userStatus!
                                                      .toLowerCase() ==
                                                  'band'
                                              ? Colors.red.withOpacity(.8)
                                              : doctor.userStatus!
                                                          .toLowerCase() ==
                                                      'inactive'
                                                  ? Colors.grey.withOpacity(.8)
                                                  : Colors.green
                                                      .withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        doctor.userStatus ?? '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                                  DataCell(Text(DateFormat('EEE,MMM dd, yyyy')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              doctor.createdAt!)))),
                                  DataCell(Row(
                                    children: [
                                      //view button
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          )),
                                      const SizedBox(width: 10),
                                      if (doctor.userStatus!.toLowerCase() ==
                                          'band')
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.lock_open,
                                              color: Colors.green,
                                            )),
                                      if (doctor.userStatus!.toLowerCase() !=
                                          'band')
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.lock,
                                              color: Colors.red,
                                            )),
                                    ],
                                  ))
                                ]);
                              }).toList()
                            : []),
                  ),
          ),
          //pageination
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //dropdown
                SizedBox(
                  width: 100,
                  child: CustomDropDown(
                      value: doctorsList.pageSize,
                      items: [10, 20, 50, 100]
                          .map((index) => DropdownMenuItem(
                                value: index,
                                child: Text('$index'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        ref
                            .read(doctorFilterProvider.notifier)
                            .setPageSize(value!);
                      }),
                ),
                const SizedBox(
                  width: 16,
                ),
                if (doctorsList.page > 0)
                  IconButton(
                      style: ButtonStyle(
                          iconSize: WidgetStateProperty.all(18),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black87)),
                      onPressed: () {
                        ref.read(doctorFilterProvider.notifier).previousPage();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                      )),
                const SizedBox(
                  width: 10,
                ),
                Text('${doctorsList.page + 1}'),
                const SizedBox(
                  width: 10,
                ),
                if (doctorsList.pages.length != doctorsList.page - 1)
                  IconButton(
                      style: ButtonStyle(
                          iconSize: WidgetStateProperty.all(18),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black87)),
                      onPressed: () {
                        ref.read(doctorFilterProvider.notifier).nextPage();
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
