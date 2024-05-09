// import 'package:doc_appoint/pages/BottomNavBar.dart';
// import 'package:doc_appoint/pages/WidgetTree.dart';
// import 'package:get/get.dart';
// import 'package:doc_appoint/auth/login_view.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   User? user = FirebaseAuth.instance.currentUser;

//   runApp( 
//     GetMaterialApp(
//      debugShowCheckedModeBanner: false,
//       home: user != null ? const BottomNavBar() : const LoginView(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
  
   
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//       Future.delayed(const Duration(seconds: 5),(){
//         Get.off(() => const LoginView());
//       });
//       return  const GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:  WidgetTree(),
//       );
//   }
// }

import 'package:doc_appoint/pages/BottomNavBar.dart';
import 'package:doc_appoint/pages/WidgetTree.dart';
import 'package:get/get.dart';
import 'package:doc_appoint/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  /*@override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.off(() => const BottomNavBar());
      } else {
        //Get.off(() => const LoginView());
        Get.off(() => const WidgetTree());
      }
    });

    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
*/
@override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = true;

  @override
  void initState() {
    super.initState();
    // Hide logo after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLogo = false;
        User? user = FirebaseAuth.instance.currentUser;
        /*if (user != null) {
          Get.off(() => const BottomNavBar());
        } else {*/
          Get.off(() => const WidgetTree());
        //}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Logo widget
        if (_showLogo)
          Image.asset(
            'assets/logo.jpg',
            width: 200,
            height: 200,
          ),
      ],
    );
  }
}*/

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 8);
    return Timer(duration, navigateToNextScreen);
  }

  navigateToNextScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     final imageWidth = 600.0; // Width of the image
      final imageHeight = 1000.0; // Height of the image
      final imageAspectRatio = imageWidth / imageHeight;
    return Scaffold(
      //backgroundColor: Color.fromARGB(198, 19, 174, 221),
      body: AspectRatio(
        aspectRatio: imageAspectRatio,
        child: Container(
          
          child: Image.asset(
            'assets/logo.jpg',
          fit: BoxFit.contain,
          ),
        ),)
    );
  }
}
