import 'package:equatable/equatable.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class AppConfigRequested extends AppEvent {}

final class PeersRequested extends AppEvent {
  final String selfId;
  final List<dynamic> peers;
  const PeersRequested({required this.selfId, required this.peers});
}
