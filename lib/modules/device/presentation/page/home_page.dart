import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../account/data/repositories/account_repository.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';
import '../../../device/general/device_module_routes.dart';
import '../blocs/device_bloc.dart';
import '../blocs/device_event.dart';
import '../blocs/device_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    final accountRepo = Modular.get<AccountRepository>();
    final user = await accountRepo.getCurrentUser();

    if (!mounted) return;

    final userId = user?.userId;

    if (userId != null && userId.isNotEmpty) {
      setState(() {
        _userId = userId;
        _loading = false;
      });

      ModularWatchExtension(context).read<DeviceBloc>().add(LoadDevices(userId));
    } else {
      ModularWatchExtension(context).read<AuthBloc>().add(AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thiết bị của tôi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Modular.to.pushNamed(
                '${AppRoutes.moduleDevice}${DeviceModuleRoutes.addDevice}'
              );
            },
          ),
        ],
      ),
      body: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            if (state is DeviceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DeviceLoaded) {
              if (state.devices.isEmpty) {
                return const Center(child: Text("Chưa thêm thiết bị nào"));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ModularWatchExtension(context).read<DeviceBloc>().add(LoadDevices(_userId!));
                },
                child: ListView.builder(
                  itemCount: state.devices.length,
                  itemBuilder: (context, index) {
                    final device = state.devices[index];
                    final deviceId = device['deviceId'];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(device['name']),
                        subtitle: Text("ID: $deviceId"),
                        onTap: () {
                          Modular.to.pushNamed(
                            '${AppRoutes.moduleDevice}${DeviceModuleRoutes.detail}',
                            arguments: {"sensorId": deviceId},
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }

            if (state is DeviceFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ModularWatchExtension(context).read<DeviceBloc>().add(LoadDevices(_userId!));
                      },
                      child: const Text("Thử lại"),
                    ),
                  ],
                ),
              );
            }

            // DeviceInitial or other states
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}