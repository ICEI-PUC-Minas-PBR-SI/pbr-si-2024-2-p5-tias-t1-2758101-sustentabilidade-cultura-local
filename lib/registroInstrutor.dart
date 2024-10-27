import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Registroinstrutor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _biografiaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _precoHoraController = TextEditingController();
  final _materiaController = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

 void _register() async {
  final name = _nameController.text;
  final email = _emailController.text;
  final password = _passwordController.text;
  final biografia = _biografiaController.text;
  final telefone = _telefoneController.text;
  final precoHora = _precoHoraController.text;
  final materia = _materiaController.text;

  if (name.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      biografia.isEmpty ||
      telefone.isEmpty ||
      precoHora.isEmpty ||
      materia.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, preencha todos os campos.')),
    );
    return;
  }

  // Mostra o indicador de carregamento
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  try {
    print("Conectando ao Firestore...");
    var db = FirebaseFirestore.instance;
    await db.collection("Instrutor").add({
      "nome": name,
      "email": email,
      "senha": password,
      "biografia": biografia,
      "telefone": telefone,
      "precoHora": precoHora,
      "materia": materia,
    });
    print("Registro bem-sucedido!");

    Navigator.pop(context); // Oculta o indicador de carregamento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro bem-sucedido!')),
    );

    // Limpa os campos do formulário
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _biografiaController.clear();
    _telefoneController.clear();
    _precoHoraController.clear();
    _materiaController.clear();
  } catch (e) {
    Navigator.pop(context); // Oculta o indicador de carregamento em caso de erro
    print("Erro ao registrar: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao registrar: $e')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add,
                  size: 100,
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Registrar-se',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _biografiaController,
                  decoration: InputDecoration(
                    labelText: 'Biografia',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: _materiaController,
                  decoration: InputDecoration(
                    labelText: 'Matéria/Aula que irá lecionar ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _precoHoraController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Preço por Hora',
                    hintText: 'Ex: 50,00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                        Icons.attach_money), // Better icon for monetary values
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
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
    );
  }
}
