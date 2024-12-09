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
  String? _selectedHorario;

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
          horariosDisponiveis = List<String>.from(horariosDoDia.map(
              (horario) => '${horario['inicio']} - ${horario['termino']}'));
        });
      }
    }

    await getHorariosReservados(selectedDay, widget.instructorEmail);
  }

  Future<void> getHorariosReservados(
      DateTime data, String instructorEmail) async {
    final docRef = FirebaseFirestore.instance
        .collection('AgendaAulas')
        .doc(instructorEmail)
        .collection('aulas')
        .doc(DateFormat('yyyy-MM-dd').format(data));

    final snapshot = await docRef.get();

    setState(() {
      horariosReservados = snapshot.exists
          ? List<String>.from(snapshot['horariosReservados'])
          : [];
    });
  }

  Future<void> reservarAula(
      DateTime data, String horario, String alunoEmail) async {
    final docRef = FirebaseFirestore.instance
        .collection('AgendaAulas')
        .doc(widget.instructorEmail)
        .collection('aulas')
        .doc(DateFormat('yyyy-MM-dd').format(data));

    final snapshot = await docRef.get();

    List<Map<String, dynamic>> horariosReservados = snapshot.exists
        ? List<Map<String, dynamic>>.from(
            snapshot.data()?['horariosReservados'] ?? [])
        : [];

    if (!horariosReservados.any((reserva) =>
        reserva['horario'] == horario && reserva['alunoEmail'] == alunoEmail)) {
      horariosReservados.add({'horario': horario, 'alunoEmail': alunoEmail});

      await docRef.set({
        'horariosReservados': horariosReservados,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horário $horario reservado com sucesso!')),
      );
      _loadHorariosDisponiveis(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horário já reservado para este aluno.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcação de Aulas'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TableCalendar(
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
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Horários Disponíveis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: horariosDisponiveis.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum horário disponível para a data selecionada.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: horariosDisponiveis.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final horario = horariosDisponiveis[index];
                      final isReservado = horariosReservados.contains(horario);
                      return ListTile(
                        title: Text(
                          horario,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isReservado ? Colors.red : Colors.black,
                          ),
                        ),
                        trailing: isReservado
                            ? Icon(Icons.lock, color: Colors.red)
                            : Icon(Icons.check_circle_outline,
                                color: Colors.green),
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
          if (_selectedHorario != null &&
              !horariosReservados.contains(_selectedHorario))
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Diálogo de confirmação antes de reservar
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar Reserva'),
                          content: Text(
                              'Deseja reservar o horário $_selectedHorario?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false), // Cancela
                              child: Text('Cancelar',
                                  style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(true), // Confirma
                              child: Text('Confirmar'),
                            ),
                          ],
                        );
                      },
                    );

                    // Se o usuário confirmar, chama o método para reservar
                    if (confirmar == true) {
                      await reservarAula(
                          _selectedDay, _selectedHorario!, "email@teste");
                    }
                  },
                  icon: Icon(Icons.check, size: 20),
                  label: Text(
                    'Reservar $_selectedHorario',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Cor do texto
                    backgroundColor: Colors.blue.shade700, // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Bordas arredondadas
                    ),
                    elevation: 6, // Sombra para dar profundidade
                    shadowColor: Colors.blue.shade300, // Cor da sombra
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0), // Espaçamento interno
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
