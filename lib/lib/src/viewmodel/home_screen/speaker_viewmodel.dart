import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';
import 'package:whiskers_flutter_app/src/models/terms_accepted_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

import '../../models/speaker_model.dart';

class SpeakerViewModel extends BaseViewModel<SpeakerModel> {
  SpeakerViewModel(this.ref) : super(SpeakerModel(showMuteIcon: false));

  final Ref ref;

  @override
  Future<void> init({String docId = ''}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  void notifyChanges(SpeakerModel model) {
    state = state.copyWith(showMuteIcon: model.showMuteIcon);
  }

  bool showMuteIcon() {
    return state.showMuteIcon ?? false;
  }
}
