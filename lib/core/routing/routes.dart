


import 'package:get/get.dart';
import 'package:kothai_app/app/app.dart';
import 'package:kothai_app/core/errors/default_404.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/practice_page.dart';
import 'package:kothai_app/features/user_profile/presentation/pages/profile_page.dart';

List<GetPage<dynamic>> routes = [
    GetPage(
        name: '/',
        page: () => App()
    ),
    GetPage(
        name: '/practice',
        page: () => PracticePage()
    ),
    GetPage(
        name: '/profile',
        page: () => ProfilePage()
    ),
    GetPage(
        name: '/error',
        page: () => Default404()
    )
];


