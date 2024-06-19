import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/dashboard/views/components/side_bar.dart';
import 'package:doctors_appointment/features/main/views/components/app_bar_item.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMain extends ConsumerWidget {
  const DashboardMain(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: Colors.white),
              ),
              const SizedBox(width: 10),
              PopupMenuButton(
                  color: primaryColor,
                  offset: const Offset(0, 70),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    backgroundImage: () {
                      var user = ref.watch(userProvider);
                      if (user.userImage == null) {
                        return AssetImage(
                          user.userGender == 'Male'
                              ? Assets.imagesMale
                              : user.userRole == 'Admin'
                                  ? Assets.imagesAdmin
                                  : Assets.imagesFemale,
                        );
                      } else {
                        NetworkImage(user.userImage!);
                      }
                    }(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.logout,
                            title: 'Home Page',
                            onTap: () {
                              MyRouter(contex: context, ref: ref)
                                  .navigateToRoute(RouterItem.homeRoute);
                            }),
                      ),
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.logout,
                            title: 'Logout',
                            onTap: () {
                              CustomDialogs.showDialog(
                                message: 'Are you sure you want to logout?',
                                type: DialogType.info,
                                secondBtnText: 'Logout',
                                onConfirm: () {
                                  ref
                                      .read(userProvider.notifier)
                                      .logout(context: context);
                                },
                              );
                            }),
                      ),
                    ];
                  }),
              const SizedBox(width: 10),
            ],
            title: Row(
              children: [
                Image.asset(
                  Assets.imagesLogoColor,
                  height: 40,
                ),
                const SizedBox(width: 10),
                if (styles.smallerThanTablet)
                  //manu button
                  PopupMenuButton(
                      offset: const Offset(0, 70),
                      itemBuilder: (context) {
                        return [];
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
              ],
            ),
          ),
          body: styles.smallerThanTablet
              ? child
              : Row(
                  children: [
                    const SideBar(),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                            color: Colors.grey[100],
                            padding: const EdgeInsets.all(10),
                            child: child)),
                  ],
                )),
    );
  }
}
