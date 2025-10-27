import 'dart:math';

import 'package:flutter/material.dart';

/// app level variable to store token in in-memory
String apiToken = '';
bool downloadingBackup = false;
bool isAppLaunchedFromSilentNotif = false;
bool showRepeatedLogs = false;
bool remoteConfigSynced = false;
double deviceWidth = 360;
bool setupCompleted = false;
const String appName = 'Whiskers';
const String whiskerSplashLogo = 'assets/splash/splash_screen.svg';
const String whiskerSplashImage = 'assets/splash/ss.png';
const String dogPngLogo = 'assets/splash/dog_splash.png';
const String bottomPaw = 'assets/splash/bottom_paw.svg';
const String dogPaw = 'assets/create_account/dog_paw.svg';
const String createAccountBottomPaw = 'assets/create_account/bottom_paw.svg';
const String appleLogoSvg = 'assets/create_account/apple.svg';
const String facebookLogoSvg = 'assets/create_account/facebook.svg';
const String googleLogoSvg = 'assets/create_account/google.svg';
const String profileSvg = 'assets/profile/profile.svg';
const String profileDogPawMidLeftSvg =
    'assets/profile/profile_dog_paw_mid_left.svg';
const String profileDogPawMidSvg = 'assets/profile/profile_dog_paw_mid.svg';
const String profileDogPawDownLeftSvg =
    'assets/profile/profile_dog_paw_down_left.svg';
const String profileDogPawBottomRightSvg =
    'assets/profile/profile_dog_paw_bottom_right.svg';
const String clearCachetSvg = 'assets/profile/clearCache.svg';
const String clearHistorySvg = 'assets/profile/clear_history.svg';
const String displaySvg = 'assets/profile/display.svg';
const String locationSvg = 'assets/profile/location.svg';
const String logoutSvg = 'assets/profile/logout.svg';
const String subsSvg = 'assets/profile/subs.svg';
const String languageSvg = 'assets/profile/language.svg';
const String downloadSvg = 'assets/profile/download.svg';
const String favouriteSvg = 'assets/profile/favourite.svg';
const String homeDogPawRight = 'assets/home_screen/home_dog_paw_right.svg';
const String homeDogPawLeft = 'assets/home_screen/home_left_dog_paw.svg';
const String microphoneSvg = 'assets/home_screen/microphone.svg';
const String pawSvg = 'assets/home_screen/paw.svg';
const String dogImage = 'assets/home_screen/dog.png';
const String catImage = 'assets/home_screen/cat.png';
const String settingsSvg = 'assets/home_screen/settings.svg';
const String speakerSvg = 'assets/home_screen/speaker.svg';
const String speakerMuteSvg = 'assets/home_screen/speaker_mute.svg';
const String backgroundSvg = 'assets/home_screen/background.svg';
const String leftArrowSvg = 'assets/home_screen/left_arrow.svg';
const String rightArrowSvg = 'assets/home_screen/right_arrow.svg';
const String birthdayImage = 'assets/home_screen/bd_bg.png';
const String cat1Video = 'assets/video/cat_1.mp4';
const String dog1Video = 'assets/video/dog_1.mp4';
const String dog2Video = 'assets/video/dog_2.mp4';
const String dog3Video = 'assets/video/dog_3.mp4';
const String neutralToHappy = 'assets/video/emotion/neutral_to_happy.mp4';
const String neutralToNeutral = 'assets/video/emotion/neutral_to_neutral.mp4';
const String happyToHappy = 'assets/video/emotion/happy_to_happy.mp4';
const String backgroundVideoImage = 'assets/video/emotion/background.png';
const String chattingVideoSvg = 'assets/video/bottom_bar/chatting.svg';
const String cloudVideoSvg = 'assets/video/bottom_bar/cloud.svg';
const String mealVideoSvg = 'assets/video/bottom_bar/meal.svg';
const String memoryWallVideoSvg = 'assets/video/bottom_bar/memory_wall.svg';
const String pawVideoSvg = 'assets/video/bottom_bar/paw.svg';
const String tableVideoSvg = 'assets/video/bottom_bar/table.svg';
const String tablePhotoPng = 'assets/video/bottom_bar/tablePhoto.png';
const String foodBowl = 'assets/video/food/foodBowl.svg';
const String tableJpgPhoto = 'assets/video/food/tableJpg.jpg';
const String foodBowlJpgPhoto = 'assets/video/food/foodBowl.png';
const String foodBowlJpgPhoto2 = 'assets/video/food/foodBowl2.png';
const String foodBowlJpgPhoto3 = 'assets/video/food/foodBowl3.png';
const String catAnimalPng = 'assets/video/animal/cat.png';
const String sheepAnimalPng = 'assets/video/animal/sheep.png';
const String sheepAnimalBorderPng = 'assets/video/animal/sheep_broder.png';
const String blackFrameSvg = 'assets/memory/blackFrame.png';
const String goldenPhotoFrame = 'assets/memory/goldenPhotoFrame.png';
const String smallGoldenFrame =  'assets/memory/smallGoldenFrame.png';
const String shareIconPng =  'assets/video/chat/shareIcon.png';
const String audioPng =  'assets/video/audio/audio.png';
const String cat1IMG = 'assets/video/cat1.png';
const String sleepCatImg = 'assets/video/sleep_cat.png';
const String sleepBubbleImg = 'assets/video/sleep/sleep_bubble.png';
const String cloudWithImagePng = 'assets/screens/cloudWithImage.png';
const String memoryWallBg = 'assets/backgrounds/memory_wall_bg.png';
const String chatScreenBg = 'assets/backgrounds/chat_bg.png';
const String scheduleBg = 'assets/backgrounds/schedule_screen_bg.png';
const String reportBg = 'assets/backgrounds/report_issue_bg.png';
const String cameraIcon = 'assets/memory/camara.svg';
const String shareIcon = 'assets/memory/share.svg';
const String deleteIcon = 'assets/memory/delete.svg';
const String profilePic = 'assets/profile/profile_pic.png';

const String backImageSvgPath = "assets/Icons/back.svg";


const String appVersionString = 'App Version';
const String createAccountString = 'Create account';
const String fullNameString = 'Full Name';
const String chatString = 'Chat';
const String emailOrPhoneString = 'Email or Phone';
const String passwordString = 'Password';
const String iAgreeToString = 'I agree to the ';
const String termsConditionString = 'Terms & Conditions';
const String userFullName = 'userFullName';
const String email = 'email';
const String andString = ' and ';
const String privacyPolicyString = 'Privacy Policy';
const String signUpString = 'Sign up';
const String alreadyHaveAnAccountString = 'Already have an account? ';
const String joinNowString = 'Login!';
const String signUpWithString = 'Or sign up with';
const String myProfileString = 'My Profile';
const String editProfileString = 'Edit Profile';
const String favouritesString = 'Favourites';
const String languagesString = 'Languages';
const String downloadsString = 'Downloads';
const String locationString = 'Location';
const String subscribtionString = 'Subscribtion';
const String displayString = 'Display';
const String clearCacheString = 'Clear Cache';
const String clearHistoryString = 'Clear History';
const String logOutString = 'Log Out';
const String cancelString = 'Cancel';
const String logoutWordString = 'Logout';
const String eatString = 'Eat';
const String sleepString = 'Sleep';
const String memoryWallString = 'Memory Wall';
const String loggingOutMayRequire =
    'Logging out may require you to sign back in';
const String areYouSureString = 'Are you sure?';
const String livingRoomString = 'Living Room';
const int splashDuration = 2;
const String addADescription = 'Add a description';
const String titleString = 'Title';
const String memoryBox = "memory_frames";
const String crossIconSvg = "assets/memory/crossIcon.svg";
const String cloudSvgPath = "M50.733 7.43566C37.5275 1.03013 28.6365 3.70651 18.5623 7.43566C-5.88948 16.487 -0.784902 36.456 3.9394 42.6746C8.66371 48.8932 22.7867 52.6935 27.3361 48.8932C50.733 57.1323 67.0881 55.9873 80.9539 48.8932C93.8774 58.8497 124.173 57.8757 130.672 48.8932C140.066 53.6975 150.495 55.8028 154.069 48.8932C172.398 57.7047 195.492 54.2699 206.712 48.8932C229.671 52.5525 234.008 42.6746 238.883 42.6746C253.506 42.6746 253.047 13.5165 232.442 11.3348C225.334 5.50196 205.412 1.21698 199.888 7.43566C164.084 -4.12197 154.069 -0.687505 135.547 7.43566C119.743 -1.25975 112.353 3.32002 101.426 7.43566C73.5545 -5.83952 59.698 7.43566 50.733 7.43566Z";

/// Resets global variables to their initial values.
/// No input arguments.
/// No return value.
void resetGlobalVariables() {
  apiToken = '';
  downloadingBackup = false;
  isAppLaunchedFromSilentNotif = false;
}

const int checkTimeout = 4;
const int checkInterval = 4;
