import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';
import 'package:whiskers_flutter_app/src/models/terms_accepted_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

class TermsAndConditionViewModel extends BaseViewModel<TermsAcceptedModel> {
  TermsAndConditionViewModel(this.ref) : super(TermsAcceptedModel(isTermsAccepted: false));

  final Ref ref;

  @override
  Future<void> init({String docId = ''}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  void notifyChanges(TermsAcceptedModel model) {
    state = state.copyWith(isTermsAccepted: model.isTermsAccepted);
  }

  bool isTermsAccepted() {
    return state.isTermsAccepted ??
        false;
  }
}
