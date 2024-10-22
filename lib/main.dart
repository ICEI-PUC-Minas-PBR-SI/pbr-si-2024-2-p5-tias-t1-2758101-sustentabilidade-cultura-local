import 'package:flutter/material.dart';
import 'package:tis_sustentabilidade/registroInstrutor.dart';
import 'telaInicial.dart';
import 'areaInstrutor.dart';
import 'areaEstudante.dart';
import 'login.instrutor.dart';

void main() {
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
      },
    );
  }
}
