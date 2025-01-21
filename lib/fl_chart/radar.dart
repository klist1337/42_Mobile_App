import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadarChartSample1 extends StatefulWidget {
  const RadarChartSample1({
    super.key,
    required this.skillsColor,
    required this.skillsValue,
  });

  final Color skillsColor;
  final List<double> skillsValue;
  final Color gridColor = Colors.white;

  @override
  State<RadarChartSample1> createState() => _RadarChartSample1State();
}

class _RadarChartSample1State extends State<RadarChartSample1>
    with SingleTickerProviderStateMixin {
  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = false;
  String selectedValue = "";

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: windowWidth > 600 ? 4 : 2,
            child: Stack(
              children: [
                RadarChart(
                  RadarChartData(
                    radarTouchData: RadarTouchData(
                      touchCallback: (FlTouchEvent event, response) {
                        if (!event.isInterestedForInteractions) {
                          setState(() {
                            selectedDataSetIndex = -1;
                            selectedValue = "";
                          });
                          return;
                        }
                        setState(() {
                          selectedDataSetIndex =
                              response?.touchedSpot?.touchedDataSetIndex ?? -1;
                          if (response?.touchedSpot != null) {
                            selectedValue = widget
                                .skillsValue[response!.touchedSpot!.touchedRadarEntryIndex]
                                .toStringAsFixed(2);
                          }
                        });
                      },
                    ),
                    dataSets: showingDataSets(),
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData: const BorderSide(color: Colors.transparent),
                    titlePositionPercentageOffset: 0.4,
                    titleTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 10),
                    getTitle: (index, angle) {
                      final usedAngle =
                          relativeAngleMode ? angle + angleValue : angleValue;
                      switch (index) {
                        case 0:
                          return RadarChartTitle(
                            text: 'Rigor',
                            angle: usedAngle,
                          );
                        case 1:
                          return RadarChartTitle(
                            text: 'Compagnie experience',
                            angle: usedAngle,
                          );
                        case 2:
                          return RadarChartTitle(
                              text: 'Network and systeme administration',
                              angle: usedAngle);
                        case 3:
                          return RadarChartTitle(
                              text: 'Object oriented programming',
                              angle: usedAngle);
                        case 4:
                          return RadarChartTitle(
                              text: 'Web', angle: usedAngle);
                        case 5:
                          return RadarChartTitle(
                              text: 'Group & Interpersonal',
                              angle: usedAngle);
                        case 6:
                          return RadarChartTitle(
                              text: 'Imperative programming',
                              angle: usedAngle);
                        case 7:
                          return RadarChartTitle(
                              text: 'Unix', angle: usedAngle);
                        case 8:
                          return RadarChartTitle(
                              text: 'Algorithms & AI', angle: usedAngle);
                        case 9:
                          return RadarChartTitle(
                              text: 'Graphics', angle: usedAngle);
                        case 10:
                          return RadarChartTitle(
                              text: 'Techology Integration',
                              angle: usedAngle);
                        case 11:
                          return RadarChartTitle(
                              text: 'Adaption & Creativity',
                              angle: usedAngle);
                        default:
                          return const RadarChartTitle(text: '');
                      }
                    },
                    tickCount: 1,
                    ticksTextStyle:
                        const TextStyle(color: Colors.transparent, fontSize: 10),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    gridBorderData:
                        BorderSide(color: widget.gridColor, width: 2),
                  ),
                  duration: const Duration(milliseconds: 400),
                ),
                if (selectedValue.isNotEmpty)
                  Center(
                    child: AnimatedOpacity(
                      opacity: selectedValue.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          selectedValue,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withValues(alpha: 0.2)
            : rawDataSet.color.withValues(alpha: 0.05),
        borderColor: isSelected
            ? rawDataSet.color
            : rawDataSet.color.withValues(alpha: 0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'Skills',
        color: widget.skillsColor,
        values: widget.skillsValue,
      ),
    ];
  }
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}
