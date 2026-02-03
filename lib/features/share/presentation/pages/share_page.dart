import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cross_file/cross_file.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/level_xp_indicator.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/stats_card.dart';
import 'package:kothai_app/features/user_profile/presentation/riverpod/providers/user_stats_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:kothai_app/features/authentication/presentation/providers/auth_service_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SharePage extends ConsumerStatefulWidget {
    const SharePage({super.key});

    @override
    ConsumerState<SharePage> createState() => _SharePageState();
}

class _SharePageState extends ConsumerState<SharePage> {
    final ScreenshotController _screenshotController = ScreenshotController();

    // Helper method to get username from auth user
    String _getUsername(User? user) {
        if (user == null) {
            return 'Guest User';
        }
        // Use displayName if available, otherwise use email username, otherwise fallback
        final displayName = user.displayName?.trim();
        if (displayName != null && displayName.isNotEmpty) {
            return displayName;
        }
        // Fallback to email username (part before @)
        final email = user.email;
        if (email != null && email.isNotEmpty) {
            return email.split('@').first;
        }
        return 'User';
    }

    // Download screenshot to gallery
    Future<void> _downloadScreenshot() async {
        try {
            // Check and request storage permission based on Android version
            PermissionStatus status;

            // For Android 13+ (API 33+), use photos permission
            // For older versions, use storage permission
            if (Platform.isAndroid) {
                // Try photos permission first (Android 13+)
                status = await Permission.photos.status;
                if (!status.isGranted) {
                    status = await Permission.photos.request();
                }

                // If photos permission is not available or denied, try storage (Android < 13)
                if (!status.isGranted) {
                    status = await Permission.storage.status;
                    if (!status.isGranted) {
                        status = await Permission.storage.request();
                    }
                }
            } else {
                // For iOS, use photos library permission
                status = await Permission.photos.status;
                if (!status.isGranted) {
                    status = await Permission.photos.request();
                }
            }

            // Handle permission denial
            if (!status.isGranted) {
                if (status.isPermanentlyDenied) {
                    // Show dialog to open settings
                    if (mounted) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text('Permission Required'),
                                content: Text(
                                    'Storage permission is required to save images. Please enable it in app settings.'
                                ),
                                actions: [
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('Cancel')
                                    ),
                                    TextButton(
                                        onPressed: () {
                                            Navigator.of(context).pop();
                                            openAppSettings();
                                        },
                                        child: Text('Open Settings')
                                    )
                                ]
                            )
                        );
                    }
                } else {
                    Fluttertoast.showToast(
                        msg: 'Storage permission is required to save images',
                        toastLength: Toast.LENGTH_SHORT
                    );
                }
                return;
            }

            // Show loading indicator
            if (mounted) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: CircularProgressIndicator())
                );
            }

            final image = await _screenshotController.capture();

            // Close loading indicator
            if (mounted) {
                Navigator.of(context).pop();
            }

            if (image == null) {
                Fluttertoast.showToast(
                    msg: 'Failed to capture screenshot',
                    toastLength: Toast.LENGTH_SHORT
                );
                return;
            }

            // Get external storage directory (Pictures folder)
            final directory = await getExternalStorageDirectory();
            if (directory == null) {
                Fluttertoast.showToast(
                    msg: 'Unable to access storage',
                    toastLength: Toast.LENGTH_SHORT
                );
                return;
            }

            // Create Pictures/Kothai directory if it doesn't exist
            final picturesDir = Directory('${directory.path}/../Pictures/Kothai');
            if (!await picturesDir.exists()) {
                await picturesDir.create(recursive: true);
            }

            // Save the image
            final fileName =
                'kothai_share_${DateTime.now().millisecondsSinceEpoch}.png';
            final file = File('${picturesDir.path}/$fileName');
            await file.writeAsBytes(image);

            Fluttertoast.showToast(
                msg: 'Image saved to Pictures/Kothai folder!',
                toastLength: Toast.LENGTH_SHORT
            );
        } catch (e) {
            // Close loading indicator if still open
            if (mounted) {
                try {
                    Navigator.of(context).pop();
                } catch (_) {
                }
            }
            Fluttertoast.showToast(
                msg: 'Error: ${e.toString()}',
                toastLength: Toast.LENGTH_SHORT
            );
        }
    }

    // Share screenshot
    Future<void> _shareScreenshot() async {
        try {
            final image = await _screenshotController.capture();
            if (image == null) {
                Fluttertoast.showToast(
                    msg: 'Failed to capture screenshot',
                    toastLength: Toast.LENGTH_SHORT
                );
                return;
            }

            // Save to temporary directory
            final tempDir = await getTemporaryDirectory();
            final file = File(
                '${tempDir.path}/kothai_share_${DateTime.now().millisecondsSinceEpoch}.png'
            );
            await file.writeAsBytes(image);

            // Share the file
            await Share.shareXFiles(
                [XFile(file.path)],
                text: 'Check out my Tamil typing progress on Kothai!',
                subject: 'My Kothai Progress'
            );
        } catch (e) {
            Fluttertoast.showToast(
                msg: 'Error sharing: ${e.toString()}',
                toastLength: Toast.LENGTH_SHORT
            );
        }
    }

    // Build the shareable content (without buttons)
    Widget _buildShareableContent(BuildContext context) {
        // Get providers
        final authUserAsync = ref.watch(authUserProvider);
        final statsAsync = ref.watch(userStatsProvider);
        final streakState = ref.watch(streakControllerProvider);

        return Container(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                        padding: EdgeInsets.all(Gap(context).gap(16)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Text(
                                    'Unlock your Tamil typing mastery with Kothai!',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface'),
                                        fontWeight: FontWeight.w800
                                    )
                                ),

                                SizedBox(height: 10),

                                Text(
                                    "Here's my progress so far:",
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                    )
                                )
                            ]
                        )
                    ),

                    SizedBox(height: 10),

                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Gap(context).gap(16)),
                        decoration: BoxDecoration(
                            color: getFigmaColor(context, 'Schemes/On Primary'),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        child: Column(
                            children: [
                                Row(
                                    children: [
                                        Expanded(
                                            child: authUserAsync.when(
                                                data: (user) => Text(
                                                    _getUsername(user),
                                                    style: Theme.of(context).textTheme.titleMedium
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/Primary'
                                                            )
                                                        )
                                                ),
                                                loading: () => Text(
                                                    'Loading...',
                                                    style: Theme.of(context).textTheme.titleMedium
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/Primary'
                                                            )
                                                        )
                                                ),
                                                error: (_, __) => Text(
                                                    'User',
                                                    style: Theme.of(context).textTheme.titleMedium
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/Primary'
                                                            )
                                                        )
                                                )
                                            )
                                        ),

                                        LevelXPIndicatior(isCompact: true)
                                    ]
                                ),

                                SizedBox(height: 15),

                                statsAsync.when(
                                    data: (stats) => Container(
                                        decoration: BoxDecoration(
                                            color: getFigmaColor(
                                                context,
                                                'Schemes/Surface Container Lowest'
                                            ),
                                            borderRadius: BorderRadius.circular(16)
                                        ),
                                        child: Row(
                                            children: [
                                                Expanded(
                                                    child: StatCard(
                                                        value: stats.bestWpm.toStringAsFixed(0),
                                                        label: 'Best WPM',
                                                        icon: Icons.bolt
                                                    )
                                                ),

                                                Container(
                                                    width: 2,
                                                    color: getFigmaColor(context, 'Schemes/On Primary'),
                                                    height: 100
                                                ),

                                                Expanded(
                                                    child: StatCard(
                                                        value: '${stats.bestAccuracy.toStringAsFixed(1)}%',
                                                        label: 'Best Accuracy',
                                                        icon: Icons.gps_fixed
                                                    )
                                                ),

                                                Container(
                                                    width: 2,
                                                    color: getFigmaColor(context, 'Schemes/On Primary'),
                                                    height: 100
                                                ),

                                                Expanded(
                                                    child: StatCard(
                                                        value: stats.achievements.toString().padLeft(
                                                            2,
                                                            '0'
                                                        ),
                                                        label: 'Achievements',
                                                        icon: Icons.military_tech
                                                    )
                                                )
                                            ]
                                        )
                                    ),
                                    loading: () => Container(
                                        padding: EdgeInsets.all(20),
                                        child: Center(child: CircularProgressIndicator())
                                    ),
                                    error: (error, stack) => Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                            'Unable to load stats',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: getFigmaColor(
                                                    context,
                                                    'Schemes/On Surface Variant'
                                                )
                                            )
                                        )
                                    )
                                ),

                                SizedBox(height: 15),

                                statsAsync.when(
                                    data: (stats) => Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(Gap(context).gap(16)),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('assets/images/streak_board.png'),
                                                fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(16)
                                        ),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Gap(context).gap(12),
                                                        vertical: Gap(context).gap(8)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(35),
                                                        border: Border.all(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Fixed/Secondary Fixed'
                                                            ),
                                                            width: 2
                                                        ),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/streak_board.png'
                                                            ),
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            SizedBox(width: Gap(context).gap(10)),
                                                            Text(
                                                                stats.challengesCompleted.toString(),
                                                                style: Theme.of(context).textTheme.headlineLarge
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        ),
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                            ),
                                                            SizedBox(width: Gap(context).gap(10)),
                                                            Text(
                                                                'Challenges\nCompleted',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                style: Theme.of(context).textTheme.labelMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        ),
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                            )
                                                        ]
                                                    )
                                                ),
                                                SizedBox(height: 15),

                                                Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Gap(context).gap(12),
                                                        vertical: Gap(context).gap(8)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(35),
                                                        border: Border.all(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Fixed/Secondary Fixed'
                                                            ),
                                                            width: 2
                                                        ),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/streak_board.png'
                                                            ),
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            SizedBox(width: Gap(context).gap(10)),
                                                            Text(
                                                                stats.practiceSessions.toString(),
                                                                style: Theme.of(context).textTheme.headlineLarge
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        ),
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                            ),
                                                            SizedBox(width: Gap(context).gap(10)),
                                                            Text(
                                                                'Practice\nSessions',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                style: Theme.of(context).textTheme.labelMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        ),
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                            )
                                                        ]
                                                    )
                                                ),

                                                SizedBox(height: 15),

                                                Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Gap(context).gap(12),
                                                        vertical: Gap(context).gap(8)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(35),
                                                        border: Border.all(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Fixed/Secondary Fixed'
                                                            ),
                                                            width: 2
                                                        ),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/streak_board.png'
                                                            ),
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            SizedBox(width: Gap(context).gap(10)),
                                                            Text(
                                                                streakState.current.toString(),
                                                                style: Theme.of(context).textTheme.headlineLarge
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        ),
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                            ),
                                                            SizedBox(width: Gap(context).gap(10)),
                                                            Text(
                                                                'Day\nStreak',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                style: Theme.of(context).textTheme.labelMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        ),
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                            )
                                                        ]
                                                    )
                                                )
                                            ]
                                        )
                                    ),
                                    loading: () => Container(
                                        padding: EdgeInsets.all(20),
                                        child: Center(child: CircularProgressIndicator())
                                    ),
                                    error: (error, stack) => Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                            'Unable to load stats',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: getFigmaColor(
                                                    context,
                                                    'Schemes/On Surface Variant'
                                                )
                                            )
                                        )
                                    )
                                )
                            ]
                        )
                    ),

                    SizedBox(height: 10),

                    Container(
                        padding: EdgeInsets.all(Gap(context).gap(12)),
                        decoration: BoxDecoration(
                            color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: Row(
                            children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                                'Start your journey in Tamil typing excellence today.',
                                                style: Theme.of(
                                                    context
                                                ).textTheme.bodyMedium?.copyWith(color: Colors.black)
                                            ),

                                            SizedBox(height: 7),

                                            Opacity(
                                                opacity: 0.8,
                                                child: Text(
                                                    'Download Kothai – Tamil Typing Master',
                                                    style: Theme.of(
                                                        context
                                                    ).textTheme.bodySmall?.copyWith(color: Colors.black)
                                                )
                                            )
                                        ]
                                    )
                                ),

                                Image.asset(
                                    'assets/images/Kothai_logo.png',
                                    width: Gap(context).gap(50),
                                    height: Gap(context).gap(50)
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Screenshot(
                        controller: _screenshotController,
                        child: _buildShareableContent(context)
                    ),
                    SizedBox(height: 15),
                    Container(
                        padding: EdgeInsets.all(Gap(context).gap(12)),
                        decoration: BoxDecoration(
                            color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: Row(
                            children: [
                                Expanded(
                                    child: _customIconButton(
                                        context,
                                        Icon(
                                            Icons.download,
                                            color: getFigmaColor(context, 'Schemes/On Secondary')
                                        ),
                                        'Download',
                                        _downloadScreenshot,
                                        Gap(context).gap(12),
                                        getFigmaColor(context, 'Schemes/Secondary')
                                    )
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: _customIconButton(
                                        context,
                                        Icon(
                                            Icons.share,
                                            color: getFigmaColor(context, 'Schemes/On Secondary')
                                        ),
                                        'Share Now',
                                        _shareScreenshot,
                                        Gap(context).gap(12),
                                        getFigmaColor(context, 'Schemes/Primary')
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    Widget _customIconButton(
        BuildContext context,
        Widget icon,
        String text,
        VoidCallback handlePress,
        double padding,
        Color? bgColor
    ) {
        return TextButton.icon(
            label: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: getFigmaColor(context, 'Schemes/On Green')
                )
            ),
            onPressed: () => handlePress(),
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    bgColor ??
                        getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                ),
                padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(
                        horizontal: Gap(context).gap(padding + 4),
                        vertical: Gap(context).gap(padding)
                    )
                ),
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide.none
                    )
                )
            ),
            icon: icon
        );
    }
}
