


import 'package:get/get.dart';
import 'package:kothai_app/app/app.dart';
import 'package:kothai_app/core/errors/default_404.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/challenge/challenge_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/session/complete/session_complete_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/practice_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/randomize/practice_randomize_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/session/stop/session_stop_page.dart';
import 'package:kothai_app/features/user_profile/presentation/pages/profile_page.dart';


List<GetPage<dynamic>> routes = [
    GetPage(
        name: '/',
        page: () => App()
    ),
    GetPage(
        name: '/practice',
        page: () => PracticePage(),
        children: [
            GetPage(
                name: '/randomize', // full path => /practice/editor
                page: () => PracticeRandomizePage()
            ),
            GetPage(
                name: '/complete', // full path => /practice/editor
                page: () => SessionCompletePage()
            ),
            GetPage(
                name: '/stop', // full path => /practice/editor
                page: () => SessionStopPage()
            )
        ]
    ),
    GetPage(
        name: '/challenge',
        page: () => ChallengePage()
    ),
    GetPage(
        name: '/profile',
        page: () => ProfilePage()
    ),
    GetPage(
        name: '/error',
        page: () => Default404(error: 'Page Not Found!',)
    )
];


