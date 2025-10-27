import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

import '../../models/count_sheep_model.dart';

class CountSheepViewModel extends BaseViewModel<CountSheepModel> {
  CountSheepViewModel(this.ref)
    : super(CountSheepModel(showCountSheepScreen: false, sheepCount: 0));

  final Ref ref;
  List<bool> animals = <bool>[];

  @override
  Future<void> init({String docId = ''}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  void notifyChanges(CountSheepModel model) {
    state = state.copyWith(
      showCountSheepScreen: model.showCountSheepScreen,
      sheepCount: model.sheepCount,
    );
  }

  bool showCountSheepScreen() {
    return state.showCountSheepScreen ?? false;
  }

  List<bool> changeAnimalPositionToRandom() {
    final random = Random();
    // 6 x 4 grid → 24 booleans
    return List.generate(24, (_) => random.nextBool());
  }
}
