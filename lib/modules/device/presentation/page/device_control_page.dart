import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../blocs/device_detail_bloc.dart';

class DeviceControlPage extends StatefulWidget {
  const DeviceControlPage({super.key});

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage> {
  late String deviceId;
  late String deviceName;
  late String userId;

  int minHumidity = 30;
  int maxHumidity = 70;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Lấy arguments từ Modular
    final args = Modular.args.data as Map<String, dynamic>;
    deviceId = args['deviceId'];
    deviceName = args['deviceName'];
    userId = args['userId'];

    // Init BLoC sau khi frame render - watch realtime data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<DeviceDetailBloc>(context)
          .add(WatchDevice(deviceId));
    });
  }

  Future<void> _showTimePickerDialog(BuildContext context, String currentTime) async {
    // Parse current time
    final parts = currentTime.split(':');
    int hour = 0, minute = 0, second = 0;

    try {
      if (parts.length >= 3) {
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
        second = int.parse(parts[2]);
      }
    } catch (e) {
      hour = DateTime.now().hour;
      minute = DateTime.now().minute;
      second = 0;
    }

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => _TimePickerDialog(
        initialHour: hour,
        initialMinute: minute,
        initialSecond: second,
      ),
    );

    if (result != null) {
      final timeString =
          '${result['hour'].toString().padLeft(2, '0')}:'
          '${result['minute'].toString().padLeft(2, '0')}:'
          '${result['second'].toString().padLeft(2, '0')}';

      if (mounted) {
        BlocProvider.of<DeviceDetailBloc>(this.context).add(
          SetScheduleTime(
            deviceId: deviceId,
            time: timeString,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1210),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1F18),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Điều khiển $deviceName',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<DeviceDetailBloc, DeviceDetailState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state.controlError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.controlError!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<DeviceDetailBloc, DeviceDetailState>(
          builder: (context, state) {
            final controller = state.controller ?? {};
            final isAuto = (controller['auto'] ?? 0) == 1;
            final isMotorOn = (controller['motor_state'] ?? 0) == 1;
            final scheduleTime = controller['motor_time_start'] ?? '--:--:--';
            final currentMinHum = controller['min_hum'] ?? 30;
            final currentMaxHum = controller['max_hum'] ?? 70;
            final rawTimeout = controller['timeout'];
            final timeout = (rawTimeout is int && rawTimeout >= 1) ? rawTimeout : 1;

            // Initialize humidity values once from database
            if (!_isInitialized && controller.isNotEmpty) {
              minHumidity = currentMinHum;
              maxHumidity = currentMaxHum;
              _isInitialized = true;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chế độ hoạt động
                  _buildSectionTitle('Chế độ hoạt động'),
                  const SizedBox(height: 12),
                  _buildModeCard(
                    context: context,
                    isAuto: isAuto,
                    isLoading: state.controlLoading,
                  ),

                  const SizedBox(height: 24),

                  // Hiển thị theo chế độ
                  if (!isAuto) ...[
                    // CHẾ ĐỘ THỦ CÔNG - Chỉ hiện điều khiển motor
                    _buildSectionTitle('Điều khiển thủ công'),
                    const SizedBox(height: 12),
                    _buildManualControlCard(
                      context: context,
                      isMotorOn: isMotorOn,
                      isLoading: state.controlLoading,
                    ),
                  ] else ...[
                    // CHẾ ĐỘ TỰ ĐỘNG - Hiện hẹn giờ + độ ẩm
                    _buildSectionTitle('Hẹn giờ tưới'),
                    const SizedBox(height: 12),
                    _buildScheduleCard(
                      context: context,
                      currentTime: scheduleTime,
                      isLoading: state.controlLoading,
                    ),

                    const SizedBox(height: 24),

                    _buildSectionTitle('Ngưỡng độ ẩm tự động'),
                    const SizedBox(height: 12),
                    _buildHumidityCard(
                      context: context,
                      isLoading: state.controlLoading,
                    ),
                  ],

                  const SizedBox(height: 24),

                  _buildSectionTitle('Giới hạn thời gian bơm'),
                  const SizedBox(height: 12),
                  _buildTimeoutCard(
                    context: context,
                    timeout: timeout,
                    isLoading: state.controlLoading,
                  ),

                  const SizedBox(height: 24),

                  // Trạng thái motor (luôn hiển thị)
                  _buildMotorStatusCard(
                    isMotorOn: isMotorOn,
                    isAuto: isAuto,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeoutCard({
    required BuildContext context,
    required int timeout,
    required bool isLoading,
  }) {
    final safeTimeout = timeout < 1 ? 1 : timeout;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2ECC71).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TITLE =====
          Row(
            children: const [
              Icon(Icons.timer, color: Color(0xFF2ECC71), size: 24),
              SizedBox(width: 8),
              Text(
                'Thời gian bơm tối đa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            'Bơm sẽ tự động dừng sau $safeTimeout giây kể từ khi bật',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 16),

          // ===== BUTTON OPEN DIALOG =====
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                final result = await showDialog<int>(
                  context: context,
                  builder: (_) => _TimeoutPickerDialog(
                    initialTimeout: safeTimeout,
                  ),
                );

                if (result != null && mounted) {
                  BlocProvider.of<DeviceDetailBloc>(this.context).add(
                    SetMotorTimeout(
                      deviceId: deviceId,
                      timeoutSeconds: result,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.edit),
              label: Text(
                'Chỉnh thời gian ($safeTimeout giây)',
                style: const TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: const [
              Icon(
                Icons.info_outline,
                color: Color(0xFF2ECC71),
                size: 16,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Áp dụng cho cả chế độ thủ công và tự động',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required bool isAuto,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2ECC71).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAuto ? Icons.autorenew : Icons.touch_app,
                      color: const Color(0xFF2ECC71),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isAuto ? 'Tự động' : 'Thủ công',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isAuto
                      ? 'Hệ thống tự động điều khiển theo lịch & độ ẩm'
                      : 'Điều khiển bằng tay',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Color(0xFF2ECC71)),
              ),
            )
          else
            Switch(
              value: isAuto,
              onChanged: (value) {
                BlocProvider.of<DeviceDetailBloc>(context).add(
                  SetAutoMode(
                    deviceId: deviceId,
                    auto: value,
                  ),
                );
              },

            ),
        ],
      ),
    );
  }

  Widget _buildManualControlCard({
    required BuildContext context,
    required bool isMotorOn,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMotorOn
              ? const Color(0xFF2ECC71)
              : Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.water_drop,
            color: isMotorOn ? const Color(0xFF2ECC71) : Colors.white54,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isMotorOn ? 'Motor đang BẬT' : 'Motor đang TẮT',
            style: TextStyle(
              color: isMotorOn ? const Color(0xFF2ECC71) : Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isMotorOn)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '🌊 Đang tưới... (tự dừng khi đạt ngưỡng)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading || isMotorOn
                      ? null
                      : () {
                    BlocProvider.of<DeviceDetailBloc>(context).add(
                      SetMotorManual(
                        deviceId: deviceId,
                        on: true,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2ECC71),
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading && !isMotorOn
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : const Text(
                    'BẬT TƯỚI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading || !isMotorOn
                      ? null
                      : () {
                    BlocProvider.of<DeviceDetailBloc>(context).add(
                      SetMotorManual(
                        deviceId: deviceId,
                        on: false,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading && isMotorOn
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : const Text(
                    'DỪNG',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A2F1F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF2ECC71),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Motor sẽ tự động dừng khi đạt ngưỡng độ ẩm',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
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

  Widget _buildScheduleCard({
    required BuildContext context,
    required String currentTime,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2ECC71).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: Color(0xFF2ECC71),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Giờ tưới hằng ngày',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2F1F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF2ECC71),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => _showTimePickerDialog(context, currentTime),
              icon: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Icon(Icons.edit),
              label: const Text(
                'Thay đổi giờ',
                style: TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityCard({
    required BuildContext context,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2ECC71).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water_damage,
                color: Color(0xFF2ECC71),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ngưỡng độ ẩm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Motor sẽ tự động bật khi độ ẩm < $minHumidity% và tắt khi > $maxHumidity%',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tối thiểu',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$minHumidity%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: minHumidity.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: const Color(0xFF2ECC71),
                      inactiveColor: Colors.white24,
                      onChanged: (value) {
                        setState(() {
                          minHumidity = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tối đa',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$maxHumidity%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: maxHumidity.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: const Color(0xFF2ECC71),
                      inactiveColor: Colors.white24,
                      onChanged: (value) {
                        setState(() {
                          maxHumidity = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                if (minHumidity >= maxHumidity) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Độ ẩm tối thiểu phải nhỏ hơn tối đa!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                BlocProvider.of<DeviceDetailBloc>(context).add(
                  SetHumidityRange(
                    deviceId: deviceId,
                    minHum: minHumidity,
                    maxHum: maxHumidity,
                  ),
                );
              },
              icon: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Icon(Icons.save),
              label: const Text(
                'Lưu cài đặt',
                style: TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorStatusCard({
    required bool isMotorOn,
    required bool isAuto,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMotorOn
            ? const Color(0xFF2ECC71).withValues(alpha: 0.15)
            : const Color(0xFF1A4D3A).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMotorOn
              ? const Color(0xFF2ECC71)
              : Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMotorOn
                  ? const Color(0xFF2ECC71)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isMotorOn ? Icons.power : Icons.power_off,
              color: isMotorOn ? Colors.white : Colors.white54,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trạng thái Motor',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isMotorOn
                            ? const Color(0xFF2ECC71)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isMotorOn ? 'Đang hoạt động' : 'Đã dừng',
                      style: TextStyle(
                        color: isMotorOn
                            ? const Color(0xFF2ECC71)
                            : Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isAuto
                  ? const Color(0xFF2ECC71).withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isAuto ? 'Tự động' : 'Thủ công',
              style: TextStyle(
                color: isAuto ? const Color(0xFF2ECC71) : Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Time Picker Dialog - Chọn giờ, phút, giây giống điện thoại
class _TimePickerDialog extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final int initialSecond;

  const _TimePickerDialog({
    required this.initialHour,
    required this.initialMinute,
    required this.initialSecond,
  });

  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;

  late int selectedHour;
  late int selectedMinute;
  late int selectedSecond;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialHour;
    selectedMinute = widget.initialMinute;
    selectedSecond = widget.initialSecond;

    _hourController = FixedExtentScrollController(initialItem: selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    _secondController = FixedExtentScrollController(initialItem: selectedSecond);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A4D3A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chọn thời gian',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Time Picker Wheels
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0A2F1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Hour
                  Expanded(
                    child: _buildScrollWheel(
                      controller: _hourController,
                      itemCount: 24,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedHour = index;
                        });
                      },
                      label: 'Giờ',
                    ),
                  ),

                  // Separator
                  const Text(
                    ':',
                    style: TextStyle(
                      color: Color(0xFF2ECC71),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Minute
                  Expanded(
                    child: _buildScrollWheel(
                      controller: _minuteController,
                      itemCount: 60,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMinute = index;
                        });
                      },
                      label: 'Phút',
                    ),
                  ),

                  // Separator
                  const Text(
                    ':',
                    style: TextStyle(
                      color: Color(0xFF2ECC71),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Second
                  Expanded(
                    child: _buildScrollWheel(
                      controller: _secondController,
                      itemCount: 60,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedSecond = index;
                        });
                      },
                      label: 'Giây',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'hour': selectedHour,
                        'minute': selectedMinute,
                        'second': selectedSecond,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required ValueChanged<int> onSelectedItemChanged,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final isSelected = (controller.hasClients &&
                    controller.selectedItem == index);

                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF2ECC71)
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: isSelected ? 28 : 20,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeoutPickerDialog extends StatefulWidget {
  final int initialTimeout; // giây

  const _TimeoutPickerDialog({
    required this.initialTimeout,
  });

  @override
  State<_TimeoutPickerDialog> createState() => _TimeoutPickerDialogState();
}

class _TimeoutPickerDialogState extends State<_TimeoutPickerDialog> {
  late FixedExtentScrollController _controller;
  late int selectedTimeout;

  @override
  void initState() {
    super.initState();
    selectedTimeout = widget.initialTimeout.clamp(1, 300);
    _controller = FixedExtentScrollController(
      initialItem: selectedTimeout - 1, // vì min = 1
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A4D3A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Thời gian bơm tối đa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Đơn vị: giây',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            // ===== WHEEL =====
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0A2F1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedTimeout = index + 1; // min = 1
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 300, // 1 → 300 giây
                  builder: (context, index) {
                    final value = index + 1;
                    final isSelected = value == selectedTimeout;

                    return Center(
                      child: Text(
                        '$value',
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF2ECC71)
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: isSelected ? 30 : 20,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== BUTTONS =====
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedTimeout);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
