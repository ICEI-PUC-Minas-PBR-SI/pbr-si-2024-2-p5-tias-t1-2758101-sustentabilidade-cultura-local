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

  @override
  void initState() {
    super.initState();
    _loadHorariosDisponiveis(_selectedDay);
  }

  Future<void> _loadHorariosDisponiveis(DateTime selectedDay) async {
    // Limpa os horários para o novo dia
    setState(() {
      horariosDisponiveis = [];
    });

    // Obtenha os horários salvos do instrutor para o dia selecionado
    final docRef = FirebaseFirestore.instance
        .collection('Instrutor')
        .doc(widget.instructorEmail);

    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data()!['horarios'] != null) {
      final horariosDoDia = snapshot.data()!['horarios'][DateFormat('yyyy-MM-dd').format(selectedDay)];
      
      if (horariosDoDia != null) {
        setState(() {
          horariosDisponiveis = List<String>.from(
              horariosDoDia.map((horario) => '${horario['inicio']} - ${horario['termino']}'));
        });
      }
    }
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
              });
              _loadHorariosDisponiveis(selectedDay); // Carrega horários disponíveis
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: horariosDisponiveis.isEmpty
                ? Center(child: Text('Nenhum horário disponível para o dia selecionado.'))
                : ListView.builder(
                    itemCount: horariosDisponiveis.length,
                    itemBuilder: (context, index) {
                      final horario = horariosDisponiveis[index];
                      return ListTile(
                        title: Text(
                          horario,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
