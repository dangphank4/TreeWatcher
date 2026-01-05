import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fl_chart/fl_chart.dart';

import '../blocs/device_detail_bloc.dart';

class DetailDevicePage extends StatefulWidget {
  const DetailDevicePage({super.key});

  @override
  State<DetailDevicePage> createState() => _DetailDevicePageState();
}

class _DetailDevicePageState extends State<DetailDevicePage>
    with SingleTickerProviderStateMixin {
  late final String deviceId;
  late final TabController _tabController;

  Duration _currentRange = const Duration(days: 7);
  String _selectedMetric = 'temp';

  @override
  void initState() {
    super.initState();

    final args = Modular.args.data as Map<String, dynamic>;
    deviceId = args['sensorId'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();

      // watch realtime
      BlocProvider.of<DeviceDetailBloc>(context).add(WatchDevice(deviceId));

      // load mặc định 7 ngày
      BlocProvider.of<DeviceDetailBloc>(context).add(
        LoadDeviceLogs(
          deviceId: deviceId,
          from: now.subtract(const Duration(days: 7)),
          to: now,
        ),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000D00),
      appBar: AppBar(
        title: const Text('Chi tiết thiết bị'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRealtimeView(),   // controller + grid
            const SizedBox(height: 20),
            _buildChartSection()   // biểu đồ cố định bên dưới
          ],
        ),
      ),

    );
  }

  Widget _buildRealtimeView() {
    return BlocBuilder<DeviceDetailBloc, DeviceDetailState>(
      builder: (context, state) {
        if (state.loading && state.sensor == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Text(
            state.error!,
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state.sensor == null) {
          return const Text('Không có dữ liệu');
        }

        final sensor = state.sensor!;
        final controller = state.controller ?? {};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildControllerCard(controller),
            const SizedBox(height: 16),
            _buildSensorGrid(sensor),
          ],
        );
      },
    );
  }


  Widget _buildSensorGrid(Map<String, dynamic> sensor) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _sensorTile('Nhiệt độ', sensor['temp'], 'temp', Icons.thermostat, '°C', Colors.orange),
        _sensorTile('Độ ẩm KK', sensor['hum_air'], 'hum_air', Icons.water_drop, '%', Colors.blue),
        _sensorTile('Độ ẩm đất', sensor['hum_soil'], 'hum_soil', Icons.grass, '%', Colors.brown),
        _sensorTile('Ánh sáng', sensor['light'], 'light', Icons.wb_sunny, '', Colors.amber),
      ],
    );
  }


  //Controller card
  Widget _buildControllerCard(Map<String, dynamic> controller) {
    final isAuto = controller['auto'] == 1;
    final motorOn = controller['motor_state'] == 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: 8),
              Text(isAuto ? 'Auto' : 'Manual'),
            ],
          ),
          Row(
            children: [
              Switch(
                value: isAuto,
                onChanged: (_) {
                  // TODO: dispatch event setAuto
                },
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.water_drop,
                color: motorOn ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildDateRangePicker() {
    return Row(
      children: [
        _rangeButton('1 giờ', const Duration(hours: 1)),
        const SizedBox(width: 8),
        _rangeButton('24 giờ', const Duration(days: 1)),
        const SizedBox(width: 8),
        _rangeButton('7 ngày', const Duration(days: 7)),
      ],
    );
  }

  Widget _buildLogCard(
      String title,
      String field,
      List<Map<String, dynamic>> logs,
      Color color,
      ) {
    // Tính toán min, max, avg
    final values = logs
        .map((log) => (log[field] ?? 0).toDouble())
        .where((v) => v > 0)
        .toList().cast<double>();

    if (values.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('$title: Không có dữ liệu'),
      );
    }

    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final avg = values.reduce((a, b) => a + b) / values.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statBox('Min', min.toStringAsFixed(1), Colors.blue.shade100),
              _statBox('Trung bình', avg.toStringAsFixed(1), Colors.green.shade100),
              _statBox('Max', max.toStringAsFixed(1), Colors.red.shade100),
            ],
          ),
          const SizedBox(height: 16),
          // Simple bar chart visualization
          SizedBox(
            height: 220,
            child: _buildLineChartRaw(logs),
          ),
          const SizedBox(height: 8),
          Text(
            '${values.length} điểm dữ liệu',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biểu đồ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          _buildDateRangePicker(),

          const SizedBox(height: 16),

          BlocBuilder<DeviceDetailBloc, DeviceDetailState>(
            builder: (context, state) {
              if (state.loading && state.logs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.logs.isEmpty) {
                return const Text('Không có dữ liệu');
              }

              return _buildLogCard(
                _metricTitle(_selectedMetric),
                _selectedMetric,
                state.logs,
                _metricColor(_selectedMetric),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _sensorTile(
      String title,
      dynamic value,
      String metric,
      IconData icon,
      String unit,
      Color color,
      ) {
    final selected = _selectedMetric == metric;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() => _selectedMetric = metric);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.9) : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.06),
            )
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: selected ? color : Colors.grey.shade600, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value?.toString() ?? '--',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: selected ? color : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartRaw(List<Map<String, dynamic>> logs) {
    final spots = _toSpots(logs, _selectedMetric);

    if (spots.length < 2) {
      return const Text('Chưa đủ dữ liệu để vẽ biểu đồ');
    }

    final minX = spots.first.x;
    final maxX = spots.last.x;

    final ys = spots.map((e) => e.y).toList();
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2,
              dotData: FlDotData(show: true),
              color: _metricColor(_selectedMetric),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxX - minX) / 4,
                getTitlesWidget: (value, meta) {
                  final dt =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Text(
                    '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY - minY) / 4,
              ),
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }


  Widget _rangeButton(String label, Duration range) {
    final selected = _currentRange == range;

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          selected ? Colors.green : Colors.green.shade100,
          foregroundColor:
          selected ? Colors.white : Colors.green.shade800,
        ),
        onPressed: () {
          final now = DateTime.now();

          setState(() {
            _currentRange = range;
          });

          _loadLogs(
            now.subtract(range),
            now,
          );
        },
        child: Text(label),
      ),
    );
  }

  Map<int, double> buildValueMap(
      List<Map<String, dynamic>> logs,
      String field,
      ) {
    final map = <int, double>{};

    for (final log in logs) {
      final rawTs = log['logged_at'];

      if (rawTs == null) continue;

      final DateTime time = rawTs is DateTime
          ? rawTs
          : rawTs.toDate();

      final ts = time.millisecondsSinceEpoch;

      map[ts] = (log[field] ?? 0).toDouble();
    }

    return map;
  }


  List<FlSpot> buildSpotsWithZero({
    required DateTime from,
    required DateTime to,
    required Duration step,
    required List<Map<String, dynamic>> logs,
    required String field,
  }) {
    final valueMap = buildValueMap(logs, field);
    final spots = <FlSpot>[];

    for (
    DateTime t = from;
    !t.isAfter(to);
    t = t.add(step)
    ) {
      final key = t.millisecondsSinceEpoch;

      final value = valueMap[key] ?? 0.0;

      spots.add(
        FlSpot(
          key.toDouble(),
          value,
        ),
      );
    }

    return spots;
  }


  void _loadLogs(DateTime from, DateTime to) {
    BlocProvider.of<DeviceDetailBloc>(context).add(
      LoadDeviceLogs(
        deviceId: deviceId,
        from: from,
        to: to,
      ),
    );
  }

  List<FlSpot> _toSpots(
      List<Map<String, dynamic>> logs,
      String field,
      ) {
    return logs
        .where((e) => e[field] != null && e['logged_at'] != null)
        .map((e) {
      final ts = e['logged_at'];
      final time = ts is DateTime ? ts : ts.toDate();

      return FlSpot(
        time.millisecondsSinceEpoch.toDouble(),
        (e[field] as num).toDouble(),
      );
    })
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }


  String _metricTitle(String key) {
    switch (key) {
      case 'temp':
        return 'Nhiệt độ (°C)';
      case 'hum_air':
        return 'Độ ẩm không khí (%)';
      case 'hum_soil':
        return 'Độ ẩm đất (%)';
      case 'light':
        return 'Ánh sáng';
      default:
        return '';
    }
  }

  Color _metricColor(String key) {
    switch (key) {
      case 'temp':
        return Colors.orange;
      case 'hum_air':
        return Colors.blue;
      case 'hum_soil':
        return Colors.brown;
      case 'light':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

}