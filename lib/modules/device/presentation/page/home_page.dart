import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_dimensions.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/modules/account/data/repositories/account_repository.dart';
import 'package:flutter_api/modules/device/general/device_module_routes.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_bloc.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_event.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AccountRepository _accountRepository;
  late final DeviceBloc _deviceBloc;

  String? _userId;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _accountRepository = Modular.get<AccountRepository>();
    _deviceBloc = Modular.get<DeviceBloc>();
    _initUser();
  }

  Future<void> _initUser() async {
    final user = await _accountRepository.getCurrentUser();
    if (!mounted) return;

    if (user?.userId != null) {
      _userId = user!.userId;
      _userName = user.fullName;
      _deviceBloc.add(LoadDevices(_userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF000D00),
      appBar: AppBar(
        backgroundColor: Color(0xFF001600),
        title: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            context.localization.deviceListTitle,
            style: Styles.h1.smb.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
      body: BlocListener<DeviceBloc, DeviceState>(
        bloc: _deviceBloc,
        listener: (context, state) {
          if (state is DeviceSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RefreshIndicator(
            onRefresh: () async {
              if (_userId != null) {
                _deviceBloc.add(LoadDevices(_userId!));
              }
            },
            child: BlocBuilder<DeviceBloc, DeviceState>(
              bloc: _deviceBloc,
              builder: (context, state) {
                if (state is DeviceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DeviceFailure) {
                  return _buildError(state.error);
                }

                if (state is DeviceLoaded) {
                  return _buildContent(state.devices);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List devices) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        ...devices.map(_buildDeviceItem),
        AppDimensions.paddingNavBar.verticalSpace,
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Text(
                '${context.localization.goodMorning} $_userName',
                style: Styles.large.smb.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                context.localization.welcomeBackMessage,
                style: Styles.medium.regular.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        16.horizontalSpace,
        _buildAddDeviceButton(),
      ],
    );
  }

  Widget _buildAddDeviceButton() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            NavigationHelper.navigate(
              '${AppRoutes.moduleDevice}${DeviceModuleRoutes.addDevice}',
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        4.verticalSpace,
        Text(
          'Add device',
          style: Styles.xsmall.smb.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceItem(dynamic device) {
    final deviceId = device['deviceId'];
    final deviceName = device['name'];

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            NavigationHelper.navigate(
              '${AppRoutes.moduleDevice}${DeviceModuleRoutes.detail}',
              args: {'deviceId': deviceId},
            );
          },
          child: Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 2,
              ),
              color: Colors.green.shade300.withValues(alpha: 0.6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                  child: Icon(Icons.sensors, size: 28, color: Colors.white),
                ),

                16.horizontalSpace,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        deviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.large.smb.copyWith(color: Colors.white),
                      ),
                      6.verticalSpace,
                      Text(
                        context.localization.deviceIdLabel(deviceId),
                        style: Styles.small.regular.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: SizedBox(
                    child: IconButton(
                      onPressed: () {
                        NavigationHelper.navigate(
                          '${AppRoutes.moduleDevice}${DeviceModuleRoutes.setting}',
                          args: {
                            'deviceId': deviceId,
                            'deviceName': deviceName,
                            'userId': _userId,
                          },
                        );
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_userId != null) {
                _deviceBloc.add(LoadDevices(_userId!));
              }
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
