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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('image/assets/logo.jpeg', height: 250),
              const SizedBox(height: 70),
              const Text(
                'Tipo de acesso',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Escolha como deseja utilizar a plataforma: como aluno ou como instrutor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              RadioListTile<String>(
                title: const Text('Instrutor', style: TextStyle(fontSize: 18)),
                subtitle: const Text('Ofereça serviços na plataforma'),
                value: 'Instrutor',
                groupValue: _selectedAccessType,
                onChanged: (value) {
                  setState(() {
                    _selectedAccessType = value!;
                  });
                },
                activeColor: Colors.black,
              ),
              const SizedBox(height: 10),
              RadioListTile<String>(
                title: const Text('Aluno', style: TextStyle(fontSize: 18)),
                subtitle: const Text('Tenha acesso a aulas'),
                value: 'Aluno',
                groupValue: _selectedAccessType,
                onChanged: (value) {
                  setState(() {
                    _selectedAccessType = value!;
                  });
                },
                activeColor: Colors.black,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _navigateToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}