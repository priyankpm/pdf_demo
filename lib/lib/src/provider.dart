import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/common_utility/cognito_auth_service.dart';
import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';
import 'package:whiskers_flutter_app/src/common_utility/package_version_util.dart';
import 'package:whiskers_flutter_app/src/common_utility/status_bar_handler.dart';
import 'package:whiskers_flutter_app/src/logger/log_handler.dart';
import 'package:whiskers_flutter_app/src/models/activity_model.dart';
import 'package:whiskers_flutter_app/src/models/emotion_video_model.dart';
import 'package:whiskers_flutter_app/src/models/food_state_model.dart';
import 'package:whiskers_flutter_app/src/models/logout_model.dart';
import 'package:whiskers_flutter_app/src/models/schedule_model.dart';
import 'package:whiskers_flutter_app/src/models/speaker_model.dart';
import 'package:whiskers_flutter_app/src/models/terms_accepted_model.dart';
import 'package:whiskers_flutter_app/src/provider/questions_provider.dart';
import 'package:whiskers_flutter_app/src/provider/upload_audio_provider.dart';
import 'package:whiskers_flutter_app/src/services/SharedPreferencesService.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_theme_mode.dart';
import 'package:whiskers_flutter_app/src/util/app_router.dart';
import 'package:whiskers_flutter_app/src/viewmodel/Pet_name_screen/pet_name_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/birthday_screen/birthday_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/create_account/create_account_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/data_sync/data_sync_service.dart';
import 'package:whiskers_flutter_app/src/viewmodel/data_sync/media_view_model.dart';
import 'package:whiskers_flutter_app/src/viewmodel/feedback/feedback_model.dart';
import 'package:whiskers_flutter_app/src/viewmodel/food_model/food_view_model.dart';
import 'package:whiskers_flutter_app/src/viewmodel/home_screen/speaker_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/login_screen/login_screen_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/personality_screen/personality_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/pet_birthday_screen/pet_birthday_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/pet_gender_screen/pet_gender_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/potrait_confirm_screen/potrait_confirm_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/profile/logout_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/schedule_screen/schedule_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/select_pet/select_petmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/splash_screen/splash_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/terms_and_condition_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/upload_house/uplaod_house_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/upload_pet/upload_pet_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/chat_screen/chat_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/count_sheep_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/emotion_video_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/memory_wall_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/sleep_image_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/video_screen_viewmodel.dart';

import 'models/PersonalityQuestion.dart';
import 'models/chat_message_model.dart';
import 'models/connection_state_model.dart';
import 'models/count_sheep_model.dart';
import 'models/create_account_model.dart';
import 'models/login_model.dart';
import 'models/memory_frame_model.dart';
import 'models/pet_birthday_model.dart';
import 'models/pet_gender_model.dart';
import 'models/pet_name_model.dart';
import 'models/potrait_confirm_model.dart';
import 'models/select_pet_model.dart';

final Provider<Resources> resourceProvider = Provider<Resources>((
  Ref<Resources> ref,
) {
  final Logger logger = ref.read(loggerProvider);

  return Resources(ref, AppThemeMode.light, logger: logger);
});

final Provider<Logger> loggerProvider = Provider<Logger>((Ref<Logger> ref) {
  return Logger();
});

final Provider<NavigationService> navigationServiceProvider =
    Provider<NavigationService>((Ref<NavigationService> ref) {
      return NavigationService();
    });

final Provider<AppPlatform> appPlatformProvider = Provider<AppPlatform>(
  (Ref<AppPlatform> ref) => AppPlatformImpl(),
);

final Provider<AppRouter> appRouterProvider = Provider<AppRouter>(
  (Ref<AppRouter> ref) => AppRouter(),
);

final FutureProvider<AppSharedPref> sharedPreferencesProvider =
    FutureProvider<AppSharedPref>((Ref ref) async {
      final AppSharedPref appSharedPreferences = AppSharedPref();
      await appSharedPreferences.initPref();

      return appSharedPreferences;
    });

final StateNotifierProvider<ConnectivityService, ConnectionStateModel>
connectivityProvider =
    StateNotifierProvider<ConnectivityService, ConnectionStateModel>((Ref ref) {
      final Logger logger = ref.read(loggerProvider);

      return ConnectivityService(logger);
    });

final StateNotifierProvider<TermsAndConditionViewModel, TermsAcceptedModel>
termsAndConditionProvider =
    StateNotifierProvider<TermsAndConditionViewModel, TermsAcceptedModel>((
      Ref ref,
    ) {
      return TermsAndConditionViewModel(ref);
    });

final Provider<RouteObserver<PageRoute<dynamic>>> routeObserverProvider =
    Provider<RouteObserver<PageRoute<dynamic>>>((
      Ref<RouteObserver<PageRoute<dynamic>>> ref,
    ) {
      final RouteObserver<PageRoute<dynamic>> routeObserver =
          RouteObserver<PageRoute<dynamic>>();

      return routeObserver;
    });

final AutoDisposeProvider<SplashViewModel> splashViewModelProvider =
    AutoDisposeProvider<SplashViewModel>(
      (Ref<SplashViewModel> ref) => SplashViewModel(ref),
    );
final uploadHouseViewModelProvider = StateNotifierProvider<UploadHouseViewModel, UploadHouseState>((ref) {
  return UploadHouseViewModel(ref);
});
final AutoDisposeProvider<BirthdayViewModel> birthdayViewModelProvider =
AutoDisposeProvider<BirthdayViewModel>(
      (Ref<BirthdayViewModel> ref) => BirthdayViewModel(ref),
);
final petGenderProvider = StateNotifierProvider<PetGenderViewModel, PetGenderModel>((ref) {
  return PetGenderViewModel(ref);
});
final AutoDisposeProvider<UploadPetViewModel> uploadPetViewModelProvider =
AutoDisposeProvider<UploadPetViewModel>(
      (Ref<UploadPetViewModel> ref) => UploadPetViewModel(ref),
);
final AutoDisposeStateNotifierProvider<PetNameViewModel, PetNameModel>
petNameProvider = StateNotifierProvider.autoDispose<PetNameViewModel, PetNameModel>(
      (Ref ref) => PetNameViewModel(ref),
);
final AutoDisposeStateNotifierProvider<PortraitConfirmViewModel, PortraitConfirmModel>
portraitConfirmProvider = StateNotifierProvider.autoDispose<PortraitConfirmViewModel, PortraitConfirmModel>(
      (Ref ref) => PortraitConfirmViewModel(ref),
);
final chatViewModelProvider = StateNotifierProvider<ChatViewModel, List<ChatMessageModel>>(
      (ref) => ChatViewModel(ref),
);

final AutoDisposeStateNotifierProvider<PetBirthdayViewModel, PetBirthdayModel>
petBirthdayProvider = StateNotifierProvider.autoDispose<PetBirthdayViewModel, PetBirthdayModel>(
      (Ref ref) => PetBirthdayViewModel(ref),
);
final personalityProvider = StateNotifierProvider.autoDispose<PersonalityViewModel, PersonalityState>(
      (ref) => PersonalityViewModel(ref),
);
final AutoDisposeStateNotifierProvider<LoginViewModel, LoginModel>
loginProvider = StateNotifierProvider.autoDispose<LoginViewModel, LoginModel>(
      (Ref ref) => LoginViewModel(ref),
);
final AutoDisposeStateNotifierProvider<PetTypeViewModel, PetTypeModel>
petTypeProvider = StateNotifierProvider.autoDispose<PetTypeViewModel, PetTypeModel>(
      (Ref ref) => PetTypeViewModel(ref),
);
final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((ref) {
  return SharedPreferencesService();
});

final scheduleProvider = StateNotifierProvider<ScheduleNotifier, ScheduleModel>(
      (ref) => ScheduleNotifier(),
);


final AutoDisposeStateNotifierProvider<
  CreateAccountViewModel,
  CreateAccountModel
>
createAccountProvider =
    StateNotifierProvider.autoDispose<
      CreateAccountViewModel,
      CreateAccountModel
    >((Ref ref) {
      return CreateAccountViewModel(ref);
    });

final Provider<PackageVersionUtil> packageVersionUtilProvider =
    Provider<PackageVersionUtil>((Ref<PackageVersionUtil> ref) {
      return PackageVersionUtil();
    });

final AutoDisposeStateNotifierProvider<LogoutViewModel, LogoutModel>
logoutScreenProvider =
    StateNotifierProvider.autoDispose<LogoutViewModel, LogoutModel>((Ref ref) {
      return LogoutViewModel(ref);
    });

final Provider<CognitoService> cognitoAuthServiceProvider =
    Provider<CognitoService>((Ref<CognitoService> ref) {
      final Logger logger = ref.read(loggerProvider);
      return CognitoService();
    });

final Provider<StatusBarHandler> statusBarHandler = Provider<StatusBarHandler>((
  Ref<StatusBarHandler> ref,
) {
  return StatusBarHandler();
});

final AutoDisposeStateNotifierProvider<SpeakerViewModel, SpeakerModel>
speakerStateProvider =
    StateNotifierProvider.autoDispose<SpeakerViewModel, SpeakerModel>((
      Ref ref,
    ) {
      return SpeakerViewModel(ref);
    });

final AutoDisposeStateNotifierProvider<VideoScreenViewmodel, ActivityModel>
videoScreenActivityProvider =
    StateNotifierProvider.autoDispose<VideoScreenViewmodel, ActivityModel>((
      Ref ref,
    ) {
      return VideoScreenViewmodel(ref);
    });

final AutoDisposeStateNotifierProvider<CountSheepViewModel, CountSheepModel>
countSheepProvider =
    StateNotifierProvider.autoDispose<CountSheepViewModel, CountSheepModel>((
      Ref ref,
    ) {
      return CountSheepViewModel(ref);
    });

final AutoDisposeStateNotifierProvider<
  MemoryWallViewModel,
  List<MemoryFrameModel>
>
memoryFrameProvider =
    StateNotifierProvider.autoDispose<
      MemoryWallViewModel,
      List<MemoryFrameModel>
    >((Ref ref) {
      final MemoryWallViewModel memoryWallViewModel = MemoryWallViewModel(ref);

      return memoryWallViewModel;
    });

final AutoDisposeStateNotifierProvider<EmotionVideoViewmodel, EmotionVideoModel>
emotionVideoProvider =
    StateNotifierProvider.autoDispose<EmotionVideoViewmodel, EmotionVideoModel>(
      (Ref ref) {
        final EmotionVideoViewmodel memoryWallViewModel = EmotionVideoViewmodel(
          ref,
        );

        return memoryWallViewModel;
      },
    );



final AutoDisposeStateNotifierProvider<SleepImageViewModel, String>
sleepImageProvider =
    StateNotifierProvider.autoDispose<SleepImageViewModel, String>((
      Ref ref,
    ) {
      return SleepImageViewModel();
    });

final uploadAudioProvider = ChangeNotifierProvider((ref) => UploadAudioProvider());

final questionsProvider = ChangeNotifierProvider((ref) => QuestionsProvider());




class ImageStorage extends StateNotifier<List<File>> {
  ImageStorage() : super([]);

  void addImage(File image) {
    state = [...state, image];
  }

  void setImages(List<File> images) {
    state = images;
  }

  void clearImages() {
    state = [];
  }
}

final imageStorageProvider = StateNotifierProvider<ImageStorage, List<File>>(
      (ref) => ImageStorage(),
);

class BackgroundController extends StateNotifier<int> {
  BackgroundController(this.ref) : super(0);
  final Ref ref;

  void nextImage() {
    final images = ref.read(imageStorageProvider);
    if (images.isEmpty) return;
    state = (state + 1) % images.length;
  }

  void previousImage() {
    final images = ref.read(imageStorageProvider);
    if (images.isEmpty) return;
    state = (state - 1) % images.length;
    if (state < 0) state = images.length - 1;
  }

  File? getCurrentImage() {
    final images = ref.read(imageStorageProvider);
    if (images.isEmpty) return null;
    return images[state];
  }
}

final backgroundControllerProvider = StateNotifierProvider<BackgroundController, int>(
      (ref) => BackgroundController(ref),
);


// Background Image Provider
class BackgroundImageNotifier extends StateNotifier<List<File>> {
  BackgroundImageNotifier() : super([]);

  int _currentIndex = 0;

  // Accept both List<File> and List<String> (file paths)
  void setBackgroundImages(List<dynamic> images) {
    if (images.isEmpty) {
      state = [];
      _currentIndex = 0;
      return;
    }

    // Handle List<File>
    if (images.first is File) {
      state = List<File>.from(images);
    }
    // Handle List<String> (file paths)
    else if (images.first is String) {
      state = (images as List<String>).map((path) => File(path)).toList();
    }

    _currentIndex = 0;
  }

  // Add image from File object
  void addBackgroundImage(File image) {
    state = [...state, image];
  }

  // Add image from file path
  void addBackgroundImageFromPath(String imagePath) {
    state = [...state, File(imagePath)];
  }

  void nextImage() {
    if (state.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % state.length;
  }

  void previousImage() {
    if (state.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + state.length) % state.length;
  }

  File? get currentImage => state.isEmpty ? null : state[_currentIndex];

  // Get current image path (useful for debugging)
  String? get currentImagePath => state.isEmpty ? null : state[_currentIndex].path;

  int get currentIndex => _currentIndex;
  int get totalImages => state.length;

  // Check if current image file exists
  Future<bool> get currentImageExists async {
    if (state.isEmpty) return false;
    return await state[_currentIndex].exists();
  }

  // Remove current image
  void removeCurrentImage() {
    if (state.isEmpty) return;
    state = List<File>.from(state)..removeAt(_currentIndex);
    if (_currentIndex >= state.length) {
      _currentIndex = state.isEmpty ? 0 : state.length - 1;
    }
  }

  // Remove image at specific index
  void removeImageAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = List<File>.from(state)..removeAt(index);
    if (_currentIndex >= state.length) {
      _currentIndex = state.isEmpty ? 0 : state.length - 1;
    }
  }

  // Clear all images
  void clearAllImages() {
    state = [];
    _currentIndex = 0;
  }

  // Get all image paths (useful for debugging)
  List<String> get allImagePaths => state.map((file) => file.path).toList();
}
final backgroundImageProvider = StateNotifierProvider<BackgroundImageNotifier, List<File>>(
      (ref) => BackgroundImageNotifier(),
);

enum PetState { idle, happy, sad, surprised, listening, talking }

final petStateProvider =
StateNotifierProvider<PetStateNotifier, PetState>((ref) => PetStateNotifier());

class PetStateNotifier extends StateNotifier<PetState> {
  PetStateNotifier() : super(PetState.idle);

  void setPetState(PetState newState) {
    state = newState;
    // Auto reset to idle after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (state == newState) state = PetState.idle;
    });
  }
}

final feedbackViewModelProvider =
StateNotifierProvider<FeedbackViewModel, AsyncValue<void>>(
      (ref) => FeedbackViewModel(ref),
);

final foodViewModelProvider = StateNotifierProvider<FoodViewModel, List<FoodStateModel>>((ref) {
  return FoodViewModel(ref);
});

final mediaViewModelProvider = StateNotifierProvider<MediaViewModel, MediaViewState>((ref) {
  return MediaViewModel(ref);
});

final dataSyncServiceProvider = Provider<DataSyncService>((ref) {
  return DataSyncService();
});