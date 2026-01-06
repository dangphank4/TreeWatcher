import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/device/general/device_module_routes.dart';
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
  // ===== THEME =====
  static const _bg = Color(0xFF000D00);
  static const _card = Color(0xFF002200);
  static const _accent = Color(0xFF22C55E);


  late final String deviceId;
  late final String deviceName;
  late final String userId;

  Duration _currentRange = const Duration(days: 7);
  String _selectedMetric = 'light';

  @override
  void initState() {
    super.initState();

    final args = Modular.args.data as Map<String, dynamic>;
    deviceId = args['deviceId'];
    deviceName = args['deviceName'];
    userId = args['userId'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();

      BlocProvider.of<DeviceDetailBloc>(context)
          .add(WatchDevice(deviceId));

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001600),
        elevation: 0,
        centerTitle: true,
        title: Text(
          deviceName,
          style: Styles.h4.smb.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRealtimeView(),
            const SizedBox(height: 24),
            _buildChartSection(),
          ],
        ),
      ),
    );
  }

  // ================= REALTIME =================
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
          return const Text(
            'Không có dữ liệu',
            style: TextStyle(color: Colors.white54),
          );
        }

        return Column(
          children: [
            _buildControllerCard(state.controller ?? {}),
            const SizedBox(height: 16),
            _buildSensorGrid(state.sensor!),
          ],
        );
      },
    );
  }

  // ================= CONTROLLER =================
  Widget _buildControllerCard(Map<String, dynamic> controller) {
    final isAuto = controller['auto'] == 1;
    final motorOn = controller['motor_state'] == 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT INFO
          Row(
            children: [
              Icon(Icons.settings, color: _accent),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chế độ',
                    style: Styles.small.regular
                        .copyWith(color: Colors.white60),
                  ),
                  Text(
                    isAuto ? 'Tự động' : 'Thủ công',
                    style:
                    Styles.medium.smb.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),

          /// RIGHT ACTION
          Row(
            children: [
              Icon(
                Icons.water_drop,
                size: 22,
                color: motorOn ? Colors.blue : Colors.white24,
              ),
              const SizedBox(width: 10),

              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  NavigationHelper.navigate(
                    '${AppRoutes.moduleDevice}${DeviceModuleRoutes.control}',
                    args: {
                      'deviceId': deviceId,
                      'deviceName': deviceName,
                      'userId': userId,
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.tune,
                        size: 18,
                        color: Colors.black,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Điều khiển',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ================= SENSOR GRID =================
  Widget _buildSensorGrid(Map<String, dynamic> sensor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _sensorTile('Nhiệt độ', sensor['temp'], 'temp',
            Icons.thermostat, '°C', Colors.orange),
        _sensorTile('Độ ẩm KK', sensor['hum_air'], 'hum_air',
            Icons.water_drop, '%', Colors.blue),
        _sensorTile('Độ ẩm đất', sensor['hum_soil'], 'hum_soil',
            Icons.grass, '%', Colors.brown),
        _sensorTile('Ánh sáng', sensor['light'], 'light',
            Icons.wb_sunny, '', Colors.amber),
      ],
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
      onTap: () => setState(() => _selectedMetric = metric),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: selected ? 20 : 10,
              offset: const Offset(0, 8),
              color:
              color.withValues(alpha: selected ? 0.35 : 0.15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Styles.small.smb
                        .copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value?.toString() ?? '--',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              unit,
              style:
              const TextStyle(fontSize: 12, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CHART =================
  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart,
                  color: _metricColor(_selectedMetric)),
              const SizedBox(width: 8),
              Text(
                'Biểu đồ',
                style:
                Styles.medium.smb.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDateRangePicker(),
          const SizedBox(height: 16),
          BlocBuilder<DeviceDetailBloc, DeviceDetailState>(
            builder: (context, state) {
              if (state.loading && state.logs.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              if (state.logs.isEmpty) {
                return const Text(
                  'Không có dữ liệu',
                  style: TextStyle(color: Colors.white54),
                );
              }

              return SizedBox(
                height: 300,
                child: _buildLineChartRaw(state.logs),
              );
            },
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

  Widget _rangeButton(String label, Duration range) {
    final selected = _currentRange == range;

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          selected ? _accent : _accent.withValues(alpha: 0.2),
          foregroundColor:
          selected ? Colors.black : _accent,
        ),
        onPressed: () {
          final now = DateTime.now();
          setState(() => _currentRange = range);

          BlocProvider.of<DeviceDetailBloc>(context).add(
            LoadDeviceLogs(
              deviceId: deviceId,
              from: now.subtract(range),
              to: now,
            ),
          );
        },
        child: Text(label),
      ),
    );
  }

  Widget _buildLineChartRaw(List<Map<String, dynamic>> logs) {
    final spots = _toSpots(logs, _selectedMetric);

    if (spots.length < 2) {
      return const Center(
        child: Text(
          'Chưa đủ dữ liệu',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    // ===== TÍNH MIN / MAX + PADDING Y =====
    final ys = spots.map((e) => e.y).toList();
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);

    final range = (maxY - minY).abs();
    final padding = range == 0 ? maxY * 0.2 : range * 0.15;

    // ===== SCROLL NGANG =====
    const double pointWidth = 50;
    final chartWidth = spots.length * pointWidth;

    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: spots.length - 1,
              minY: minY - padding,
              maxY: maxY + padding,

              // ===== GRID =====
              gridData: FlGridData(
                show: true,
                horizontalInterval: range == 0 ? null : range / 4,
              ),

              borderData: FlBorderData(show: false),

              // ===== LINE =====
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  color: _metricColor(_selectedMetric),
                ),
              ],

              // ===== TITLES =====
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: (spots.length / 5)
                        .floorToDouble()
                        .clamp(1, double.infinity),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= logs.length) {
                        return const SizedBox.shrink();
                      }

                      final ts = logs[index]['logged_at'];
                      final time =
                      ts is DateTime ? ts : ts.toDate();

                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 46,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          _formatY(value),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  String _formatY(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(1);
  }


  // ================= UTILS =================
  List<FlSpot> _toSpots(
      List<Map<String, dynamic>> logs,
      String field,
      ) {
    final spots = <FlSpot>[];

    for (int i = 0; i < logs.length; i++) {
      final e = logs[i];

      if (e[field] == null) continue;

      spots.add(
        FlSpot(
          i.toDouble(),
          (e[field] as num).toDouble(),
        ),
      );
    }

    return spots;
  }


  BoxDecoration _cardDecoration() => BoxDecoration(
    color: _card,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        blurRadius: 20,
        offset: const Offset(0, 10),
        color: Colors.black.withValues(alpha: 0.35),
      ),
    ],
  );

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
