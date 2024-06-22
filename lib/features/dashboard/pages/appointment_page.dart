import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/core/views/custom_input.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/dashboard/state/main_provider.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentPageState();
}

class _AppointmentPageState extends ConsumerState<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var styles = Styles(context);
    var appointmentList = ref.watch(appointmentFilterProvider(
        user.userRole!.toLowerCase() != 'admin' ? user.id : null));
    var notifier = ref.read(appointmentFilterProvider(
            user.userRole!.toLowerCase() != 'admin' ? user.id : null)
        .notifier);
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
                  hintText: 'Search for Appointment',
                  onChanged: (value) {
                    notifier.filterAppointments(value);
                  },
                  suffixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: appointmentList.filter.isEmpty
                ? const Center(child: Text('No Appointment Found'))
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
                              'DARE',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                              label: Text(
                                'DOCTOR',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              size: ColumnSize.L),
                          DataColumn(
                            label: Text(
                              'PATIENT',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'STATUS',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn2(
                              label: Text(
                                'TIME',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              numeric: false,
                              size: ColumnSize.S),
                          if (user.userRole!.toLowerCase() != 'admin')
                            DataColumn2(
                                label: Text(
                                  'ACTION',
                                  style: styles.subtitle(color: Colors.white),
                                ),
                                numeric: false,
                                size: ColumnSize.L),
                        ],
                        rows: appointmentList.filter.isNotEmpty
                            ? appointmentList.filter.map((appointment) {
                                return DataRow(cells: [
                                  DataCell(Text(appointment.date)),
                                  DataCell(Text(appointment.doctorId == user.id
                                      ? 'Me'
                                      : appointment.doctorName)),
                                  DataCell(Text(appointment.patientId == user.id
                                      ? 'Me'
                                      : appointment.patientName)),
                                  DataCell(Container(
                                      width: 122,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: appointment.status
                                                      .toLowerCase() ==
                                                  'cancelled'
                                              ? Colors.red.withOpacity(.8)
                                              : appointment.status
                                                          .toLowerCase() ==
                                                      'pending'
                                                  ? Colors.grey.withOpacity(.8)
                                                  : Colors.green
                                                      .withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        appointment.status,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                                  DataCell(Text(appointment.time)),
                                  if (user.userRole!.toLowerCase() != 'admin')
                                    DataCell(ref.watch(
                                                    selectedAppointmentProvider) !=
                                                null &&
                                            appointment.id ==
                                                ref
                                                    .watch(
                                                        selectedAppointmentProvider)!
                                                    .id
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: CustomTextFields(
                                                  controller: TextEditingController(
                                                      text: ref
                                                          .watch(
                                                              newDateTimeprovider)
                                                          .date),
                                                  hintText: 'Date',
                                                  onTap: () async {
                                                    var date =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 365)),
                                                    );
                                                    if (date != null) {
                                                      ref
                                                              .read(
                                                                  newDateTimeprovider
                                                                      .notifier)
                                                              .state =
                                                          ref
                                                              .watch(
                                                                  newDateTimeprovider)
                                                              .copyWith(
                                                                  date: DateFormat(
                                                                          'EEE,MMM dd, yyyy')
                                                                      .format(
                                                                          date));
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: CustomTextFields(
                                                  controller: TextEditingController(
                                                      text: ref
                                                          .watch(
                                                              newDateTimeprovider)
                                                          .time),
                                                  hintText: 'Time',
                                                  onTap: () async {
                                                    var time =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                    if (time != null) {
                                                      ref
                                                              .read(
                                                                  newDateTimeprovider
                                                                      .notifier)
                                                              .state =
                                                          ref
                                                              .watch(
                                                                  newDateTimeprovider)
                                                              .copyWith(
                                                                  time: time.format(
                                                                      context));
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          if (ref
                                                                  .watch(
                                                                      newDateTimeprovider)
                                                                  .date
                                                                  .isEmpty ||
                                                              ref
                                                                  .watch(
                                                                      newDateTimeprovider)
                                                                  .time
                                                                  .isEmpty) {
                                                            CustomDialogs.showDialog(
                                                                message:
                                                                    'Please select a date and time to reschedule the appointment.',
                                                                type: DialogType
                                                                    .error);
                                                            return;
                                                          }
                                                          ref
                                                              .read(
                                                                  selectedAppointmentProvider
                                                                      .notifier)
                                                              .reschedule(
                                                                  ref: ref);
                                                        },
                                                        child: const Text(
                                                            'Reschedule')),
                                                    const SizedBox(height: 2),
                                                    InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  selectedAppointmentProvider
                                                                      .notifier)
                                                              .clear();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              //view button
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.blue,
                                                  )),
                                              const SizedBox(width: 10),
                                              if (appointment.status
                                                      .toLowerCase() !=
                                                  'cancelled')
                                                PopupMenuButton(
                                                  itemBuilder: (context) {
                                                    return [
                                                      //cancel appointment
                                                      if (appointment.status
                                                              .toLowerCase() !=
                                                          'cancelled')
                                                        const PopupMenuItem(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 20),
                                                          value: 'cancel',
                                                          child: ListTile(
                                                            title:
                                                                Text('Cancel'),
                                                            leading: Icon(
                                                              Icons.cancel,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      //reschedule appointment
                                                      const PopupMenuItem(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 20),
                                                        value: 'reschedule',
                                                        child: ListTile(
                                                          title: Text(
                                                              'Reschedule'),
                                                          leading: Icon(
                                                            Icons
                                                                .calendar_today,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      if (appointment.status
                                                                  .toLowerCase() ==
                                                              'pending' &&
                                                          appointment
                                                                  .doctorId ==
                                                              user.id)
                                                        const PopupMenuItem(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 20),
                                                          value: 'accept',
                                                          child: ListTile(
                                                            title:
                                                                Text('Accept'),
                                                            leading: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                    ];
                                                  },
                                                  onSelected: (value) {
                                                    if (value == 'cancel') {
                                                      CustomDialogs.showDialog(
                                                          message:
                                                              'Are you sure you want to cancel this appointment?',
                                                          secondBtnText:
                                                              'Cancel',
                                                          type: DialogType
                                                              .warning,
                                                          onConfirm: () {
                                                            ref
                                                                .read(appointmentFilterProvider(
                                                                        user.id)
                                                                    .notifier)
                                                                .cancelAppointment(
                                                                    appointment);
                                                          });
                                                    } else if (value ==
                                                        'reschedule') {
                                                      //show reschedule dialog
                                                      ref
                                                          .read(
                                                              selectedAppointmentProvider
                                                                  .notifier)
                                                          .setAppointment(
                                                              appointment);
                                                    } else if (value ==
                                                        'accept') {
                                                      CustomDialogs.showDialog(
                                                          message:
                                                              'Are you sure you want to accept this appointment?',
                                                          secondBtnText:
                                                              'Accept',
                                                          type: DialogType
                                                              .warning,
                                                          onConfirm: () {
                                                            ref
                                                                .read(appointmentFilterProvider(
                                                                        user.id)
                                                                    .notifier)
                                                                .acceptAppointment(
                                                                    appointment);
                                                          });
                                                    }
                                                  },
                                                  child: const Icon(Icons.apps),
                                                )
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
