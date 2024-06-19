class RouterItem {
  String path;
  String name;
  bool allowAccess;

  RouterItem({
    required this.path,
    required this.name,
    this.allowAccess = true,
  });

  static RouterItem homeRoute = RouterItem(path: '/home', name: 'home');
  static RouterItem loginRoute = RouterItem(path: '/login', name: 'login');
  static RouterItem registerRoute =
      RouterItem(path: '/register', name: 'register');

  static RouterItem forgotPasswordRoute = RouterItem(
      path: '/forgot-password', name: 'forgot-password', allowAccess: false);
  static RouterItem settingsRoute =
      RouterItem(path: '/settings', name: 'settings', allowAccess: false);
static RouterItem newAppointmentRoute = RouterItem(
      path: '/appointment', name: 'appointment', allowAccess: false);
  static RouterItem aboutRoute = RouterItem(path: '/about', name: 'about');
  static RouterItem contactRoute =
      RouterItem(path: '/contact', name: 'contact');
  static RouterItem dashboardRoute =
      RouterItem(path: '/dashboard', name: 'dashboard', allowAccess: false);
  static RouterItem profileRoute =
      RouterItem(path: '/profile', name: 'profile', allowAccess: false);
  static RouterItem doctorsRoute =
      RouterItem(path: '/admin/doctors', name: 'doctors', allowAccess: false);
  static RouterItem patientsRoute =
      RouterItem(path: '/admin/patients', name: 'patients', allowAccess: false);
  static RouterItem appointmentsRoute = RouterItem(
      path: '/admin/appointments', name: 'appointments', allowAccess: false);

  static List<RouterItem> get allRoutes => [
        homeRoute,
        loginRoute,
        registerRoute,
        profileRoute,
        settingsRoute,
        aboutRoute,
        contactRoute,
        dashboardRoute
      ];

  static RouterItem getRouteByPath(String fullPath) {
    return allRoutes.firstWhere((element) => element.path == fullPath);
  }
}
