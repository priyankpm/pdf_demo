import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseViewModel<T> extends StateNotifier<T> {
  BaseViewModel(super.state);

  Future<void> init({String docId = ''});

  void notifyChanges(T model);
}