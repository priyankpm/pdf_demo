import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

import '../common_utility/common_utility.dart';
import '../models/PersonalityQuestion.dart';
import '../provider.dart';
import '../styles/resources.dart';
import '../viewmodel/personality_screen/personality_viewmodel.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/back_button.dart';

class DescribeYourselfScreen extends ConsumerStatefulWidget {
  const DescribeYourselfScreen({super.key});

  @override
  ConsumerState<DescribeYourselfScreen> createState() => _DescribeYourselfScreenState();
}

class _DescribeYourselfScreenState extends ConsumerState<DescribeYourselfScreen> {
  late Resources res;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.pureWhite);
    });

    final personalityState = ref.watch(personalityProvider);
    final personalityViewModel = ref.read(personalityProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Describe Yourself',
          style: res.themes.appStyle.interBold120,
        ),
        toolbarHeight: 72,
        leading: personalityState.currentPage > 1 ? Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: commonBackButton(context, onPressed: () {
            personalityViewModel.previousPage();
          },),
        ) : Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: commonBackButton(context),
        ),
      ),
      body: _buildBody(personalityState, personalityViewModel),
    );
  }

  Widget _buildBody(PersonalityState state, PersonalityViewModel viewModel) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }

    return BackgroundPaws(
      child: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 100), // Extra padding for the sticky button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageIndicator(state),
                  const SizedBox(height: 25),
                  ..._buildQuestions(state, viewModel),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Sticky bottom button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: res.themes.pureWhite,

            ),
            child: _buildContinueButton(state, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(PersonalityState state) {
    final totalPages = state.questions.fold<int>(0, (max, q) => q.pageNumber > max ? q.pageNumber : max);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Select all that apply to you',
          style: res.themes.appStyle.black60010,
        ),
      ],
    );
  }

  List<Widget> _buildQuestions(PersonalityState state, PersonalityViewModel viewModel) {
    final pageQuestions = state.getCurrentPageQuestions();
    return pageQuestions.map((question) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(question.question),
          const SizedBox(height: 5),
          _buildOptions(question, state.selectedOptions[question.prefix] ?? {}, viewModel),
          const SizedBox(height: 20),
        ],
      );
    }).toList();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: res.themes.appStyle.black60016),
    );
  }

  Widget _buildOptions(PersonalityQuestion question, Set<String> selectedOptions, PersonalityViewModel viewModel) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: question.options.map((option) {
        final isSelected = selectedOptions.contains(option);
        final isDisabled = !isSelected && selectedOptions.length >= question.maxSelections;

        return GestureDetector(
          onTap: isDisabled ? null : () => viewModel.toggleOption(question.prefix, option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isDisabled ? Colors.grey[300] : (isSelected ? null : const Color(0xFFE7E7E7)),
              gradient: isSelected && !isDisabled
                  ? const LinearGradient(
                colors: [Color(0xFFFFD288), Color(0xFFB15600)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isDisabled ? Colors.grey[600] : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton(PersonalityState state, PersonalityViewModel viewModel) {
    return Center(
      child: GestureDetector(
        onTap: state.isPageComplete() ? () => viewModel.nextPage() : null,
        child: Container(
          width: 216,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            gradient: state.isPageComplete()
                ? const LinearGradient(
              colors: [Color(0xFFFFD288), Color(0xFFB15600)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : const LinearGradient(
              colors: [Color(0xFFE7E7E7), Color(0xFFE7E7E7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            state.isLastPage() ? 'Submit' : 'Continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: state.isPageComplete() ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}