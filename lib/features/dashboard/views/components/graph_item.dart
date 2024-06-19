import 'package:doctors_appointment/utils/colors.dart';
import 'package:doctors_appointment/utils/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GraphItel extends ConsumerStatefulWidget {
  const GraphItel(
      {required this.data,
      required this.title,
      this.gradientColors = const [primaryColor, secondaryColor],
      super.key});
  final List<Map<String, dynamic>> data;
  final List<Color> gradientColors;
  final String title;
  @override
  ConsumerState<GraphItel> createState() => _GraphItelState();
}

class _GraphItelState extends ConsumerState<GraphItel> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    return Container(
      width: styles.isMobile
          ? double.infinity
          : styles.isTablet
              ? styles.width * .4
              : styles.width * .4,
      height: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 10,
          bottom: 12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: styles.body(
                    desktop: 22,
                    tablet: 20,
                    mobile: 18,
                    color: primaryColor,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if(widget.data.isEmpty)
              const Center(child: Text('No data found')),
            if(widget.data.isNotEmpty)
            Expanded(
              child: LineChart(
                mainData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 11,
    );

    var valueText = widget.data[value.floor()]['date'];

    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          '$valueText',
          style: style,
          textAlign: TextAlign.center,
        ));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return Text(value.toString(), style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: primaryColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(199, 26, 7, 87),
            strokeWidth: 1,
          );
        },
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
          axisNameWidget:
              const Text('Date', style: TextStyle(color: primaryColor)),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.data.length.toDouble() - 1,
      minY: 0,
      maxY: widget.data
              .map((e) => e['count'])
              .reduce((a, b) => a > b ? a : b)
              .toDouble() +
          1,
      lineBarsData: [
        LineChartBarData(
          spots: widget.data.map((e) {
            return FlSpot(
              widget.data.indexOf(e).toDouble(),
              e['count'].toDouble(),
            );
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: widget.gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: widget.gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
