// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:whiskers_flutter_app/src/models/activity_model.dart';
// import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';
//
// import '../../enum/pet_activity_enum.dart';
//
// class VideoScreenViewmodel extends BaseViewModel<VideoDetailModel> {
//   VideoScreenViewmodel(this.ref)
//       : super(
//     VideoDetailModel(
//       name: '',
//       videoPath: '',
//     ),
//   );
//
//   final Ref ref;
//
//   @override
//   Future<void> init({String docId = ''}) {
//     // TODO: implement init
//     throw UnimplementedError();
//   }
//
//   @override
//   void notifyChanges(VideoDetailModel model) {
//     state = state.copyWith(petCurrentState: model.petCurrentState,previousPetState: model.previousPetState);
//   }
//
//   PetActivityEnum getPetCurrentState() {
//     return state.petCurrentState ?? PetActivityEnum.eat;
//   }
// }
