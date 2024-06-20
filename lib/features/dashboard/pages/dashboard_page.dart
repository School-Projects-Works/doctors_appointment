import 'package:collection/collection.dart';
import 'package:doctors_appointment/features/dashboard/state/main_provider.dart';
import 'package:doctors_appointment/features/dashboard/views/components/dasboard_item.dart';
import 'package:doctors_appointment/features/dashboard/views/components/graph_item.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var doctorsList = ref.watch(doctorFilterProvider);
    var patientsList = ref.watch(patientFilterProvider);
    var appointmentsList = ref.watch(appointmentFilterProvider(null));
    
    var doctorsByCretedAt = groupBy(
        doctorsList.items,
        (obj) => DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(obj.createdAt!)));
    var doctorsByCretedAtToEntries = doctorsByCretedAt.keys
        .toList()
        .map((e) => {'date': e, 'count': doctorsByCretedAt[e]!.length})
        .toList();

    var doctorsBySpeciality =
        groupBy(doctorsList.items, (obj) => obj.userMetaData!['doctorSpeciality']);
    var doctorsBySpecialityToEntries = doctorsBySpeciality.keys
        .toList()
        .map((e) => {'date': e, 'count': doctorsBySpeciality[e]!.length})
        .toList();

  
    var appointmentsByDate = groupBy(
        appointmentsList.items,
        (obj) => DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(obj.createdAt!)));
    var appointmentsByDateToEntries = appointmentsByDate.keys
        .toList()
        .map((e) => {'date': e, 'count': appointmentsByDate[e]!.length})
        .toList();

    var patients = patientsList.items;
    var patientsByDate = groupBy(
        patients,
        (obj) => DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(obj.createdAt!)));
    var patientsByDateToEntries = patientsByDate.keys
        .toList()
        .map((e) => {'date': e, 'count': patientsByDate[e]!.length})
        .toList();
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child:  SingleChildScrollView(
              child: Column(
                children: [
                  styles.rowColumnWidget([
                    DashBoardItem(
                      icon: Icons.people,
                      title: 'Patients',
                      itemCount: patientsList.items.length,
                      color: Colors.blue,
                      onTap: () {},
                    ),
                    DashBoardItem(
                      icon: Icons.local_hospital,
                      title: 'Doctors',
                      itemCount: doctorsList.items.length,
                      color: Colors.green,
                      onTap: () {},
                    ),
                    DashBoardItem(
                      icon: Icons.calendar_today,
                      title: 'Appointments',
                      itemCount: appointmentsList.items.length,
                      color: Colors.orange,
                      onTap: () {},
                    ),
                  ],
                      isRow: styles.largerThanMobile,
                      mainAxisAlignment: MainAxisAlignment.center),
                  const SizedBox(height: 20),
                  Wrap(
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      GraphItel(
                        data: doctorsByCretedAtToEntries.length > 12
                            ? doctorsByCretedAtToEntries.sublist(0, 11)
                            : doctorsByCretedAtToEntries,
                        title: 'Doctors By Joining Date',
                        gradientColors: [
                          Colors.blue,
                          Colors.blue.withOpacity(.5),
                          Colors.blue.withOpacity(.2),
                        ],
                      ),
                      GraphItel(
                        data: doctorsBySpecialityToEntries.length > 9
                            ? doctorsBySpecialityToEntries.sublist(0, 8)
                            : doctorsBySpecialityToEntries,
                        gradientColors: [
                          Colors.green,
                          Colors.green.withOpacity(.5),
                          Colors.green.withOpacity(.2),
                        ],
                        title: 'Doctors By Speciality',
                      ),
                      GraphItel(
                        data: appointmentsByDateToEntries.length > 12
                            ? appointmentsByDateToEntries.sublist(0, 11)
                            : appointmentsByDateToEntries,
                        title: 'Appointments By Date',
                        gradientColors: [
                          Colors.orange,
                          Colors.orange.withOpacity(.5),
                          Colors.orange.withOpacity(.2),
                        ],
                      ),
                      GraphItel(
                        data: patientsByDateToEntries.length > 12
                            ? patientsByDateToEntries.sublist(0, 11)
                            : patientsByDateToEntries,
                        title: 'Patients By Date',
                        gradientColors: [
                          Colors.purple,
                          Colors.purple.withOpacity(.5),
                          Colors.purple.withOpacity(.2),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          
    );
  }
}
