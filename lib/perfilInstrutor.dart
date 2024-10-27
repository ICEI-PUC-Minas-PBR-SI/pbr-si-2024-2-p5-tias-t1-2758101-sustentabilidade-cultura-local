import 'package:flutter/material.dart';

class ProfessorProfilePage extends StatelessWidget {
  // Lista de horários disponíveis
  final List<String> horariosDisponiveis = [
    'Segunda-feira: 10:00 - 12:00',
    'Terça-feira: 14:00 - 16:00',
    'Quarta-feira: 08:00 - 10:00',
    'Quinta-feira: 18:00 - 20:00',
    'Sexta-feira: 16:00 - 18:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://www.example.com/professor-image.jpg',
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Prof. João Silva',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Matemática, Física',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star_half, color: Colors.amber, size: 24),
                  SizedBox(width: 8),
                  Text('4.5', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Preço por hora: R\$ 50,00',
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
              'Sou professor de Matemática e Física com 10 anos de experiência. '
              'Adoro ajudar alunos a entender conceitos difíceis de forma simples e prática.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Horários disponíveis:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Lista de horários disponíveis
            Expanded(
              child: ListView.builder(
                itemCount: horariosDisponiveis.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.schedule, color: Colors.blueAccent),
                    title: Text(
                      horariosDisponiveis[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Ação ao clicar no botão
                },
                child: Text('Entrar em contato'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 18, // Definindo o tamanho da fonte
                  ),
                  backgroundColor: const Color.fromARGB(255, 87, 175, 76), // Cor de fundo
                  padding: EdgeInsets.symmetric(
                      horizontal: 100, vertical: 15), // Tamanho do botão
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Bordas arredondadas
                  ),
                  foregroundColor:
                      Colors.white, // Cor do texto (substituto do 'textColor')
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
