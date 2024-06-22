import 'package:doctors_appointment/config/router.dart';
import 'package:doctors_appointment/config/routes/router_item.dart';
import 'package:doctors_appointment/core/views/custom_dialog.dart';
import 'package:doctors_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:doctors_appointment/features/main/views/components/app_bar_item.dart';
import 'package:doctors_appointment/generated/assets.dart';
import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    return Container(
      width: double.infinity,
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Logo
          Image.asset(Assets.imagesLogoColor, height: 45),
          const SizedBox(width: 20),
          if (styles.smallerThanTablet) const Spacer(),
          // Hamburger
          if (styles.smallerThanTablet)
            PopupMenuButton(
              color: primaryColor,
              offset: const Offset(0, 70),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: BarItem(
                      padding: const EdgeInsets.only(
                          right: 40, top: 10, bottom: 10, left: 10),
                      title: 'Home',
                      onTap: () {
                        MyRouter(ref: ref, contex: context)
                            .navigateToRoute(RouterItem.homeRoute);
                            Navigator.of(context).pop();
                      },
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.homeRoute.name,
                      icon: Icons.home),
                ),
                PopupMenuItem(
                  child: BarItem(
                      padding: const EdgeInsets.only(
                          right: 40, top: 10, bottom: 10, left: 10),
                      title: 'About',
                      onTap: () {
                        MyRouter(ref: ref, contex: context)
                            .navigateToRoute(RouterItem.aboutRoute);
                            Navigator.of(context).pop();
                      },
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.aboutRoute.name,
                      icon: Icons.info),
                ),
                PopupMenuItem(
                  child: BarItem(
                      padding: const EdgeInsets.only(
                          right: 40, top: 10, bottom: 10, left: 10),
                      title: 'Contact',
                      onTap: () {
                        MyRouter(ref: ref, contex: context)
                            .navigateToRoute(RouterItem.contactRoute);
                            Navigator.of(context).pop();
                      },
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.contactRoute.name,
                      icon: Icons.contact_mail),
                ),
                if (ref.watch(userProvider).id == null)
                  PopupMenuItem(
                    child: BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Login',
                        onTap: () {
                          MyRouter(ref: ref, contex: context)
                              .navigateToRoute(RouterItem.loginRoute);
                              Navigator.of(context).pop();
                        },
                        isActive: ref.watch(routerProvider) ==
                            RouterItem.loginRoute.name,
                        icon: Icons.login),
                  ),
                if (ref.watch(userProvider).id != null)
                  PopupMenuItem(
                    child: BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Dashboard',
                        onTap: () {
                          MyRouter(ref: ref, contex: context)
                              .navigateToRoute(RouterItem.dashboardRoute);
                              Navigator.of(context).pop();
                        },
                        isActive: ref.watch(routerProvider) ==
                            RouterItem.dashboardRoute.name,
                        icon: Icons.dashboard),
                  ),
                if (ref.watch(userProvider).id != null)
                  PopupMenuItem(
                    child: BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Logout',
                        onTap: () {
                          CustomDialogs.showDialog(
                            message: 'Are you sure you want to logout?',
                            type: DialogType.info,
                            secondBtnText: 'Logout',
                            onConfirm: () {
                              ref.read(userProvider.notifier).logout(
                                    context: context,
                                  );
                                  //close popup
                                  Navigator.of(context).pop();
                            },
                          );
                        },
                        icon: Icons.logout),
                  ),
              ],
              icon: const Icon(Icons.menu, color: Colors.white),
            )
          else
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BarItem(
                  title: 'Home',
                  onTap: () {
                    MyRouter(ref: ref, contex: context)
                        .navigateToRoute(RouterItem.homeRoute);
                  },
                  isActive:
                      ref.watch(routerProvider) == RouterItem.homeRoute.name,
                ),
                const SizedBox(width: 20),
                BarItem(
                  title: 'About',
                  onTap: () {
                    MyRouter(ref: ref, contex: context)
                        .navigateToRoute(RouterItem.aboutRoute);
                  },
                  isActive:
                      ref.watch(routerProvider) == RouterItem.aboutRoute.name,
                ),
                const SizedBox(width: 20),
                BarItem(
                  title: 'Contact',
                  onTap: () {
                    MyRouter(ref: ref, contex: context)
                        .navigateToRoute(RouterItem.contactRoute);
                  },
                  isActive:
                      ref.watch(routerProvider) == RouterItem.contactRoute.name,
                ),
                //login
                const SizedBox(width: 20),
                ref.watch(userProvider).id == null
                    ? BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Login',
                        onTap: () {
                          MyRouter(ref: ref, contex: context)
                              .navigateToRoute(RouterItem.loginRoute);
                        },
                        isActive: ref.watch(routerProvider) ==
                            RouterItem.loginRoute.name,
                      )
                    : PopupMenuButton(
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
                              NetworkImage(
                                user.userImage!,
                                scale: 0.1,
                              );
                            }
                          }(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ref.watch(userProvider).userImage != null
                                ? Image.network(
                                    ref.watch(userProvider).userImage!)
                                : null,
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            //dashboard
                            PopupMenuItem(
                              child: BarItem(
                                padding: const EdgeInsets.only(
                                    right: 40, top: 10, bottom: 10, left: 10),
                                title: 'Dashboard',
                                icon: Icons.dashboard,
                                onTap: () {
                                  MyRouter(ref: ref, contex: context)
                                      .navigateToRoute(
                                          RouterItem.dashboardRoute);
                                          Navigator.of(context).pop();
                                },
                                isActive: ref.watch(routerProvider) ==
                                    RouterItem.dashboardRoute.name,
                              ),
                            ),

                            PopupMenuItem(
                              child: BarItem(
                                  padding: const EdgeInsets.only(
                                      right: 40, top: 10, bottom: 10, left: 10),
                                  icon: Icons.logout,
                                  title: 'Logout',
                                  onTap: () {
                                    CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to logout?',
                                      type: DialogType.info,
                                      secondBtnText: 'Logout',
                                      onConfirm: () {
                                        ref
                                            .read(userProvider.notifier)
                                            .logout(context: context);
                                            Navigator.of(context).pop();
                                      },
                                    );
                                  }),
                            ),
                          ];
                        })
                //register
              ],
            ))
          // Nav items
        ],
      ),
    );
  }
}
