import 'package:minor_proj/edit_details.dart';
import 'package:minor_proj/Screen1.dart';
import 'package:minor_proj/views/navbar/add_complaint_screen.dart';
import 'package:minor_proj/views/navbar/menu_additems.dart';
import 'package:minor_proj/views/new_announcement_screen.dart';
import 'package:minor_proj/postscreen.dart';
import 'package:minor_proj/splashscreen.dart';
import 'package:minor_proj/views/one_time_user.dart';
import 'package:flutter/material.dart';
import 'package:minor_proj/views/mail_authentication/login.dart';
import 'package:minor_proj/views/mail_authentication/signup_screen.dart';
import 'routes_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case RoutesName.signUp:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignUpScreen());
      case RoutesName.editScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => EditScreen());
      case RoutesName.post:
        if (arguments is int) {
          return MaterialPageRoute(
              builder: (BuildContext context) => PostScreen(
                    currentIndex: arguments,
                  ));
        } else {
          return MaterialPageRoute(builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          });
        }
      case RoutesName.oneTime:
        return MaterialPageRoute(
            builder: (BuildContext context) => UserOneTimeDetailScreen());
      case RoutesName.addAnnounce:
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateAnnouncementScreen());
      case RoutesName.addComplain:
        return MaterialPageRoute(
            builder: (BuildContext context) => AddComplain());
      case RoutesName.mMenu:
        return MaterialPageRoute(
            builder: (BuildContext context) => AddMessMenu());
      case RoutesName.firstScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => FirstScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
