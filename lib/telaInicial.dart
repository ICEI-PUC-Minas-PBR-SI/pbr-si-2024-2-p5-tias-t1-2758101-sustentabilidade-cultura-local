import 'package:flutter/material.dart';
import 'areaInstrutor.dart';
import 'areaEstudante.dart';

class AccessTypeScreen extends StatefulWidget {
  @override
  _AccessTypeScreenState createState() => _AccessTypeScreenState();
}

class _AccessTypeScreenState extends State<AccessTypeScreen> {
  String _selectedAccessType = 'Instrutor';

  void _navigateToNextScreen() {
    if (_selectedAccessType == 'Instrutor') {
      Navigator.pushNamed(context, '/instructor');
    } else {
      Navigator.pushNamed(context, '/student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tipo de Acesso',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 32, 6, 65), Color.fromARGB(255, 194, 11, 108)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('image/assets/logo.jpeg', height: 250),
                  const SizedBox(height: 40),
                  const Text(
                    'Escolha como deseja utilizar a plataforma:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RadioListTile<String>(
                    title: const Text(
                      'Instrutor',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Ofereça serviços na plataforma',
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: 'Instrutor',
                    groupValue: _selectedAccessType,
                    onChanged: (value) {
                      setState(() {
                        _selectedAccessType = value!;
                      });
                    },
                    activeColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  RadioListTile<String>(
                    title: const Text(
                      'Aluno',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Tenha acesso a aulas',
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: 'Aluno',
                    groupValue: _selectedAccessType,
                    onChanged: (value) {
                      setState(() {
                        _selectedAccessType = value!;
                      });
                    },
                    activeColor: Colors.white,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _navigateToNextScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
