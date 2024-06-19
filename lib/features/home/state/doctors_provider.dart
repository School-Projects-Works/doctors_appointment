import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/home/services/doctor_services.dart';

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
