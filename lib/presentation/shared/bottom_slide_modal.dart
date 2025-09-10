import 'package:flutter/material.dart';

class BottomSlideModal extends StatelessWidget {
  final Widget child;
  final double? height;
  final bool isDismissible;
  final Color? backgroundColor;

  const BottomSlideModal({
    super.key,
    required this.child,
    this.height,
    this.isDismissible = true,
    this.backgroundColor,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
    bool isDismissible = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSlideModal(
        height: height,
        isDismissible: isDismissible,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}

//
// // Example usage widget
// class ExampleModalContent extends StatelessWidget {
//     const ExampleModalContent({super.key});
//
//     @override
//     Widget build(BuildContext context) {
//         return Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                     // Handle bar
//                     Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(2),
//                         ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Modal content
//                     const Text(
//                         'Bottom Slide Modal',
//                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//
//                     const Text(
//                         'This modal slides in from the bottom with a smooth animation.',
//                         textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Close button
//                     ElevatedButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: const Text('Close'),
//                     ),
//                 ],
//             ),
//         );
//     }
// }
