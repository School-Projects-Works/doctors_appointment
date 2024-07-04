import 'package:doctors_appointment/core/functions/sms_api.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/home/services/doctor_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/appointment/data/appointment_model.dart';
import 'package:doctors_appointment/features/appointment/services/appointment_services.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/data/review_model.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/services/review_services.dart';

final adminDotcorStreamProvider = StreamProvider<List<UserModel>>((ref) async* {
  var data = DoctorServices.getDoctorsByAdmin();
  await for (var item in data) {
    ref.read(doctorFilterProvider.notifier).setItems(item);
    yield item;
  }
});

class DoctorFilter {
  List<UserModel> items;
  List<UserModel> filteredList;
  DoctorFilter({
    this.items = const [],
    this.filteredList = const [],
  });

  DoctorFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filteredList,
  }) {
    return DoctorFilter(
      items: items ?? this.items,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}

final doctorFilterProvider =
    StateNotifierProvider<DoctorFilterProvider, DoctorFilter>((ref) {
  return DoctorFilterProvider();
});

class DoctorFilterProvider extends StateNotifier<DoctorFilter> {
  DoctorFilterProvider() : super(DoctorFilter(items: [], filteredList: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items, filteredList: items);
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
    } else {
      var filtered = state.items.where((element) {
        var metaData = DoctorMetaData.fromMap(element.userMetaData!);
        return metaData.doctorSpeciality!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.userName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filteredList: filtered);
    }
  }

  void updateDoctor(UserModel doctor, String status) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(
        message:
            status == 'banned' ? 'Blocking Doctor...' : 'Unblocking Doctor...');
    doctor = doctor.copyWith(userStatus: () => status);
    var res = await RegistrationServices.updateUser(doctor);
    if (res) {
      //send notification to doctor
      var phone = doctor.userPhone;
      var message = status == 'banned'
          ? 'Your Account has been Blocked.You can no longer access the E-Doctor Platform. Contact Admin for more information'
          : 'Your Account has been Unblocked. You can now access the E-Doctor Platform';
      await SmsApi().sendMessage(phone!, message);
      state = state.copyWith(
          filteredList: state.filteredList
              .map((e) => e.id == doctor.id ? doctor : e)
              .toList(),
          items:
              state.items.map((e) => e.id == doctor.id ? doctor : e).toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Doctor Banned Successfully'
              : 'Doctor Unbanned Successfully',
          type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Failed to Band Doctor'
              : 'Failed to Unban Doctor',
          type: DialogType.error);
    }
  }
}

final adminPatientStreamProvider =
    StreamProvider<List<UserModel>>((ref) async* {
  var data = RegistrationServices.getPatients();
  await for (var item in data) {
    ref.read(patientFilterProvider.notifier).setItems(item);
    yield item;
  }
});

class PatientFilter {
  List<UserModel> items;
  List<UserModel> filteredList;
  PatientFilter({
    this.items = const [],
    this.filteredList = const [],
  });

  PatientFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filteredList,
  }) {
    return PatientFilter(
      items: items ?? this.items,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}

final patientFilterProvider =
    StateNotifierProvider<PatientFilterProvider, PatientFilter>((ref) {
  return PatientFilterProvider();
});

class PatientFilterProvider extends StateNotifier<PatientFilter> {
  PatientFilterProvider() : super(PatientFilter(items: [], filteredList: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items, filteredList: items);
  }

  void filterPatient(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredList: state.items);
    } else {
      var filtered = state.items.where((element) {
        return element.userName!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      state = state.copyWith(filteredList: filtered);
    }
  }

  void updatePatient(UserModel patient, String status) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(
        message: status == 'banned'
            ? 'Blocking Patient...'
            : 'Unblocking Patient...');
    patient = patient.copyWith(userStatus: () => status);
    var res = await RegistrationServices.updateUser(patient);
    if (res) {
      state = state.copyWith(
          filteredList: state.filteredList
              .map((e) => e.id == patient.id ? patient : e)
              .toList(),
          items: state.items
              .map((e) => e.id == patient.id ? patient : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Patient Banned Successfully'
              : 'Patient Unbanned Successfully',
          type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Failed to Band Patient'
              : 'Failed to Unban Patient',
          type: DialogType.error);
    }
  }
}

final adminAppointmentStreamProvider =
    StreamProvider<List<AppointmentModel>>((ref) async* {
  var data = AppointmentServices.getAllAppointments();
  await for (var item in data) {
    ref.read(allAppointmentsProvider.notifier).state = item;
    yield item;
  }
});

class AppointmentFilter {
  List<AppointmentModel> items;
  List<AppointmentModel> filter;

  AppointmentFilter({
    this.items = const [],
    this.filter = const [],
  });

  AppointmentFilter copyWith({
    List<AppointmentModel>? items,
    List<AppointmentModel>? filter,
  }) {
    return AppointmentFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final allAppointmentsProvider = StateProvider<List<AppointmentModel>>((ref) {
  return [];
});

final appointmentFilterProvider = StateNotifierProvider.family<
    AppointmentFilterProvider, AppointmentFilter, String?>((ref, id) {
  var data = ref.watch(allAppointmentsProvider);
  if (id != null && id.isNotEmpty) {
    var items = data
        .where((element) => element.patientId == id || element.doctorId == id)
        .toList();
    return AppointmentFilterProvider()..setItems(items);
  }
  return AppointmentFilterProvider()..setItems(data);
});

class AppointmentFilterProvider extends StateNotifier<AppointmentFilter> {
  AppointmentFilterProvider() : super(AppointmentFilter(items: []));

  void setItems(List<AppointmentModel> items) async {
    state = state.copyWith(items: items, filter: items);
  }

  void filterAppointments(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      var filtered = state.items.where((element) {
        return element.patientName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.doctorName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: filtered);
    }
  }

  void cancelAppointment(AppointmentModel appointment, UserModel user) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Cancelling Appointment');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'cancelled'});

    if (data) {
      //send notification to patient
      var phone = appointment.patientId == user.id
          ? appointment.doctorPhone
          : appointment.patientPhone;
      var toWho = appointment.patientId == user.id
          ? appointment.patientName
          : appointment.doctorName;
      var message = 'Your Appointment with $toWho has been cancelled';
      await SmsApi().sendMessage(phone, message);
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'cancelled')
                  : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Cancelled', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Cancel Appointment', type: DialogType.error);
    }
  }

  void acceptAppointment(AppointmentModel appointment, UserModel user) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Accepting Appointment');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'accepted'});

    if (data) {
      var phone = appointment.patientId == user.id
          ? appointment.doctorPhone
          : appointment.patientPhone;
      var toWho = appointment.patientId == user.id
          ? appointment.patientName
          : appointment.doctorName;
      var message = 'Your Appointment with $toWho has been Accepted';
      await SmsApi().sendMessage(phone, message);
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'accepted')
                  : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Accepted', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Accept Appointment', type: DialogType.error);
    }
  }

  void completeAppointment(AppointmentModel appointment, UserModel user) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Completing Appointment..');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'completed'});
    if (data) {
      //send notification to patient
      var phone = appointment.patientId == user.id
          ? appointment.doctorPhone
          : appointment.patientPhone;
      var toWho = appointment.patientId == user.id
          ? appointment.patientName
          : appointment.doctorName;
      var message = 'Your Appointment with $toWho has been Completed';
      await SmsApi().sendMessage(phone, message);
      CustomDialogs.dismiss();
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'completed')
                  : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Completed', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Complete Appointment', type: DialogType.error);
    }
  }
}

final newDateTimeprovider = StateProvider<NewDateTime>((ref) {
  return NewDateTime(date: '', time: '');
});

final isRescheduleProvider = StateProvider<bool>((ref) => false);

final selectedAppointmentProvider =
    StateNotifierProvider<RescheduleApp, AppointmentModel?>((ref) {
  return RescheduleApp();
});

class RescheduleApp extends StateNotifier<AppointmentModel?> {
  RescheduleApp() : super(null);
  void setAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void clear() {
    state = null;
  }

  void reschedule({required WidgetRef ref}) async {
    CustomDialogs.loading(message: 'Rescheduling Appointment');
    var data = ref.read(newDateTimeprovider);
    var user = ref.read(userProvider);
    var appointment = state!.copyWith(date: data.date, time: data.time);
    var res = await AppointmentServices.updateAppointment(appointment.id, {
      'date': data.date,
      'time': data.time,
    });

    if (res) {
      var phone = appointment.patientId == user.id
          ? appointment.doctorPhone
          : appointment.patientPhone;
      var toWho = appointment.patientId == user.id
          ? appointment.patientName
          : appointment.doctorName;
      var message =
          'Your Appointment with $toWho has been Rescheduled to ${data.date} at ${data.time}';
      await SmsApi().sendMessage(phone, message);
      clear();
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Rescheduled', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Reschedule Appointment', type: DialogType.error);
    }
  }
}

class NewDateTime {
  String date;
  String time;
  NewDateTime({
    required this.date,
    required this.time,
  });

  NewDateTime copyWith({
    String? date,
    String? time,
  }) {
    return NewDateTime(
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}

final adminReviewsStreamProvider =
    StreamProvider<List<ReviewModel>>((ref) async* {
  var data = ReviewServices.getAllReviews();
  await for (var item in data) {
    ref.read(reviewsProvider.notifier).setItems(item);
    yield item;
  }
});

final reviewsProvider =
    StateNotifierProvider<ReviewsProvider, List<ReviewModel>>((ref) {
  return ReviewsProvider();
});

class ReviewsProvider extends StateNotifier<List<ReviewModel>> {
  ReviewsProvider() : super([]);
  void setItems(List<ReviewModel> items) {
    state = items;
  }

  double getRating(String doctorId) {
    var reviews =
        state.where((element) => element.doctorId == doctorId).toList();
    if (reviews.isEmpty) {
      return 0;
    }
    var total = reviews.fold<double>(
        0, (previousValue, element) => previousValue + element.rating);
    return total / reviews.length;
  }
}
