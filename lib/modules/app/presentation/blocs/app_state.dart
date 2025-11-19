import 'package:equatable/equatable.dart';
import 'package:flutter_api/core/helpers/generalHeper.dart';

const Map<String, dynamic> defaultConfig = {};

class AppState extends Equatable {
  final int isConfigLoaded;
  final Map<String, dynamic> config;
  final String? selfId;
  final String? peerId;
  const AppState._({
    this.config = defaultConfig,
    this.isConfigLoaded = -1,
    this.selfId,
    this.peerId,
  });

  @override
  List<Object?> get props => [config.hashCode, isConfigLoaded];

  const AppState.initial() : this._();

  AppState setState({
    Map<String, dynamic> config = const {},
    int? isConfigLoaded,
    String? selfId,
    String? peerId,
  }) {
    return AppState._(
      config: {...defaultConfig, ...this.config, ...config},
      isConfigLoaded: isConfigLoaded ?? this.isConfigLoaded,
      selfId: selfId,
      peerId: peerId,
    );
  }

  AppState.fromJson(Map<String, dynamic> json)
      : config = {...defaultConfig, ...(json['config'] ?? {})},
        isConfigLoaded = json['isConfigLoaded'] ?? -1,
        selfId = '',
        peerId = '';
  Map<String, dynamic> toJson() => {
    'config': config,
    'isConfigLoaded': isConfigLoaded,
  };

  bool get inReview => config['in_review'] == GeneralHelper.appVersion;
  bool get showMission => config['show_mission'] == '1';
  bool get showLogs => config['show_logs'] == '1';
}
