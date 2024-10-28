import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
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
      horariosDisponiveis = generateHorarios(8, 18); // Gera horários de 08:00 a 18:00
      _selectedHorario = null; // Limpa o horário selecionado quando o dia muda
    });

    // Obtenha os horários reservados
    await getHorariosReservados(selectedDay);
  }

  Future<void> getHorariosReservados(DateTime data) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('aulas')
        .where('data', isEqualTo: DateFormat('yyyy-MM-dd').format(data))
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        horariosReservados = List<String>.from(snapshot.docs.first['horariosReservados']);
      });
    } else {
      horariosReservados = [];
    }
  }

  Future<void> reservarAula(DateTime data, String horario, String alunoId) async {
    final docRef = FirebaseFirestore.instance
        .collection('aulas')
        .doc(DateFormat('yyyy-MM-dd').format(data));

    await docRef.update({
      'horariosReservados': FieldValue.arrayUnion([horario]),
      'alunoId': alunoId,
    });
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
                _selectedHorario = null; // Limpa a seleção de horário ao mudar o dia
              });
              _loadHorariosDisponiveis(selectedDay); // Carrega horários disponíveis
            },
          ),
          const SizedBox(height: 5.0),
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
                      color: isReservado ? Colors.red : Colors.black, // Muda a cor se reservado
                    ),
                  ),
                  enabled: !isReservado, // Desabilita se já reservado
                  onTap: isReservado
                      ? null // Não permite interação se reservado
                      : () {
                          setState(() {
                            _selectedHorario = horario; // Armazena o horário selecionado
                          });
                        },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedHorario != null && !horariosReservados.contains(_selectedHorario)
          ? BottomAppBar(
              color: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    await reservarAula(_selectedDay, _selectedHorario!, alunoId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Horário $_selectedHorario reservado!')),
                    );
                    _loadHorariosDisponiveis(_selectedDay); // Atualiza horários após a reserva
                  },
                  child: Center(
                    child: Text(
                      'Confirmar Reserva para ${_selectedHorario ?? 'Selecionar Horário'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
