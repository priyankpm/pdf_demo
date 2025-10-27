import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../models/potrait_confirm_model.dart';
import '../../provider.dart';

class PortraitConfirmViewModel extends StateNotifier<PortraitConfirmModel> {
  PortraitConfirmViewModel(this.ref) : super(PortraitConfirmModel());

  final Ref ref;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> confirmPortrait(bool isConfirmed) async {
    if (_isDisposed) return; // Prevent operations after dispose

    state = state.copyWith(isConfirmed: isConfirmed);

    if (isConfirmed) {
      // Navigate to next screen if confirmed
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.petNameScreen);
    } else {
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final url = await prefsService.getPetPortraitUrl();

      ref
          .read(navigationServiceProvider)
          .pushNamed(
            RoutePaths.feedBackScreen,
            arguments: {
              'screeName': 'pet-confirmation',
              'asset': 'chewing',
              'assetPath': url,
            },
          );
    }
  }

  void navigateToNextScreen() {
    if (_isDisposed) return;
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.petNameScreen);
  }

  void navigateBack() {
    if (_isDisposed) return;
    // ref.read(navigationServiceProvider).pop();
  }
}
