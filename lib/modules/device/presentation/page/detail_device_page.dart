import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/device/general/device_module_routes.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DetailDevicePage extends StatefulWidget {
  const DetailDevicePage({super.key});

  @override
  State<DetailDevicePage> createState() => _DetailDevicePageState();
}

class _DetailDevicePageState extends State<DetailDevicePage>
    with SingleTickerProviderStateMixin {
  // ===== THEME =====
  static const _bg = Color(0xFF0B1210);
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
        backgroundColor: const Color(0xFF0F1F18),
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

  // Hàm giảm bớt số lượng log hiển thị để biểu đồ không bị dày
  List<Map<String, dynamic>> _downsampleLogs(List<Map<String, dynamic>> logs) {
    // Nếu số lượng log ít hơn ngưỡng (ví dụ 60 điểm), hiển thị hết
    const int targetPoints = 60;

    if (logs.length <= targetPoints) {
      return logs;
    }

    // Tính bước nhảy. Ví dụ có 1200 log, muốn còn 60 log => lấy mỗi 20 log 1 lần
    int step = (logs.length / targetPoints).ceil();

    List<Map<String, dynamic>> sampled = [];
    for (int i = 0; i < logs.length; i += step) {
      sampled.add(logs[i]);
    }

    // Đảm bảo luôn lấy điểm cuối cùng để biểu đồ cập nhật nhất
    if (sampled.last != logs.last) {
      sampled.add(logs.last);
    }

    return sampled;
  }

  // ... (Giữ nguyên các hàm _toSpots, _cardDecoration, _metricColor cũ)



  Widget _buildLineChartRaw(List<Map<String, dynamic>> rawLogs) {
    // 1. Áp dụng lọc dữ liệu trước khi tạo Spot
    final processedLogs = _downsampleLogs(rawLogs);

    // 2. Tạo spots từ dữ liệu đã lọc
    final spots = _toSpots(processedLogs, _selectedMetric);

    if (spots.length < 2) {
      return const Center(
        child: Text('Chưa đủ dữ liệu để hiển thị biểu đồ',
            style: TextStyle(color: Colors.white54)),
      );
    }

    final ys = spots.map((e) => e.y).toList();
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    final range = (maxY - minY).abs();
    final padding = range == 0 ? 1.0 : range * 0.2;

    final Color currentColor = _metricColor(_selectedMetric);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withValues(alpha: 0.05),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              // Vì số lượng điểm đã giảm xuống (~60), ta có thể fix interval hoặc để tự động
              interval: (spots.length / 5).clamp(1, double.infinity),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                // LƯU Ý: Phải dùng processedLogs ở đây, không dùng rawLogs
                if (index < 0 || index >= processedLogs.length) return const SizedBox();

                final log = processedLogs[index]; // Lấy từ list đã lọc
                final DateTime date = log['logged_at'] is DateTime
                    ? log['logged_at']
                    : log['logged_at'].toDate();

                String text = _currentRange.inDays >= 1
                    ? DateFormat('HH:mm').format(date) // 24h hoặc 7d hiện giờ:phút
                    : DateFormat('mm:ss').format(date); // 1h hiện phút:giây

                // Nếu là 7 ngày, có thể hiển thị thêm ngày
                if (_currentRange.inDays >= 7) {
                  text = DateFormat('dd/MM').format(date);
                }

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                _formatY(value),
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minY - padding,
        maxY: maxY + padding,

        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                // LƯU Ý: Phải dùng processedLogs ở đây để map đúng index
                final index = spot.x.toInt();
                if (index >= processedLogs.length) return null;

                final date = processedLogs[index]['logged_at'];
                final timeStr = DateFormat('HH:mm dd/MM').format(
                    date is DateTime ? date : date.toDate());

                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}\n',
                  TextStyle(color: currentColor, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: timeStr,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: currentColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  currentColor.withValues(alpha: 0.3),
                  currentColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
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
