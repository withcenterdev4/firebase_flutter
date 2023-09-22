import 'package:firebase_flutter/main.dart';
import 'package:firebase_flutter/pages/main.profile.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: MainApp.routeName,
    name: MainApp.routeName,
    pageBuilder: (context, state) => const NoTransitionPage(
        child: MyHomePage(
      title: 'Firebase Demo App',
    )),
  ),
  GoRoute(
    path: ProfileMain.routeName,
    name: ProfileMain.routeName,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: ProfileIcon(),
    ),
  ),
]);
