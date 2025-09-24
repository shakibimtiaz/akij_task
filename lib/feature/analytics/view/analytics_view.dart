import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controller/analytics_controller.dart';

class AnalyticsView extends StatelessWidget {
  final AnalyticsController controller = Get.put(AnalyticsController());

  AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analytics",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          if (controller.totalTasks.value == 0) {
            return Center(child: Text("No tasks available"));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Stats
              Row(
                children: [
                  _statCard("Total", controller.totalTasks.value, Colors.blue),
                  const SizedBox(width: 8),
                  _statCard(
                    "Completed",
                    controller.completedTasks.value,
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _statCard(
                    "Pending",
                    controller.pendingTasks.value,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Pie Chart
              const Text(
                "Tasks Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        value: controller.completedTasks.value.toDouble(),
                        title: "Completed",
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: controller.pendingTasks.value.toDouble(),
                        title: "Pending",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bar Chart
              const Text(
                "Tasks per Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final keys = controller.categoryCounts.keys
                                .toList();
                            if (value.toInt() < keys.length) {
                              return Text(keys[value.toInt()]);
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(controller.categoryCounts.length, (
                      i,
                    ) {
                      final count = controller.categoryCounts.values
                          .toList()[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: count.toDouble(),
                            color: Colors.blue,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Line Chart (Completed over time)
              if (controller.completedOverTime.isNotEmpty) ...[
                const Text(
                  "Tasks Completed Over Time",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final keys = controller.completedOverTime.keys
                                  .toList();
                              if (value.toInt() < keys.length) {
                                return Text(
                                  keys[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text("");
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.green,
                          spots: List.generate(
                            controller.completedOverTime.length,
                            (i) {
                              final y = controller.completedOverTime.values
                                  .toList()[i];
                              return FlSpot(i.toDouble(), y.toDouble());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
