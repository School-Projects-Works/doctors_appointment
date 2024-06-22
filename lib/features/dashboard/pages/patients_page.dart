import 'package:data_table_2/data_table_2.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/dashboard/pages/view_user.dart';
import 'package:doctors_appointment/features/dashboard/state/main_provider.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PatientsPage extends ConsumerStatefulWidget {
  const PatientsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PatientsPageState();
}

class _PatientsPageState extends ConsumerState<PatientsPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var patientsList = ref.watch(patientFilterProvider);
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
                  hintText: 'Serch for Patients',
                  onChanged: (value) {
                    ref
                        .read(patientFilterProvider.notifier)
                        .filterPatient(value);
                  },
                  suffixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: patientsList.filteredList.isEmpty
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
                              'DOB',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn2(
                            label: Text(
                              'BLOOD GROUP',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text(
                              'WEIGHT',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text(
                              'HEIGHT',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
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
                        rows: patientsList.filteredList.isNotEmpty
                            ? patientsList.filteredList.map((doctor) {
                                var metaData = PatientMetaData.fromMap(
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
                                  DataCell(Text(metaData.patientDOB ?? '')),
                                  DataCell(
                                      Text(metaData.patientBloodGroup ?? '')),
                                  DataCell(Text(metaData.patientWeight ?? '')),
                                  DataCell(Text(metaData.patientHeight ?? '')),
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
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ViewUser(user: doctor);
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          )),
                                      const SizedBox(width: 10),
                                      if (doctor.userStatus!.toLowerCase() ==
                                          'banned')
                                        IconButton(
                                            onPressed: () {
                                              CustomDialogs.showDialog(
                                                  message:
                                                      'Are you sure you want to unblock this user',
                                                  secondBtnText: 'Unband',
                                                  onConfirm: () {
                                                    ref
                                                        .read(
                                                            doctorFilterProvider
                                                                .notifier)
                                                        .updateDoctor(
                                                            doctor, 'active');
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.lock_open,
                                              color: Colors.green,
                                            )),
                                      if (doctor.userStatus!.toLowerCase() !=
                                          'banned')
                                        IconButton(
                                            onPressed: () {
                                              CustomDialogs.showDialog(
                                                  message:
                                                      'Are you sure you want to block this user',
                                                  secondBtnText: 'Band',
                                                  onConfirm: () {
                                                    ref
                                                        .read(
                                                            doctorFilterProvider
                                                                .notifier)
                                                        .updateDoctor(
                                                            doctor, 'banned');
                                                  });
                                            },
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
