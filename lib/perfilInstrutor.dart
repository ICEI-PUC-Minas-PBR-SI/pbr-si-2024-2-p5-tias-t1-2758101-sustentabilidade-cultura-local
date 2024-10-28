import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                // Exemplo: use uma imagem de URL ou local aqui
                backgroundImage: NetworkImage("URL_DA_IMAGEM"), // Substitua pela URL da imagem do professor
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                recoveredData.isNotEmpty ? recoveredData.values.first['nome'] : 'Carregando...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                recoveredData.isNotEmpty ? recoveredData.values.first['materia'] : 'Carregando...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Preço por hora: R\$ ${recoveredData.isNotEmpty ? recoveredData.values.first['precoHora'] : 'Carregando...'}',
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
              recoveredData.isNotEmpty ? recoveredData.values.first['biografia'] : 'Carregando...',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calendario');
                },
                child: Text('Entrar em contato'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 18,
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
          ],
        ),
      ),
    );
  }
}
