import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tis_sustentabilidade/calendario.dart';
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
        builder: (_) => CalendarScreen(instructorEmail: widget.email), // Passar o email do professor
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
        isLoading = false; // Carregamento concluído
      });
    } catch (e) {
      print("Erro ao recuperar dados: $e");
    }
  }

  void EditarAgenda() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarHorariosScreen(instructorEmail: widget.email), // Passar o email do professor
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          recoveredData['imagem'] ?? "URL_DA_IMAGEM"), // Use uma imagem padrão se a URL estiver vazia
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      recoveredData['nome'] ?? 'Carregando...',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      recoveredData['materia'] ?? 'Carregando...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Preço por hora: R\$ ${recoveredData['precoHora'] ?? 'Carregando...'}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sobre mim:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    recoveredData['biografia'] ?? 'Carregando...',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          MostrarHorarios();
                        },
                        child: Text('Ver Horários disponíveis'),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 15,
                          ),
                          backgroundColor: const Color.fromARGB(255, 87, 175, 76),
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
