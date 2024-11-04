import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tis_sustentabilidade/editar_horarios.dart';

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
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "URL_DA_IMAGEM"), // Substitua pela URL da imagem do professor
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    recoveredData.isNotEmpty
                        ? recoveredData.values.first['nome']
                        : 'Carregando...',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6200EE),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    recoveredData.isNotEmpty
                        ? recoveredData.values.first['materia']
                        : 'Carregando...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Preço por hora: R\$ ${recoveredData.isNotEmpty ? recoveredData.values.first['precoHora'] : 'Carregando...'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 44, 141, 40),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  'Sobre mim',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6200EE),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  recoveredData.isNotEmpty
                      ? recoveredData.values.first['biografia']
                      : 'Carregando...',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: editHorarios,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      backgroundColor: const Color(0xFF43A047),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
