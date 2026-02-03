import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/authentication/presentation/providers/auth_service_provider.dart';
import 'package:kothai_app/features/share/presentation/pages/share_page.dart';

/// Compact app bar and a ready-to-use list of action widgets.
class AppBarCompact extends ConsumerWidget implements PreferredSizeWidget {
    final String title;
    final VoidCallback? onBack;
    final List<Widget>? extraActions;
    final bool leading;

    const AppBarCompact({
        super.key,
        this.title = '',
        this.onBack,
        this.extraActions,
        this.leading = false
    });

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);

    @override
    Widget build(BuildContext context, WidgetRef ref) {

        // 🌐 PROVIDERS ------------------------------
        final auth = ref.watch(authUserProvider);

        return AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
            automaticallyImplyLeading: false,
            titleSpacing: leading ? 5.0 : 15.0,
            leadingWidth: 40.0,
            leading: leading ? IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30),
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    tooltip: 'Back'
                ) : null,
            title: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                )
            ),
            centerTitle: false,
            elevation: 1,
            actions: [
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                    // keep the larger of the two children visible width-wise
                    layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                            alignment: Alignment.centerRight,
                            children: [
                                ...previousChildren,
                                if (currentChild != null) currentChild
                            ]
                        );
                    },
                    child:  auth.value?.email != null // TODO: update auth
                        ?  IconButton(
                            onPressed: (){
                            },
                            icon: Icon(Icons.cloud_upload_rounded),
                            style: ButtonStyle(
                                iconColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/On Surface')),
                                backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'State Layers/On Surface/Opacity-08'))
                            )
                        )

                        : IconButton(
                            onPressed: (){
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                    return Center(
                                        child: Material(
                                            type: MaterialType.transparency,
                                            child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: SharePage()
                                            ),
                                        ),
                                    );
                                },
                            );
                            },
                            icon: Icon(Icons.share),
                            style: ButtonStyle(
                                iconColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/On Surface')),
                                backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'State Layers/On Surface/Opacity-08'))
                            )
                        )
                ),

                SizedBox(width: 5),
                IconButton(
                    padding: const EdgeInsets.all(11),
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                        ),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                        )
                    ),
                    onPressed: (){
                    },
                    icon: Icon(
                        FontAwesomeIcons.bell,
                        size: KxScale(context).sp(18),
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                SizedBox(width: 15)

            ]
        );
    }
}

