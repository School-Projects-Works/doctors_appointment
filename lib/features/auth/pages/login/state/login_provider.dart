import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/auth/pages/login/data/login_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        if (user.emailVerified || userData.userRole == 'Admin') {
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
  
  updateUer(String? id) async{
    var userData = await RegistrationServices.getUserData(id!);
    if(userData!=null){
      state = userData;
    }
  }
}
