import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/appointment/data/appointment_model.dart';
import 'package:doctors_appointment/features/appointment/services/appointment_services.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:faker/faker.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/home/services/doctor_services.dart';
import 'package:intl/intl.dart';

final dcotorsStreamProvider =
    StreamProvider.autoDispose<List<UserModel>>((ref) async* {
  var data = DoctorServices.getDoctors();
  await for (var item in data) {
    ref.read(doctorsFilterProvider.notifier).setItems(item);
    yield item;
  }
});

class DoctorsFilter {
  List<UserModel> items;
  List<UserModel> filter;
  DoctorsFilter({required this.items, this.filter = const []});

  DoctorsFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filter,
  }) {
    return DoctorsFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final doctorsFilterProvider =
    StateNotifierProvider<DoctorsFilterProvider, DoctorsFilter>((ref) {
  //return DoctorsFilterProvider()..updateData();
  return DoctorsFilterProvider();
});

class DoctorsFilterProvider extends StateNotifier<DoctorsFilter> {
  DoctorsFilterProvider() : super(DoctorsFilter(items: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items, filter: items);
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      var filtered = state.items.where((element) {
        var metaData = DoctorMetaData.fromMap(element.userMetaData!);
        return metaData.doctorSpeciality!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.userName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: filtered);
    }
  }

  void saveDummyData() async {
    var data = dummyDoctor();
    for (var item in data) {
      item.id = RegistrationServices.getId();
      await RegistrationServices.createUser(item);
    }
  }

  void updateData() async {
    var faker = Faker();
    var data = await DoctorServices.getAllDoctors();
    for (var doctor in data) {
      doctor.createdAt = DateTime(
              faker.randomGenerator.integer(2020, min: 2010),
              faker.randomGenerator.integer(12, min: 1),
              faker.randomGenerator.integer(28, min: 1))
          .millisecondsSinceEpoch;
      await RegistrationServices.updateUser(doctor);
    }
  }
}

final isSearchingProvider = StateProvider<bool>((ref) => false);

final appointmentBookingProvider =
    StateNotifierProvider<SelectedDoctorProvider, AppointmentModel?>(
        (ref) => SelectedDoctorProvider());

class SelectedDoctorProvider extends StateNotifier<AppointmentModel?> {
  SelectedDoctorProvider() : super(null);
  void setDoctor(UserModel doctor) {
    state = AppointmentModel(
      doctorId: doctor.id!,
      doctorName: doctor.userName!,
      date: '',
      time: '',
      status: 'pending',
      patientId: '',
      patientName: '',
      id: '',
    );
  }

  void clear() {
    state = null;
  }

  void setDate(DateTime value) {
    var date = DateFormat('EEE, MMM d, yyyy').format(value);
    state = state!.copyWith(date: date);
  }

  void setTime(String format) {
    state = state!.copyWith(time: format);
  }

  void book({required WidgetRef ref, required BuildContext context}) async {
    CustomDialogs.loading(
      message: 'Booking Appointment...',
    );
    var user = ref.read(userProvider);
    //check if user do not have pending or accepted appointment with the same doctor
    var existenAppontment = await AppointmentServices.getAppByUserAndDoctor(
        user.id!, state!.doctorId);
    if (existenAppontment.isNotEmpty) {
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
        type: DialogType.error,
        message:
            'You already have an appointment with this doctor, please cancel the existing appointment to book a new one',
      );
      return;
    }
    state = state!.copyWith(
      patientId: user.id!,
      patientName: user.userName!,
      id: AppointmentServices.getId(),
      createdAt: () => DateTime.now().millisecondsSinceEpoch,
    );
    var result = await AppointmentServices.createAppointment(state!);
    if (result) {
      state = null;
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
        type: DialogType.success,
        message: 'Appointment booked successfully',
      );
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
        type: DialogType.error,
        message: 'Failed to book appointment, please try again',
      );
    }
  }
}
