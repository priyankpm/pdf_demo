import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/services/supabase_service.dart';

final feedbackViewModelProvider =
    StateNotifierProvider<FeedbackViewModel, AsyncValue<void>>(
      (ref) => FeedbackViewModel(ref),
    );

class FeedbackViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  FeedbackViewModel(this.ref) : super(const AsyncValue.data(null));

  Future<void> submitFeedback({
    required String reason,
    required String screenName,
    required String asset,
    required String petId,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      final DateTime nowUtc = DateTime.now().toUtc();
      await SupabaseService().post(
        context,
        functionName: 'issues',
        body: {
          "Reason": reason,
          "ReportedAt": nowUtc.toIso8601String(),
          "Screen": screenName,
          "Asset": asset,
          "PetID": petId,
        },
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
