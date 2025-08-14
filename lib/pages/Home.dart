import 'package:flutter/material.dart';
import 'package:kothai_app/services/firebase/firebase_auth_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello User!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuthService().signOut();
                  Navigator.pushReplacementNamed(context, '/splash');
                },
                child: Text('Sign Out'),
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
