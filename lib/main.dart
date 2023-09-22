import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/firebase_options.dart';
import 'package:firebase_flutter/pages/main.profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static const String routeName = '/';
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool isSignedIn = true;
  User? user;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out');
      } else {
        print('User is signed in!');
        print(user);
      }
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: mainContainer(),
    );
  }

  Center mainContainer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user == null) ...[
              TextField(
                controller: email,
                decoration: const InputDecoration(hintText: 'Input Email'),
              ),
              TextField(
                controller: password,
                decoration: const InputDecoration(hintText: 'Input Password'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                    setState(() {
                      isSignedIn = true;
                    });
                    print(credential.credential);
                  } on FirebaseAuthException catch (ex) {
                    if (ex.code == 'user-not-found') {
                      print('No user found for that email');
                    } else if (ex.code == 'wrong-password') {
                      print('Wrong password');
                    } else {
                      print(ex.code);
                      print(ex.message);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Login'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text, password: password.text);
                    setState(() {
                      isSignedIn = true;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Create Account'),
              ),
              Text('$isSignedIn'),
            ],
            if (user != null) ...[
              Text('User : ${user!.email}'),
              Text('Credential : ${user!.displayName}'),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(ProfileMain.routeName);
                },
                child: const Text('Go to Profile'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    isSignedIn = false;
                  });
                },
                child: const Text('Sign Out'),
              ),
              Text('$isSignedIn'),
            ]
          ],
        ),
      ),
    );
  }
}
