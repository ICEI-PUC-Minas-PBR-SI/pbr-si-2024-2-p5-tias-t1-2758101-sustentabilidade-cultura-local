import 'package:flutter/material.dart';
import 'package:tis_sustentabilidade/loginAluno.dart';
import 'package:tis_sustentabilidade/registroInstrutor.dart';
import 'telaInicial.dart';
import 'areaInstrutor.dart';
import 'areaEstudante.dart';
import 'login.instrutor.dart';
import 'perfilInstrutor.dart';
import 'calendario.dart';
import 'loginAluno.dart';
import 'registroAluno.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures all bindings are ready
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Corrige a chamada de método para incluir parênteses e o uso correto de chaves

  /*await FirebaseFirestore.instance
      .collection("usuarios")
      .doc("pontuação")
      .set({"Roberto": 230});

      */

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
        /*'/perfilInstrutor': (context) {
          final instructorId =
              ModalRoute.of(context)!.settings.arguments as String;
          return ProfessorProfilePage(instructorId: instructorId);
        },*/
        '/registroAluno': (context) => RegistroAluno(),
        '/loginAluno' : (context) => LoginAluno(),
        '/calendario': (context) => CalendarScreen(),
      },
    );
  }
}