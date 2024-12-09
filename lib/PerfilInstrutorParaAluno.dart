import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'calendario.dart';
import 'editar_horarios.dart';

class ProfessorProfilePageStudent extends StatefulWidget {
  final String email;

  ProfessorProfilePageStudent({required this.email});

  @override
  _ProfessorProfilePageState createState() => _ProfessorProfilePageState();
}

class _ProfessorProfilePageState extends State<ProfessorProfilePageStudent> {
  Map<String, dynamic> recoveredData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData(widget.email);
  }

  void MostrarHorarios() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarScreen(instructorEmail: widget.email),
      ),
    );
  }

  void getData(String email) async {
    var db = FirebaseFirestore.instance;
    try {
      final ref = await db
          .collection("Instrutor")
          .where("email", isEqualTo: email)
          .get();
      final docs = ref.docs;

      if (docs.isEmpty) {
        print("Nenhum Instrutor encontrado.");
        return;
      }

      setState(() {
        recoveredData = docs.first.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao recuperar dados: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          recoveredData['imagem'] ?? "URL_DA_IMAGEM",
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        recoveredData['nome'] ?? 'Carregando...',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        recoveredData['materia'] ?? 'Carregando...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Preço por hora: R\$ ${recoveredData['precoHora'] ?? 'Carregando...'}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Divider(height: 40, thickness: 1.5),
                    Text(
                      'Sobre mim',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      recoveredData['biografia'] ?? 'Carregando...',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: MostrarHorarios,
                        child: Text(
                          'Ver Horários Disponíveis',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 87, 175, 76),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.grey.withOpacity(0.3),
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
