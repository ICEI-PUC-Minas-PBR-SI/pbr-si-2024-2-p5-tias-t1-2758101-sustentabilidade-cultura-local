import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EditarHorariosScreen extends StatefulWidget {
  final String instructorEmail;

  EditarHorariosScreen({required this.instructorEmail});

  @override
  _EditarHorariosScreenState createState() => _EditarHorariosScreenState();
}

class _EditarHorariosScreenState extends State<EditarHorariosScreen> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _horarios = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 87, 175, 76),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Horário de Início',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: _startTime != null
                        ? Text(
                            _startTime!.format(context),
                            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                          )
                        : Text(
                            'Selecionar',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => _startTime = time);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Horário de Término',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: _endTime != null
                        ? Text(
                            _endTime!.format(context),
                            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                          )
                        : Text(
                            'Selecionar',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => _endTime = time);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _addHorario,
                    icon: Icon(Icons.add, color: const Color.fromARGB(255, 255, 255, 255)),
                    label: Text('Adicionar Horário',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 91, 223, 73),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _horarios[_selectedDay]?.length ?? 0,
                itemBuilder: (context, index) {
                  final horario = _horarios[_selectedDay]![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(
                        '${horario['inicio']} - ${horario['termino']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeHorario(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarHorarios,
              child: Text(
                'Salvar Horários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addHorario() {
    if (_startTime != null && _endTime != null) {
      setState(() {
        if (_horarios[_selectedDay] == null) {
          _horarios[_selectedDay] = [];
        }
        _horarios[_selectedDay]!.add({
          'inicio': _startTime!.format(context),
          'termino': _endTime!.format(context),
        });
        _startTime = null;
        _endTime = null;
      });
    }
  }

  void _removeHorario(int index) {
    setState(() {
      _horarios[_selectedDay]?.removeAt(index);
    });
  }

  void _salvarHorarios() async {
    var db = FirebaseFirestore.instance;
    Map<String, List<Map<String, dynamic>>> formattedHorarios = {};
    
    // Convertendo DateTime para String para salvar no Firestore
    _horarios.forEach((date, horarios) {
      String formattedDate = "${date.year}-${date.month}-${date.day}";
      formattedHorarios[formattedDate] = horarios;
    });
    
    await db
        .collection("Instrutor")
        .doc(widget.instructorEmail)
        .update({'horarios': formattedHorarios});
    
    Navigator.pop(context);
  }
}
