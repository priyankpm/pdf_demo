import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../logger/log_handler.dart';
import '../models/connection_state_model.dart';

/// this class monitors network changes and maintains ConnectionStateModel state
class ConnectivityService extends StateNotifier<ConnectionStateModel> {
  ConnectivityService(this._logger)
    : super(
        ConnectionStateModel(
          connectionStatus: 'Unknown',
          isConnected: false,
          isInitialised: false,
        ),
      );

  final Logger _logger;
  String _connectionStatus = 'Unknown';
  bool isConnected = false;
  InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker.createInstance(
        checkInterval: Duration(seconds: 3),
      );
  StreamSubscription<InternetConnectionStatus>? connectivitySubscription;
  Stream<InternetConnectionStatus>? connectivityStream;

  /// gets the current connection status
  String getConnectionStatus() {
    return _connectionStatus;
  }

  /// registers to listen network changes
  void listen() {
    initConnectivity();
  }

  /// cancels registered subscription to listen network changes
  bool cancel() {
    state = state.copyWith(isInitialised: false);
    connectivitySubscription?.cancel();
    connectivitySubscription = null;
    return true;
  }

  /// checks connectivity and update the status
  Future<void> initConnectivity() async {
    if (state.isInitialised ?? false || connectivitySubscription != null) {
      return;
    }
    resetStateIfRequired();
    final bool isConnectedToInternet =
        await internetConnectionChecker.hasConnection;
    isConnected = isConnectedToInternet;
    _logger.i('Initial Connection Status: Internet $isConnected');
    if (mounted) {
      state = state.copyWith(
        isConnected: isConnectedToInternet,
        connectionStatus: 'isConnected $isConnected',
        isInitialised: true,
      );
    }
    _logger.i('is Connected to Internet $isConnectedToInternet');

    // Check internet connection with created instance
    await updateConnectionStatus(internetConnectionChecker);
  }

  /// updates connection status and isConnected flag. Also sends the RX
  Future<void> updateConnectionStatus(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    // actively listen for status updates
    connectivitySubscription = internetConnectionChecker.onStatusChange.listen((
      InternetConnectionStatus status,
    ) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          _connectionStatus = 'Connected to Internet';
          _logger.i('Connected to internet.');
          break;
        case InternetConnectionStatus.disconnected:
          isConnected = false;
          _connectionStatus = 'Not Connected to Internet';
          _logger.i('Disconnected from internet.');
          break;
        case InternetConnectionStatus.slow:
          isConnected = true;
          _connectionStatus = 'Not Connected to Internet';
          _logger.i('Slow from internet.');
          break;
      }
      if (mounted) {
        state = state.copyWith(
          isConnected: isConnected,
          connectionStatus: _connectionStatus,
        );
      }
    });
  }

  void resetStateIfRequired() {
    if (mounted && !(state.isConnected ?? false)) {
      Future.microtask(() {
        state = state.copyWith(
          isConnected: true,
          connectionStatus: 'isConnected $isConnected',
          isInitialised: true,
        );
      });
      // state = state.copyWith(
      //   isConnected: true,
      //   connectionStatus: 'isConnected $isConnected',
      //   isInitialised: true,
      // );
    }
  }
}
