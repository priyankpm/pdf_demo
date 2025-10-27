import 'package:flutter/cupertino.dart';
import 'package:whiskers_flutter_app/src/view/PetGenderScreen.dart';
import 'package:whiskers_flutter_app/src/view/describe_yourself_screen.dart';
import 'package:whiskers_flutter_app/src/view/human_audio_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/count_sheep_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/log_menu_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/report/feedback_dialog.dart';
import 'package:whiskers_flutter_app/src/widgets/home_screen/home_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/profile_screen/profile_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/registration/create_account.dart';
import 'package:whiskers_flutter_app/src/widgets/splash_screen/splash_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/video_screen/video_screen.dart';
import 'package:whiskers_flutter_app/src/view/daily_routine_screen.dart';
import 'package:whiskers_flutter_app/src/view/pet_preference_screen.dart';

import '../common_utility/common_utility.dart';
import '../models/memory_frame_model.dart';
import 'package:whiskers_flutter_app/src/view/upload_audio_screen.dart';
import '../view/LearningVoiceScreen.dart';
import '../view/PetBirthdayScreen.dart';
import '../view/PetNameScreen.dart';
import '../view/PortraitConfirmScreen.dart';
import '../view/schedule_screen.dart';
import '../view/UploadHouseScreen.dart';
import '../view/UploadPetScreen.dart';
import '../view/birthday_screen.dart';
import '../view/login_page.dart';
import '../view/pet_type_screen.dart';
import '../view/questions_screen.dart';
import '../view/report_issue_screen.dart';
import '../widgets/video_screen/activity_screens/memory_edit_screen.dart';
import '../widgets/video_screen/activity_screens/upload_image_screen.dart';

mixin RouteSetup {
  Future<Map<String, WidgetBuilder>> setupAppStartNavigationRoutes() async {
    return <String, WidgetBuilder>{
      RoutePaths.uploadAudioScreen: (BuildContext context) =>
          UploadAudioScreen(),
      RoutePaths.describeYourSelfScreen: (BuildContext context) =>
          DescribeYourselfScreen(),
      RoutePaths.humanAudioScreen: (BuildContext context) => HumanAudioScreen(),
      RoutePaths.dailyRoutineScreen: (BuildContext context) =>
          DailyRoutineScreen(),
      RoutePaths.petPreferenceScreen: (BuildContext context) =>
          PetPreferenceScreen(),
      RoutePaths.splashScreen: (BuildContext context) => SplashScreen(),
      RoutePaths.createAccount: (BuildContext context) => CreateAccount(),
      RoutePaths.profileScreen: (BuildContext context) => ProfileScreen(),
      RoutePaths.loginScreen: (BuildContext context) => LoginScreen(),
      RoutePaths.logoutMenuScreen: (BuildContext context) => LogMenuScreen(),
      RoutePaths.homeScreen: (BuildContext context) => HomeScreen(),
      RoutePaths.videoScreen: (BuildContext context) => VideoScreen(),
      RoutePaths.countSheepScreen: (BuildContext context) => CountSheepScreen(),
      RoutePaths.memoryEditScreen: (BuildContext context) {
        final MemoryFrameModel memory =
            ModalRoute.of(context)!.settings.arguments as MemoryFrameModel;
        return MemoryEditScreen(memoryFrameModel: memory);
      },
      RoutePaths.questionsScreen: (BuildContext context) => QuestionsScreen(),
      RoutePaths.uploadHouseImagesScreen: (context) =>
          const UploadHouseScreen(),
      RoutePaths.petImageUploadScreen: (context) => const UploadPetScreen(),
      RoutePaths.reportIssueScreen: (context) => const ReportIssueScreen(),
      RoutePaths.birthdayScreen: (context) => const BirthdayScreen(),
      RoutePaths.selectPetScreen: (context) => const PetTypeScreen(),
      RoutePaths.petNameScreen: (context) => const PetNameScreen(),
      RoutePaths.portraitConfirmScreen: (context) =>
          const PortraitConfirmScreen(),
      RoutePaths.petBirthdayScreen: (context) => const PetBirthdayScreen(),
      RoutePaths.scheduleScreen: (context) => const ScheduleScreen(),
      RoutePaths.petGenderScreen: (context) => const PetGenderScreen(),
      RoutePaths.learningVoiceScreen: (context) => const LearningVoiceScreen(),
      RoutePaths.uploadImageScreen: (context) => const UploadImageScreen(),
      RoutePaths.feedBackScreen: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return FeedbackDialog(
          screeName: args['screeName'] ?? '',
          asset: args['asset'] ?? '',
          assetPath: args['assetPath'] ?? '',
          isFullScreen: true,
        );
      },
    };
  }
}
