import 'dart:math';

import 'package:brasil_cripto/models/asset_history_model.dart';
import 'package:brasil_cripto/shared/utils/date_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceChart extends StatelessWidget {
  final List<AssetHistoryModel> history;
  const PriceChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Dados históricos não disponíveis para esta criptomoeda.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final double minY = history.map((e) => e.priceUsd).reduce(min) * 0.95;
    final double maxY = history.map((e) => e.priceUsd).reduce(max) * 1.05;

    final List<FlSpot> spots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.priceUsd);
    }).toList();

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                const FlLine(color: Color(0xff37434d), strokeWidth: 0.5),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (history.length / 5).floor().toDouble().clamp(
                  1,
                  history.length.toDouble(),
                ),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < history.length) {
                    final dateTime = DateTime.fromMillisecondsSinceEpoch(
                      history[index].time,
                    );
                    return SideTitleWidget(
                      meta: meta,
                      space: 8.0,
                      child: Text(
                        DateFormat('dd/MM').format(dateTime),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    DateFormatter.formatPrice(value.toStringAsFixed(2)),
                    style: const TextStyle(fontSize: 10, color: Colors.black),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 0.5),
          ),
          minX: 0,
          maxX: (history.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (context) =>
                  Colors.blueAccent.withValues(alpha: 0.8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final index = touchedSpot.spotIndex;
                  final AssetHistoryModel data = history[index];
                  return LineTooltipItem(
                    '${DateFormatter.formatTimestamp(data.time)}\n${DateFormatter.formatPrice(data.priceUsd.toStringAsFixed(8))}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
