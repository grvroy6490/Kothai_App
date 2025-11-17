
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/domain/usecases/show_modal.dart';
import 'package:kothai_app/features/authentication/presentation/pages/login.dart';
import 'package:kothai_app/features/authentication/presentation/pages/signup.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/level_xp_indicator.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/user_score.dart';

class UserDetailWidet extends ConsumerStatefulWidget {
    final AsyncValue<User?> auth;
    const UserDetailWidet({super.key, required this.auth});

    @override
    ConsumerState<UserDetailWidet> createState() => _UserDetailWidetState();
}

class _UserDetailWidetState extends ConsumerState<UserDetailWidet> {
    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(top: Gap(context).gap(10), left: Gap(context).gap(0), right: Gap(context).gap(0), bottom: Gap(context).gap(0)),
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                borderRadius: BorderRadius.circular(24)
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: Row(
                                        children: [
                                            CircleAvatar(
                                                backgroundColor: getFigmaColor(context, 'Schemes/Primary'),
                                                radius: 25,
                                                foregroundColor: getFigmaColor(context, 'Schemes/On Primary Container'),

                                                child: widget.auth.value?.photoURL != null ? ClipOval(
                                                        child: Image.network(
                                                            widget.auth.value!.photoURL!,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) {
                                                                final u = widget.auth.value;
                                                                final name = u?.displayName?.trim();
                                                                String initials;
                                                                if (name != null && name.isNotEmpty) {
                                                                    final parts = name.split(RegExp(r'\s+'));
                                                                    initials = parts.where((e) => e.isNotEmpty).take(2).map((e) => e[0]).join().toUpperCase();
                                                                } else {
                                                                    final email = u?.email;
                                                                    initials = (email != null && email.isNotEmpty)
                                                                        ? email[0].toUpperCase()
                                                                        : 'GU';
                                                                }
                                                                return Text(
                                                                    initials,
                                                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                        color: getFigmaColor(context, 'Schemes/On Primary Container')
                                                                    )
                                                                );
                                                            },
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                if (loadingProgress == null) {
                                                                    return child;
                                                                }
                                                                return CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                                        : null,
                                                                    color: getFigmaColor(context, 'Schemes/On Primary Container')
                                                                );
                                                            }
                                                        )
                                                    )
                                                    :
                                                    Text(() {
                                                            final u = widget.auth.value;
                                                            final name = u?.displayName?.trim();
                                                            if (name != null && name.isNotEmpty) {
                                                                final parts = name.split(RegExp(r'\s+'));
                                                                final firstTwo = parts.where((e) => e.isNotEmpty).take(2).map((e) => e[0]).join();
                                                                return firstTwo.toUpperCase();
                                                            }
                                                            final email = u?.email;
                                                            if (email != null && email.isNotEmpty) {
                                                                return email[0].toUpperCase();
                                                            }
                                                            return 'GU';
                                                        }(),
                                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            color: getFigmaColor(context, 'Schemes/On Primary Container')
                                                        )
                                                    )
                                            ),

                                            SizedBox(width: Gap(context).gap(10)),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text(widget.auth.hasValue && widget.auth.value?.displayName != null ?  widget.auth.value!.displayName.toString() : 'Guest User',
                                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                color: getFigmaColor(context, 'Schemes/On Surface')
                                                            )
                                                        ),

                                                        Text(widget.auth.hasValue && widget.auth.value?.email != null ? widget.auth.value!.email.toString() : 'Login or Signup to save your progress',
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                            )
                                                        )
                                                    ]
                                                )
                                            )
                                        ]
                                    )
                                ),

                                SizedBox(width: Gap(context).gap(15)),

                                PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert, color: getFigmaColor(context, 'Schemes/On Surface Variant')),
                                    onSelected: (String result) async {
                                        // Handle the selection
                                        switch (result) {
                                            case 'Login':
                                                showAppModalWithChild(
                                                    context: context,
                                                    child: LoginPage(),
                                                    heightFactor: 0.65
                                                );
                                                break;

                                            case 'Signup':
                                                showAppModalWithChild(
                                                    context: context,
                                                    child: SignupPage(),
                                                    heightFactor: 0.8
                                                );
                                                break;

                                            case 'Logout':
                                                // Sign out current user
                                                await FirebaseAuth.instance.signOut();
                                                if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                            content: Text('Logged out'),
                                                            behavior: SnackBarBehavior.floating
                                                        )
                                                    );
                                                }
                                                break;
                                        }
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                        //if (auth.value == null) ...const [
                                        if (widget.auth.value == null) ...const [
                                            PopupMenuItem<String>(
                                                value: 'Login',
                                                child: Text('Login')
                                            ),
                                            PopupMenuItem<String>(
                                                value: 'Signup',
                                                child: Text('Signup')
                                            )
                                        ] else ...const [
                                            PopupMenuItem<String>(
                                                value: 'Logout',
                                                child: Text('Logout')
                                            )
                                        ]
                                    ]
                                )
                            ]
                        )
                    ),

                    SizedBox(height: Gap(context).gap(20)),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(0)),
                        child: LevelXPIndicatior(
                            width: double.infinity,
                            isCompact: false
                        )
                    ),

                    SizedBox(height: Gap(context).gap(20)),

                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: UserScore()
                    )
                ]
            )
        );
    }
}
