import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editar_horarios.dart';

class ProfessorProfilePage extends StatefulWidget {
  final String email;

  ProfessorProfilePage({required this.email});

  @override
  _ProfessorProfilePageState createState() => _ProfessorProfilePageState();
}

class _ProfessorProfilePageState extends State<ProfessorProfilePage> {
  Map<String, dynamic> recoveredData = {};

  @override
  void initState() {
    super.initState();
    getData(widget.email);
  }

  void getData(String email) async {
    var db = FirebaseFirestore.instance;
    try {
      final ref = await db.collection("Instrutor").where("email", isEqualTo: email).get();
      final docs = ref.docs;

      if (docs.isEmpty) {
        print("Nenhum Instrutor encontrado.");
        return;
      }

      setState(() {
        recoveredData = {};
        for (var doc in docs) {
          recoveredData[doc.id] = doc.data();
        }
      });
    } catch (e) {
      print("Erro ao recuperar dados: $e");
    }
  }

  void editHorarios() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarHorariosScreen(instructorEmail: widget.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFF1E88E5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      recoveredData.isNotEmpty
                          ? recoveredData.values.first['imagem'] ?? "URL_DA_IMAGEM"
                          : "URL_DA_IMAGEM",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  recoveredData.isNotEmpty
                      ? recoveredData.values.first['nome']
                      : 'Carregando...',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recoveredData.isNotEmpty
                      ? recoveredData.values.first['materia']
                      : 'Carregando...',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Preço por hora: R\$ ${recoveredData.isNotEmpty ? recoveredData.values.first['precoHora'] : 'Carregando...'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF43A047),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 255, 255, 255),
                  height: 40,
                  thickness: 1,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sobre Mim',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  recoveredData.isNotEmpty
                      ? recoveredData.values.first['biografia']
                      : 'Carregando...',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: editHorarios,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      backgroundColor: const Color(0xFF43A047),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Editar Agenda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
