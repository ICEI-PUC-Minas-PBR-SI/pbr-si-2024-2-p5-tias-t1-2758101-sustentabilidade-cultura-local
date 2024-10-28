// telaInicialAluno.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'calendario.dart';

class HomeAluno extends StatefulWidget {
  final String email;
  HomeAluno({required this.email});

  @override
  _HomeAlunoState createState() => _HomeAlunoState();
}

class _HomeAlunoState extends State<HomeAluno> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _professores = [];
  List<Map<String, dynamic>> _filteredProfessores = [];
  String? _selectedMateria;

  @override
  void initState() {
    super.initState();
    _fetchProfessores();
  }

  Future<void> _fetchProfessores() async {
    try {
      var db = FirebaseFirestore.instance;
      var snapshot = await db.collection("Instrutor").get();
      setState(() {
        _professores = snapshot.docs.map((doc) => doc.data()).toList();
        _filteredProfessores = List.from(_professores); // Inicializa a lista filtrada com todos os professores
      });
    } catch (e) {
      print("Erro ao buscar professores: $e");
    }
  }

  void _filterProfessores() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredProfessores = _professores.where((professor) {
        final nome = professor['nome'].toLowerCase();
        final materia = professor['materia']?.toLowerCase() ?? '';
        return (nome.contains(searchQuery) || materia.contains(searchQuery)) &&
               (materia == _selectedMateria || _selectedMateria == null);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home do Aluno'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar Professores',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterProfessores();
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedMateria,
              items: ['Matemática', 'Inglês', 'Português', 'Violão'].map((materia) {
                return DropdownMenuItem<String>(
                  value: materia,
                  child: Text(materia),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMateria = newValue;
                  _filterProfessores(); // Filtra professores ao mudar a matéria
                });
              },
              decoration: const InputDecoration(
                labelText: 'Filtrar por Matéria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProfessores.length,
                itemBuilder: (context, index) {
                  final professor = _filteredProfessores[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(professor['nome']),
                      subtitle: Text('Matéria: ${professor['materia']}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navegar para a tela de perfil do professor
                        Navigator.pushNamed(context, '/perfilInstrutor', arguments: professor['email']);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
