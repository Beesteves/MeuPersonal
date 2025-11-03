import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tcc/controllers/evolucao_controller.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/models/evolucao.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:intl/intl.dart';

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
    final theme = Theme.of(context);

    return BarraCimaScaffold(
      title: "Exercícios",
      body: StreamBuilder<List<Exercicio>>(
        stream: DaoExercicio.getExerciciodoPersonal(personalId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final exercicios = snapshot.data ?? [];
          if (exercicios.isEmpty) {
            return const Center(child: Text('Nenhum exercício cadastrado.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: exercicios.length,
            itemBuilder: (context, i) {
              final ex = exercicios[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ExpansionTile(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(ex.nome, style: theme.textTheme.titleLarge),
                  trailing: const Icon(Icons.show_chart, color: Colors.red),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    _GraficoEvolucaoMini(
                      exercicio: ex,
                      alunoId: alunoId,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GraficoEvolucaoMini extends StatelessWidget {
  final Exercicio exercicio;
  final String alunoId;

  const _GraficoEvolucaoMini({
    required this.exercicio,
    required this.alunoId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<Evolucao>>(
      future: DaoEvolucao.buscarEvolucaoExercicio(alunoId, exercicio.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 150, child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Text("Erro: ${snapshot.error}");
        }

        final evolucoes = snapshot.data ?? [];
        if (evolucoes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Nenhum registro de carga ainda."),
          );
        }

        // Ordena e formata dados
        evolucoes.sort((a, b) => DateTime.parse(a.data).compareTo(DateTime.parse(b.data)));
        final datas = evolucoes.map((e) => DateTime.parse(e.data)).toList();
        final firstDate = datas.first;
        final format = DateFormat("dd/MM");

        final spots = evolucoes.asMap().entries.map((entry) {
          final index = entry.key;
          final days = datas[index].difference(firstDate).inDays.toDouble();
          return FlSpot(days, entry.value.carga);
        }).toList();

        final labels = datas.map((d) => format.format(d)).toList();
        final maxCarga = evolucoes.map((e) => e.carga).reduce((a, b) => a > b ? a : b);
        final maxIndex = evolucoes.indexWhere((e) => e.carga == maxCarga);
        final maxData = labels[maxIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: spots.last.x,
                  titlesData: FlTitlesData(
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 36,
                        showTitles: true,
                        interval: (maxCarga / 3).ceilToDouble(),
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            value.toStringAsFixed(0),
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = spots.indexWhere((s) => s.x == value);
                          if (index == -1 || index >= labels.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[index],
                              style: const TextStyle(fontSize: 9),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 3.5,
                          color: Colors.white,
                          strokeWidth: 2.5,
                          strokeColor: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      //tooltipBgColor: theme.colorScheme.primary,
                      getTooltipItems: (touchedSpots) => touchedSpots.map((t) {
                        int index = spots.indexWhere((s) => s.x == t.x);
                        final label = (index >= 0 && index < labels.length)
                            ? labels[index]
                            : '';
                        return LineTooltipItem(
                          "$label\n${t.y.toStringAsFixed(1)} kg",
                          const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Carga máxima: ${maxCarga.toStringAsFixed(1)} kg em $maxData",
                  style: theme.textTheme.titleMedium,
            ),
          ],
        );
      },
    );
  }
}
