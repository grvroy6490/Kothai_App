

import 'package:flutter/material.dart';

class Authbanner extends StatelessWidget {
  const Authbanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/auth_bg.png',
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 6,
          right: 10,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 227, 228, 228),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Color.fromARGB(255, 107, 114, 128)),
            ),
          ),
        ),
      ],
    );
  }
}