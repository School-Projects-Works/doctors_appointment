import 'dart:typed_data';

import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/auth/pages/login/data/login_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart';

final loginProvider = StateNotifierProvider<LoginProvider, LoginModel>((ref) {
  return LoginProvider();
});

class LoginProvider extends StateNotifier<LoginModel> {
  LoginProvider() : super(LoginModel(email: '', password: ''));

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void login({required WidgetRef ref, required BuildContext context}) async {
    CustomDialogs.loading(
      message: 'Logging in',
    );
    var (message, user) =
        await RegistrationServices.loginUser(state.email, state.password);
    if (user != null) {
      var userData = await RegistrationServices.getUserData(user.uid);
      if (userData != null) {
        if (userData.userStatus!.toLowerCase() == 'banned') {
          final Storage localStorage = window.localStorage;
          localStorage.remove('user');
          CustomDialogs.dismiss();
          CustomDialogs.toast(
              message: 'You are band from accessing this platform',
              type: DialogType.error);
          return;
        }
        if (user.emailVerified ||
            userData.userRole == 'Admin' ||
            userData.email!.contains('fusekoda')) {
          CustomDialogs.dismiss();
          //get user from database
          //save user data to local storage
          ref.read(userProvider.notifier).setUser(userData);

          // ignore: use_build_context_synchronously
          MyRouter(contex: context, ref: ref)
              .navigateToRoute(RouterItem.homeRoute);
        } else {
          CustomDialogs.dismiss();
          CustomDialogs.showDialog(
              message: 'Email is not verified',
              type: DialogType.info,
              secondBtnText: 'Send Verification',
              onConfirm: () async {
                await user.sendEmailVerification();
                CustomDialogs.dismiss();
              });
        }
      } else {
        CustomDialogs.dismiss();
        CustomDialogs.toast(message: 'User not found', type: DialogType.error);
      }
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: message, type: DialogType.error);
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel>((ref) {
  Storage localStorage = window.localStorage;
  var user = localStorage['user'];
  if (user != null) {
    return UserProvider()..updateUer(UserModel.fromJson(user).id);
  }
  return UserProvider();
});

class UserProvider extends StateNotifier<UserModel> {
  UserProvider() : super(UserModel());

  void setUser(UserModel user) {
    Storage localStorage = window.localStorage;
    localStorage['user'] = user.toJson();
    state = user;
  }

  void logout({required BuildContext context}) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(
      message: 'Logging out',
    );
    await RegistrationServices.signOut();
    state = UserModel();
    CustomDialogs.dismiss();
  }

  updateUer(String? id) async {
    var userData = await RegistrationServices.getUserData(id!);
    if (userData != null) {
      if(userData.userStatus!.toLowerCase() == 'banned'){
        final Storage localStorage = window.localStorage;
        localStorage.remove('user');
        CustomDialogs.toast(
            message: 'You are band from accessing this platform',
            type: DialogType.error);
        return;
      }
      state = userData;
    }
  }
}

final selectedUserImageProvider = StateProvider<Uint8List?>((ref) {
  return null;
});

final udateUserProvider = StateNotifierProvider<UpdateUser, UserModel>((ref) {
  return UpdateUser();
});

class UpdateUser extends StateNotifier<UserModel> {
  UpdateUser() : super(UserModel());

  void setUser(UserModel user) {
    if (state.id == null) {
      state = user;
    }
  }

  void setName(String value) {
    state = state.copyWith(userName: () => value);
  }

  void setGender(String? value) {
    state = state.copyWith(userGender: () => value);
  }

  void setEmail(String s) {
    state = state.copyWith(email: () => s);
  }

  void changeImage(WidgetRef ref) {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        ref.read(selectedUserImageProvider.notifier).state =
            await value.readAsBytes();
      }
    });
  }

  void changeStatus(bool isImagePicked, String status) {
    //activate doctor if he has image and not band
    if (state.userRole == 'Doctor') {
      if ((state.userImage != null || isImagePicked)) {
        state = state.copyWith(userStatus: () => status);
      } else {
        CustomDialogs.toast(
            message: 'Please upload image to proceed', type: DialogType.error);
      }
    }
  }

  void setSpecialization(String value) {
    var metadata = DoctorMetaData.fromMap(state.userMetaData!);
    metadata.doctorSpeciality = value;
    state = state.copyWith(userMetaData: () => metadata.toMap());
  }

  void setYearOfExperience(String? value) {
    var metadata = DoctorMetaData.fromMap(state.userMetaData!);
    metadata.doctorExperience = value;
    state = state.copyWith(userMetaData: () => metadata.toMap());
  }

  void setHospital(String? value) {
    var metadata = DoctorMetaData.fromMap(state.userMetaData!);
    metadata.hospitalName = value;
    state = state.copyWith(userMetaData: () => metadata.toMap());
  }

  void setBloodGroup(String? value) {
    var metadata = PatientMetaData.fromMap(state.userMetaData!);
    metadata.patientBloodGroup = value;
    state = state.copyWith(userMetaData: () => metadata.toMap());
  }

  void setWeight(String? value) {
    var metadata = PatientMetaData.fromMap(state.userMetaData!);
    metadata.patientWeight = value;
    state = state.copyWith(userMetaData: () => metadata.toMap());
  }

  void setHeight(String? value) {
    var metadata = PatientMetaData.fromMap(state.userMetaData!);
    metadata.patientHeight = value;
    state = state.copyWith(userMetaData: () => metadata.toMap());
  }

  void updateUser(
      {required BuildContext context, required WidgetRef ref}) async {
    CustomDialogs.dismiss();
    CustomDialogs.dismiss();
    CustomDialogs.loading(
      message: 'Updating user',
    );
    //upload image if image is selected
    var image = ref.watch(selectedUserImageProvider);
    if (image != null) {
      var url = await RegistrationServices.uploadImage(image);
      if (url.isNotEmpty) {
        state = state.copyWith(userImage: () => url);
        ref.read(selectedUserImageProvider.notifier).state = null;
      } else {
        CustomDialogs.toast(
            message: 'Image upload failed', type: DialogType.error);
        return;
      }
    }
    //update user
    var result = await RegistrationServices.updateUser(state);
    if (result) {
      //save user data to local storage
      // Storage localStorage = window.localStorage;
      // localStorage['user'] = state.toJson();
      ref.read(userProvider.notifier).setUser(state);
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'User updated successfully', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'User update failed', type: DialogType.error);
    }
  }
}
