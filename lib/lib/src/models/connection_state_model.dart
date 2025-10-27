import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state_model.freezed.dart';

@freezed
abstract class ConnectionStateModel with _$ConnectionStateModel {
  factory ConnectionStateModel({
    required bool? isConnected,
    required String? connectionStatus,
    required bool? isInitialised,
  }) = _ConnectionStateModel;
  const ConnectionStateModel._();
}