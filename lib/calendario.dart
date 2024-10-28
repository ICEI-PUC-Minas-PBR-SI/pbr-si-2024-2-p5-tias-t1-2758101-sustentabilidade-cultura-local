import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final String instructorEmail;

  CalendarScreen({required this.instructorEmail});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<String> horariosDisponiveis = [];
  List<String> horariosReservados = [];
  String alunoId = '12345'; // ID do aluno
  String? _selectedHorario; // Armazena o horário selecionado

  @override
  void initState() {
    super.initState();
    _loadHorariosDisponiveis(_selectedDay);
  }

  // Função para gerar horários
  List<String> generateHorarios(int startHour, int endHour) {
    List<String> horarios = [];
    for (int hour = startHour; hour <= endHour; hour++) {
      horarios.add('${hour.toString().padLeft(2, '0')}:00');
    }
    return horarios;
  }

  Future<void> _loadHorariosDisponiveis(DateTime selectedDay) async {
    setState(() {
      horariosDisponiveis =
          generateHorarios(8, 18); // Gera horários de 08:00 a 18:00
      _selectedHorario = null; // Limpa o horário selecionado quando o dia muda
    });

    // Obtenha os horários reservados
    await getHorariosReservados(selectedDay, widget.instructorEmail);
  }

  Future<void> getHorariosReservados(DateTime data, String instructorEmail) async {
  final docRef = FirebaseFirestore.instance
      .collection('AgendaAulas') // Coleção de instrutores
      .doc(instructorEmail) // Documento específico do instrutor
      .collection('aulas') // Subcoleção para as aulas desse instrutor
      .doc(DateFormat('yyyy-MM-dd').format(data)); // Documento específico para a data

  final snapshot = await docRef.get();

  if (snapshot.exists) {
    setState(() {
      horariosReservados = List<String>.from(snapshot['horariosReservados']);
    });
  } else {
    horariosReservados = [];
  }
}

Future<void> reservarAula(DateTime data, String horario, String alunoId) async {
  final docRef = FirebaseFirestore.instance
      .collection('AgendaAulas') // Coleção de instrutores
      .doc(widget.instructorEmail) // Documento específico do instrutor
      .collection('aulas') // Subcoleção para as aulas desse instrutor
      .doc(DateFormat('yyyy-MM-dd').format(data)); // Documento específico para a data

  await docRef.set({
    'horariosReservados': FieldValue.arrayUnion([horario]),
    'alunoId': alunoId,
  }, SetOptions(merge: true)); // Usa `merge` para atualizar o documento existente
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcação de Aulas'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedHorario =
                    null; // Limpa a seleção de horário ao mudar o dia
              });
              _loadHorariosDisponiveis(
                  selectedDay); // Carrega horários disponíveis
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: horariosDisponiveis.length,
              itemBuilder: (context, index) {
                final horario = horariosDisponiveis[index];
                final isReservado = horariosReservados.contains(horario);
                return ListTile(
                  title: Text(
                    horario,
                    style: TextStyle(
                      color: isReservado
                          ? Colors.red
                          : Colors.black, // Muda a cor se reservado
                    ),
                  ),
                  enabled: !isReservado, // Desabilita se já reservado
                  onTap: isReservado
                      ? null // Não permite interação se reservado
                      : () {
                          setState(() {
                            _selectedHorario =
                                horario; // Armazena o horário selecionado
                          });
                        },
                );
              },
            ),
          ),
          if (_selectedHorario != null &&
              !horariosReservados.contains(_selectedHorario))
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Exibir um indicador de progresso enquanto a reserva está em andamento
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(child: CircularProgressIndicator());
                      },
                    );

                    await reservarAula(
                        _selectedDay, _selectedHorario!, alunoId);

                    // Fechar o indicador de progresso após a reserva
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Horário $_selectedHorario reservado!')),
                    );

                    _loadHorariosDisponiveis(
                        _selectedDay); // Atualiza horários após a reserva
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 8, // Adiciona uma sombra mais pronunciada
                    shadowColor: Colors.grey.withOpacity(0.5), // Cor da sombra
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check,
                          size: 24,
                          color: Colors.white), // Ícone de confirmação
                      SizedBox(width: 8),
                      Text(
                        'Confirmar Reserva',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
