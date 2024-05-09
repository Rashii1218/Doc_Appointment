import 'package:doc_appoint/pages/BottomNavBar.dart';
import 'package:doc_appoint/pages/WidgetTree.dart';
import 'package:get/get.dart';
import 'package:doc_appoint/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? user = FirebaseAuth.instance.currentUser;

  runApp( 
    GetMaterialApp(
     debugShowCheckedModeBanner: false,
      home: user != null ? const BottomNavBar() : const LoginView(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
   
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      Future.delayed(const Duration(seconds: 5),(){
        Get.off(() => const LoginView());
      });
      return  const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:  WidgetTree(),
      );
  }
}

