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
    yield data;
  }
  await for (var item in reviews) {
    data.reviews = item;
    yield data;
  }
  await for (var item in appointments) {
    data.appointments = item;
    yield data;
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
  AppointmentFilter({required this.items, this.filter = const []});

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

final appointmentFilterProvider =
    StateNotifierProvider<AppointmentFilterProvider, AppointmentFilter>((ref) {
  return AppointmentFilterProvider();
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
}
