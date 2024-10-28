import 'package:flutter/material.dart';
import 'package:tis_sustentabilidade/registroInstrutor.dart';
import 'telaInicial.dart';
import 'areaInstrutor.dart';
import 'areaEstudante.dart';
import 'login.instrutor.dart';
import 'perfilInstrutor.dart';
import 'calendario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures all bindings are ready
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AccessTypeScreen(),
        '/instructor': (context) => InstructorHomeScreen(),
        '/loginInstructor': (context) => LoginInstrutor(),
        '/registroInstructor': (context) => Registroinstrutor(),
        '/student': (context) => StudentHomeScreen(),
        '/perfilInstrutor': (context) => ProfessorProfilePage(),
        '/calendario': (context) => CalendarScreen(),
      },
    );
  }
}
