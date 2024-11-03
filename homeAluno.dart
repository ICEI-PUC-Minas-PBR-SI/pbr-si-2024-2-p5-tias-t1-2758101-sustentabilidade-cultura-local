import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'calendario.dart';
import 'perfilInstrutor.dart';
import 'PerfilInstrutorParaAluno.dart';

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
  double _precoMaximo = 100; // Defina o valor máximo desejado para o preço

  @override
  void initState() {
    super.initState();
    _fetchProfessores();
  }

  void perfilInstrutor(String professorEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfessorProfilePageStudent(email: professorEmail),
      ),
    );
  }

  Future<void> _fetchProfessores() async {
    try {
      var db = FirebaseFirestore.instance;
      var snapshot = await db.collection("Instrutor").get();
      setState(() {
        _professores = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        _filteredProfessores = List.from(_professores);
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
        final preco = double.tryParse(professor['precoHora'].toString()) ?? 0;

        bool matchesSearchQuery = searchQuery.isEmpty || nome.contains(searchQuery);
        bool matchesMateria = _selectedMateria == null || materia == _selectedMateria?.toLowerCase();
        bool matchesPreco = preco <= _precoMaximo;

        return matchesSearchQuery && matchesMateria && matchesPreco;
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
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _professores
                    .map((prof) => prof['nome'].toString())
                    .where((nome) => nome.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                _searchController.text = selection;
                _filterProfessores();
              },
              fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                _searchController.text = fieldTextEditingController.text;
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Buscar Professores',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _filterProfessores();
                  },
                );
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
                  _filterProfessores();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Filtrar por Matéria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text("Filtrar por faixa de preço"),
                Slider(
                  value: _precoMaximo,
                  min: 0,
                  max: 500,
                  divisions: 50,
                  label: 'R\$ ${_precoMaximo.toStringAsFixed(0)}',
                  onChanged: (value) {
                    setState(() {
                      _precoMaximo = value;
                      _filterProfessores();
                    });
                  },
                ),
              ],
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
                      subtitle: Text('Matéria: ${professor['materia']}\nPreço por hora: R\$ ${professor['precoHora']}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        perfilInstrutor(professor['email']);
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
