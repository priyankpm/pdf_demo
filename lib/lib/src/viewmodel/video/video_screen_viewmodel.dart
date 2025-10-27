import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/activity_model.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

import '../../enum/pet_activity_enum.dart';

class VideoScreenViewmodel extends BaseViewModel<ActivityModel> {
  VideoScreenViewmodel(this.ref)
    : super(
        ActivityModel(
          petCurrentState: PetActivityEnum.eat,
          previousPetState: PetActivityEnum.none,
        ),
      );

  final Ref ref;

  @override
  Future<void> init({String docId = ''}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  void notifyChanges(ActivityModel model) {
    state = state.copyWith(petCurrentState: model.petCurrentState,previousPetState: model.previousPetState);
  }

  PetActivityEnum getPetCurrentState() {
    return state.petCurrentState ?? PetActivityEnum.eat;
  }
}
