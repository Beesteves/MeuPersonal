import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tcc/controllers/evolucao_controller.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/models/evolucao.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';

class ExerciciosScreen extends StatelessWidget {
  final String alunoId;
  final String personalId;

  const ExerciciosScreen({
    super.key,
    required this.alunoId,
    required this.personalId,
  });

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Exercícios",
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Exercicio>>(
              stream: DaoExercicio.getExerciciodoPersonal(personalId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final exercicio = snapshot.data ?? [];
                if (exercicio.isEmpty) {
                  return const Center(
                      child: Text('Nenhum exercício cadastrado.'));
                }

                return ListView.builder(
                  itemCount: exercicio.length,
                  itemBuilder: (context, i) {
                    final ex = exercicio[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(ex.nome, style: Theme.of(context).textTheme.titleLarge),
                        trailing: const Icon(Icons.show_chart,
                            color: Colors.blue), // Cor mantida para destaque visual
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EvolucaoExercicioScreen(
                                exercicio: ex,
                                alunoId: alunoId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class EvolucaoExercicioScreen extends StatelessWidget {
  final Exercicio exercicio;
  final String alunoId;

  const EvolucaoExercicioScreen({
    super.key,
    required this.exercicio,
    required this.alunoId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Evolução: ${exercicio.nome}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Evolucao>>(
                future: DaoEvolucao.buscarEvolucaoExercicio(alunoId, exercicio.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Erro ao carregar evolução: ${snapshot.error}"));
                  }

                  final evolucoes = snapshot.data ?? [];

                  if (evolucoes.isEmpty) {
                    return const Center(child: Text("Nenhum registro de carga ainda."));
                  }

                  // 🔹 Ordena pela data
                  evolucoes.sort((a, b) =>
                      DateTime.parse(a.data).compareTo(DateTime.parse(b.data)));

                  // 🔹 Converte datas para DateTime
                  final datasDateTime = evolucoes.map((e) => DateTime.parse(e.data)).toList();

                  // 🔹 Define a primeira data como referência
                  final firstDate = datasDateTime.first;

                  // 🔹 Cria spots usando diferença em dias desde a primeira data
                  final spots = datasDateTime.asMap().entries.map((entry) {
                    final index = entry.key;
                    final days = datasDateTime[index].difference(firstDate).inDays.toDouble();
                    final carga = evolucoes[index].carga;
                    return FlSpot(days, carga);
                  }).toList();

                  // 🔹 Datas formatadas para rótulos
                  final datasFormatadas = datasDateTime.map((d) =>
                      "${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}").toList();

                  // 🔹 Encontra carga máxima e data
                  final maxCarga = evolucoes.map((e) => e.carga).reduce((a, b) => a > b ? a : b);
                  final maxIndex = evolucoes.indexWhere((e) => e.carga == maxCarga);
                  final maxData = datasFormatadas[maxIndex];

                  return Column(
                    children: [
                      Expanded(
                        child:LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: spots.isNotEmpty ? spots.last.x : 0,
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true),),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    // Encontra o índice mais próximo
                                    int nearestIndex = 0;
                                    double minDiff = double.infinity;
                                    for (int i = 0; i < spots.length; i++) {
                                      final diff = (spots[i].x - value).abs();
                                      if (diff < minDiff) {
                                        minDiff = diff;
                                        nearestIndex = i;
                                      }
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        datasFormatadas[nearestIndex],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  },
                                ), // Missing closing parenthesis for AxisTitles
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: false,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 3,
                                spots: spots,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((touchedSpot) {
                                    // Encontra índice mais próximo
                                    int nearestIndex = 0;
                                    double minDiff = double.infinity;
                                    for (int i = 0; i < spots.length; i++) {
                                      final diff = (spots[i].x - touchedSpot.x).abs();
                                      if (diff < minDiff) {
                                        minDiff = diff;
                                        nearestIndex = i;
                                      }
                                    }
                                    final dateLabel = datasFormatadas[nearestIndex];

                                    return LineTooltipItem(
                                      "$dateLabel\nCarga: ${touchedSpot.y.toStringAsFixed(1)} kg",
                                      const TextStyle(color: Colors.white),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Carga máxima: ${maxCarga.toStringAsFixed(1)} kg em $maxData",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
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
