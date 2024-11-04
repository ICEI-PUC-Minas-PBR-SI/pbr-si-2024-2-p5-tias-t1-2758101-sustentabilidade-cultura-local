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

 Future<void> _loadHorariosDisponiveis(DateTime selectedDay) async {
  setState(() {
    horariosDisponiveis = [];
    _selectedHorario = null;
  });

  final docRef = FirebaseFirestore.instance
      .collection('Instrutor')
      .doc(widget.instructorEmail);

  final snapshot = await docRef.get();

  if (snapshot.exists && snapshot.data()!['horarios'] != null) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    final horariosDoDia = snapshot.data()!['horarios'][formattedDate];

    if (horariosDoDia != null) {
      setState(() {
        horariosDisponiveis = List<String>.from(
            horariosDoDia.map((horario) => '${horario['inicio']} - ${horario['termino']}'));
      });
    } else {
      print("Nenhum horário encontrado para a data selecionada.");
    }
  } else {
    print("Documento do instrutor ou campo de horários não encontrado.");
  }

  await getHorariosReservados(selectedDay, widget.instructorEmail);
}


  Future<void> getHorariosReservados(DateTime data, String instructorEmail) async {
    final docRef = FirebaseFirestore.instance
        .collection('AgendaAulas')
        .doc(instructorEmail)
        .collection('aulas')
        .doc(DateFormat('yyyy-MM-dd').format(data));

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      setState(() {
        horariosReservados = List<String>.from(snapshot['horariosReservados']);
      });
    } else {
      setState(() {
        horariosReservados = [];
      });
      print("Nenhum horário reservado encontrado para a data.");
    }
  }

  Future<void> reservarAula(DateTime data, String horario, String alunoId) async {
    final docRef = FirebaseFirestore.instance
        .collection('AgendaAulas')
        .doc(widget.instructorEmail)
        .collection('aulas')
        .doc(DateFormat('yyyy-MM-dd').format(data));

    await docRef.set({
      'horariosReservados': FieldValue.arrayUnion([horario]),
      'alunoId': alunoId,
    }, SetOptions(merge: true));
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
                _selectedHorario = null;
              });
              _loadHorariosDisponiveis(selectedDay);
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: horariosDisponiveis.isEmpty
                ? Center(child: Text("Nenhum horário disponível para a data selecionada."))
                : ListView.builder(
                    itemCount: horariosDisponiveis.length,
                    itemBuilder: (context, index) {
                      final horario = horariosDisponiveis[index];
                      final isReservado = horariosReservados.contains(horario);
                      return ListTile(
                        title: Text(
                          horario,
                          style: TextStyle(
                            color: isReservado ? Colors.red : Colors.black,
                          ),
                        ),
                        enabled: !isReservado,
                        onTap: isReservado
                            ? null
                            : () {
                                setState(() {
                                  _selectedHorario = horario;
                                });
                              },
                      );
                    },
                  ),
          ),
          if (_selectedHorario != null && !horariosReservados.contains(_selectedHorario))
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(child: CircularProgressIndicator());
                    },
                  );

                  await reservarAula(_selectedDay, _selectedHorario!, alunoId);

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Horário $_selectedHorario reservado!')),
                  );

                  _loadHorariosDisponiveis(_selectedDay);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 24, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Confirmar Reserva',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
