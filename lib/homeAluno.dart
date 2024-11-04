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
  double _precoMaximo = 100;

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
        _professores = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            'nome': data['nome'] ?? 'Nome não disponível',
            'materia': data['materia'] ?? 'Matéria não especificada',
            'precoHora': data['precoHora'] ?? 0,
            'email': data['email'] ?? '',
          };
        }).toList();
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
        final nome = (professor['nome'] ?? '').toLowerCase();
        final materia = (professor['materia'] ?? '').toLowerCase();
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Campo de busca com autocomplete estilizado
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
                  fieldViewBuilder: (context, fieldTextEditingController, fieldFocusNode, onFieldSubmitted) {
                    _searchController.text = fieldTextEditingController.text;
                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Buscar Professores',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        _filterProfessores();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Filtro de Matéria com Dropdown
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
                  decoration: InputDecoration(
                    labelText: 'Filtrar por Matéria',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Filtro de faixa de preço com Slider estilizado
                Column(
                  children: [
                    Text(
                      "Filtrar por faixa de preço",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepPurple),
                    ),
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
                      activeColor: Colors.deepPurple,
                      inactiveColor: Colors.deepPurple.shade100,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Lista de professores com Cards personalizados
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredProfessores.length,
                    itemBuilder: (context, index) {
                      final professor = _filteredProfessores[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          title: Text(
                            professor['nome'],
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                          subtitle: Text(
                            'Matéria: ${professor['materia']}\nPreço por hora: R\$ ${professor['precoHora']}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple),
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
        ),
      ),
    );
  }
}
