import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final userRegistrationProvider =
    StateNotifierProvider<UserRegistrationProvider, UserModel>((ref) {
  return UserRegistrationProvider();
});

class UserRegistrationProvider extends StateNotifier<UserModel> {
  UserRegistrationProvider() : super(UserModel());

  void setEmail(String email) {
    state = state.copyWith(email: () => email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: () => password);
  }

  void register({required WidgetRef ref, required BuildContext context}) {}

  void setUserRole(String? value) {
    state = state.copyWith(userRole: () => value);
  }
void setName(String s) {
    state = state.copyWith(userName: () => s);
}
  void setGender(value) {
    state = state.copyWith(userGender: () => value);
  }

  void setPhone(String s) {
    state = state.copyWith(userPhone: () => s);
  }

  void moveToAddress({required WidgetRef ref}) {
    ref.read(regPagesProvider.notifier).state = 1;
  }

  void reset() {
    state = UserModel();
  }

  
}

final regAddressProvider =
    StateNotifierProvider<RegAddressProvider, UserAddressModel>((ref) {
  return RegAddressProvider();
});

class RegAddressProvider extends StateNotifier<UserAddressModel> {
  RegAddressProvider() : super(UserAddressModel());

  void setAddress(String address) {
    state = state.copyWith(address: () => address);
  }

  void setCity(String city) {
    state = state.copyWith(city: () => city);
  }

  void setRegion(String postalCode) {
    state = state.copyWith(region: () => postalCode);
  }

  void moveToMetaData({required WidgetRef ref}) {
    ref.read(regPagesProvider.notifier).state = 2;
  }

  void reset() {
    state = UserAddressModel();
  }
}

final regPatientMetaDataProvider =
    StateNotifierProvider<RegMetaPatientDataProvider, PatientMetaData>((ref) {
  return RegMetaPatientDataProvider();
});

class RegMetaPatientDataProvider extends StateNotifier<PatientMetaData> {
  RegMetaPatientDataProvider() : super(PatientMetaData());

  void setDateOfBirth(DateTime date) {
    var formatter = DateFormat('EEE, MMM d, yyyy');
    state = state.copyWith(patientDOB: () => formatter.format(date));
  }

  void setOccupation(String s) {
    state = state.copyWith(occupation: () => s);
  }

  void setBloodGroup(value) {
    state = state.copyWith(patientBloodGroup: () => value);
  }

  void setWeight(String s) {
    state = state.copyWith(patientWeight: () => s);
  }

  void setHeight(String s) {
    state = state.copyWith(patientHeight: () => s);
  }

  void registerUser({
    required WidgetRef ref,
    required GlobalKey<FormState> form,
    required BuildContext context
  }) async {
    CustomDialogs.loading(message: 'Registering User');
    var user = ref.read(userRegistrationProvider);
    user.userAddress = ref.watch(regAddressProvider).toMap();
    user.userMetaData = state.toMap();
    user.userStatus = 'active';
    user.createdAt = DateTime.now().millisecondsSinceEpoch;
    user.id = RegistrationServices.getId();
    var (message, createdUser) = await RegistrationServices.registerUser(user);
    if (createdUser != null) {
      await RegistrationServices.signOut();
      form.currentState!.reset();
      ref.read(userRegistrationProvider.notifier).reset();
      state = PatientMetaData();
      ref.read(regAddressProvider.notifier).reset();
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: '$message. Please verify your email',
          type: DialogType.success);
          MyRouter(contex: context, ref: ref)
          .navigateToRoute(RouterItem.loginRoute);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: message, type: DialogType.error);
    }
  }
}

final regDoctorMetaDataProvider =
    StateNotifierProvider<RegMetaDoctorDataProvider, DoctorMetaData>((ref) {
  return RegMetaDoctorDataProvider();
});

class RegMetaDoctorDataProvider extends StateNotifier<DoctorMetaData> {
  RegMetaDoctorDataProvider() : super(DoctorMetaData());

  void setExperience(String s) {
    state = state.copyWith(doctorExperience: () => s);
  }

  void setSpeciality(value) {
    state = state.copyWith(doctorSpeciality: () => value);
  }

  void setHospital(String s) {
    state = state.copyWith(hospitalName: () => s);
  }

  void registerUser(
      {required WidgetRef ref, required GlobalKey<FormState> form, required BuildContext context}) async {
    CustomDialogs.loading(message: 'Registering User');
    var user = ref.read(userRegistrationProvider);
    user.userAddress = ref.watch(regAddressProvider).toMap();
    user.userMetaData = state.toMap();
    user.userStatus = 'active';
    user.createdAt = DateTime.now().millisecondsSinceEpoch;
    user.id = RegistrationServices.getId();
    var (message, createdUser) = await RegistrationServices.registerUser(user);
    if (createdUser != null) {
      await RegistrationServices.signOut();
      //clear form
      form.currentState!.reset();
      ref.read(userRegistrationProvider.notifier).reset();
      state = DoctorMetaData();
      ref.read(regAddressProvider.notifier).reset();

      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: '$message. Please verify your email',
          type: DialogType.success);
          MyRouter(contex: context,ref: ref).navigateToRoute(RouterItem.loginRoute);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: message, type: DialogType.error);
    }
  }
}

final regPagesProvider = StateProvider<int>((ref) => 0);
