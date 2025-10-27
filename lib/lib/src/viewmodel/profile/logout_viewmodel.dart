import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/logout_model.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

class LogoutViewModel extends BaseViewModel<LogoutModel> {
  LogoutViewModel(this.ref) : super(LogoutModel(showLogoutScreen: false));

  final Ref ref;

  @override
  Future<void> init({String docId = ''}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  void notifyChanges(LogoutModel model) {
    state = state.copyWith(showLogoutScreen: model.showLogoutScreen);
  }

  bool showLogoutScreen() {
    return state.showLogoutScreen ?? false;
  }
}
