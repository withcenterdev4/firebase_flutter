import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/firebase_options.dart';
import 'package:firebase_flutter/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class ProfileMain extends StatelessWidget {
  static const routeName = '/Profile';
  const ProfileMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({super.key});
  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  bool isTapped = false;
  var db = FirebaseFirestore.instance;

  final items = <String, dynamic>{
    'first': 'Ada',
    'last': 'Lovelace',
    'born': 1815,
  };

  void add() async {
    db.collection('users').add(items).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profileIcon(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileIcon() {
    return SizedBox(
      height: 200,
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.white,
        child: InkWell(
          onTap: () async {
            setState(() {
              isTapped = isTapped ? false : true;
            });
          },
          child: const Stack(
            children: [
              Positioned(
                top: 5,
                right: 5,
                left: 5,
                bottom: 5,
                child: CircleAvatar(
                  radius: 65,
                  foregroundImage: AssetImage('assets/images/user.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
