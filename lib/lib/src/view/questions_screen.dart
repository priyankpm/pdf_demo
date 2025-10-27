import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/viewmodel/questions_viewmodel.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/reuseablke_text_form.dart';

import '../widgets/common_widgets/back_button.dart';

class QuestionsScreen extends ConsumerWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(resourceProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.pureWhite);
    });
    final questionsVM = ref.watch(questionsProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.pureWhite);
    });
    return Material(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: SvgPicture.asset(
              'assets/home_screen/paw.svg',
              width: 200,
              height: 200,
              colorFilter: ColorFilter.mode(res.themes.lightOrange.withOpacity(0.3), BlendMode.srcIn),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: SvgPicture.asset(
              'assets/home_screen/paw.svg',
              width: 200,
              height: 200,
              colorFilter: ColorFilter.mode(res.themes.lightOrange.withOpacity(0.3), BlendMode.srcIn),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _header(context, res, questionsVM.questionsViewModel.currentQuestion?.question ?? ''),
                SizedBox(height: 20),
                // Image placeholder
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/video/cat1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    questionsVM.questionsViewModel.currentQuestion?.question ?? '',
                    style: res.themes.appStyle.black40016,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ReusableTextField(
                    globalKey: questionsVM.questionsViewModel.answerGlobalKey,
                    hintText: 'Your answer',
                    controller: questionsVM.questionsViewModel.answerController,
                  ),
                ),
                SizedBox(height: 40),
                _continueButton(context, res, questionsVM.questionsViewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, Resources res, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        commonBackButton(context),
        Text(title, style: res.themes.appStyle.black50025),
        SizedBox(width: 48), // To balance the back button
      ],
    );
  }

  Widget _continueButton(
    BuildContext context,
    Resources res,
    QuestionsViewModel questionsVM,
  ) {
    return GestureDetector(
      onTap: () {
        questionsVM.nextQuestion(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [res.themes.lightOrange, res.themes.darkOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Continue',
          textAlign: TextAlign.center,
          style: res.themes.appStyle.white70016,
        ),
      ),
    );
  }
}
