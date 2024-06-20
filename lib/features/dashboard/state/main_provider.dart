import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:doctors_appointment/features/appointment/data/appointment_model.dart';
import 'package:doctors_appointment/features/appointment/services/appointment_services.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/data/review_model.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/services/review_services.dart';

class DataModel {
  List<UserModel> doctors;
  List<UserModel> patients;
  List<ReviewModel> reviews;
  List<AppointmentModel> appointments;
  DataModel({
    this.doctors = const [],
    this.patients = const [],
    this.reviews = const [],
    this.appointments = const [],
  });
}

final allDataStreamProvider = StreamProvider<DataModel>((ref) async* {
  var data = DataModel();
  var users = RegistrationServices.getUsers();
  var reviews = ReviewServices.getAllReviews();
  var appointments = AppointmentServices.getAllAppointments();
  await for (var item in users) {
    data.doctors = item
        .where((element) => element.userRole!.toLowerCase() == 'doctor')
        .toList();
    data.patients = item
        .where((element) => element.userRole!.toLowerCase() == 'patient')
        .toList();
    ref.read(doctorFilterProvider.notifier).setItems(data.doctors);
    ref.read(patientFilterProvider.notifier).setItems(data.patients);
    await for (var item in reviews) {
      data.reviews = item;
      await for (var item in appointments) {
        data.appointments = item;
        ref.read(allAppointmentsProvider.notifier).state = data.appointments;

        yield data;
      }
    }
  }
});

class DoctorFilter {
  List<UserModel> items;
  int page;
  int pageSize;
  List<List<UserModel>> pages = [];
  DoctorFilter({
    this.items = const [],
    this.page = 0,
    this.pageSize = 10,
    this.pages = const [],
  });

  DoctorFilter copyWith({
    List<UserModel>? items,
    int? page,
    int? pageSize,
    List<List<UserModel>>? pages,
  }) {
    return DoctorFilter(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      pages: pages ?? this.pages,
    );
  }
}

final doctorFilterProvider =
    StateNotifierProvider<DoctorFilterProvider, DoctorFilter>((ref) {
  return DoctorFilterProvider();
});

class DoctorFilterProvider extends StateNotifier<DoctorFilter> {
  DoctorFilterProvider() : super(DoctorFilter(items: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items);
    groupToPages(items);
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      groupToPages(state.items);
    } else {
      var filtered = state.items.where((element) {
        var metaData = DoctorMetaData.fromMap(element.userMetaData!);
        return metaData.doctorSpeciality!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.userName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      groupToPages(filtered);
    }
  }

  void nextPage() {
    if (state.page < state.pages.length - 1) {
      state = state.copyWith(page: state.page + 1);
    }
  }

  void previousPage() {
    if (state.page > 0) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void groupToPages(List<UserModel> items) {
    var pages = <List<UserModel>>[];
    for (var i = 0; i < items.length; i += state.pageSize) {
      var end = i + state.pageSize;
      if (end > items.length) {
        end = items.length;
      }
      if (items.length > end) {
        pages.add(items.sublist(i, end));
      } else {
        pages.add(items);
      }
    }
    state = state.copyWith(pages: pages, page: 0);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size);
    groupToPages(state.items);
  }
}

class PatientFilter {
  List<UserModel> items;
  int page;
  int pageSize;
  List<List<UserModel>> pages = [];
  PatientFilter({
    this.items = const [],
    this.page = 0,
    this.pageSize = 10,
    this.pages = const [],
  });

  PatientFilter copyWith({
    List<UserModel>? items,
    int? page,
    int? pageSize,
    List<List<UserModel>>? pages,
  }) {
    return PatientFilter(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      pages: pages ?? this.pages,
    );
  }
}

final patientFilterProvider =
    StateNotifierProvider<PatientFilterProvider, PatientFilter>((ref) {
  return PatientFilterProvider();
});

class PatientFilterProvider extends StateNotifier<PatientFilter> {
  PatientFilterProvider() : super(PatientFilter(items: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items);
    groupToPages(items);
  }

  void filterPatient(String query) {
    if (query.isEmpty) {
      groupToPages(state.items);
    } else {
      var filtered = state.items.where((element) {
        return element.userName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      groupToPages(filtered);
    }
  }

  void nextPage() {
    if (state.page < state.pages.length - 1) {
      state = state.copyWith(page: state.page + 1);
    }
  }

  void previousPage() {
    if (state.page > 0) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void groupToPages(List<UserModel> items) {
    var pages = <List<UserModel>>[];
    for (var i = 0; i < items.length; i += state.pageSize) {
      var end = i + state.pageSize;
      if (end > items.length) {
        end = items.length;
      }
      if (items.length > end) {
        pages.add(items.sublist(i, end));
      } else {
        pages.add(items);
      }
    }
    state = state.copyWith(pages: pages, page: 0);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size);
    groupToPages(state.items);
  }
}

class AppointmentFilter {
  List<AppointmentModel> items;
  List<AppointmentModel> filter;
  int page;
  int pageSize;
  List<List<AppointmentModel>> pages = [];

  AppointmentFilter({
    this.items = const [],
    this.filter = const [],
    this.page = 0,
    this.pageSize = 10,
    this.pages = const [],
  });

  AppointmentFilter copyWith({
    List<AppointmentModel>? items,
    List<AppointmentModel>? filter,
    int? page,
    int? pageSize,
    List<List<AppointmentModel>>? pages,
  }) {
    return AppointmentFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      pages: pages ?? this.pages,
    );
  }
}

final allAppointmentsProvider = StateProvider<List<AppointmentModel>>((ref) {
  return [];
});

final appointmentFilterProvider = StateNotifierProvider.family<
    AppointmentFilterProvider, AppointmentFilter, String?>((ref, id) {
  var data = ref.watch(allAppointmentsProvider);
  if (id != null) {
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
    groupToPages(items);
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
    groupToPages(state.filter);
  }

  void nextPage() {
    if (state.page < state.pages.length - 1) {
      state = state.copyWith(page: state.page + 1);
    }
  }

  void previousPage() {
    if (state.page > 0) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void groupToPages(List<AppointmentModel> items) {
    var pages = <List<AppointmentModel>>[];
    for (var i = 0; i < items.length; i += state.pageSize) {
      var end = i + state.pageSize;
      if (end > items.length) {
        end = items.length;
      }
      if (items.length > end) {
        pages.add(items.sublist(i, end));
      } else {
        pages.add(items);
      }
    }
    state = state.copyWith(pages: pages, page: 0);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size);
    groupToPages(state.items);
  }

  void cancelAppointment(AppointmentModel appointment) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Cancelling Appointment');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'cancelled'});
    CustomDialogs.dismiss();
    if (data) {
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'cancelled')
                  : e)
              .toList());
      CustomDialogs.toast(
          message: 'Appointment Cancelled', type: DialogType.success);
    } else {
      CustomDialogs.toast(
          message: 'Failed to Cancel Appointment', type: DialogType.error);
    }
  }

  void acceptAppointment(AppointmentModel appointment) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Accepting Appointment');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'accepted'});
    CustomDialogs.dismiss();
    if (data) {
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'accepted')
                  : e)
              .toList());
      CustomDialogs.toast(
          message: 'Appointment Accepted', type: DialogType.success);
    } else {
      CustomDialogs.toast(
          message: 'Failed to Accept Appointment', type: DialogType.error);
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

  void reschedule({required WidgetRef ref})async {
    CustomDialogs.loading(message: 'Rescheduling Appointment');
    var data = ref.read(newDateTimeprovider);
    var appointment = state!.copyWith(date: data.date, time: data.time);
    var res = await AppointmentServices.updateAppointment(appointment.id, {
      'date': data.date,
      'time': data.time,
    });
    CustomDialogs.dismiss();
    if (res) {
      clear();
      CustomDialogs.toast(
          message: 'Appointment Rescheduled', type: DialogType.success);
    } else {
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
