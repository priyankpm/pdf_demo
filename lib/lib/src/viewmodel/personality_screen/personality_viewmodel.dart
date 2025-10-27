import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../models/PersonalityQuestion.dart';
import '../../provider.dart';

class PersonalityViewModel extends StateNotifier<PersonalityState> {
  PersonalityViewModel(this.ref) : super(PersonalityState(
    questions: [],
    selectedOptions: {},
    currentPage: 1,
    loading: true,
  )) {
    _loadQuestions();
  }

  final Ref ref;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    if (_isDisposed) return;

    state = state.copyWith(loading: true, error: null);

    try {
      // TODO: Replace with actual API call
      // final response = await ref.read(apiServiceProvider).getPersonalityQuestions();
      // final questions = (response as List).map((q) => PersonalityQuestion.fromJson(q)).toList();

      // Mock API response for now
      await Future.delayed(const Duration(seconds: 1));

      final mockResponse = [
        {
          "PageNumber": 1,
          "Position": 0,
          "Question": "Select as many as you like",
          "Options": ["Introvert", "Extrovert", "Calm", "Energetic", "Curious", "Empathetic", "Sarcastic", "Goofy", "Loyal", "Independent", "Protective", "Affectionate"],
          "MinSelections": 1,
          "MaxSelections": 12,
          "Version": "0.0.0",
          "Prefix": "personality"
        },
        {
          "PageNumber": 1,
          "Position": 1,
          "Question": "Emotional Needs",
          "Options": ["Like alone", "I need comfort", "I want to feel needed", "I want a protector", "I'm grieving", "I'm anxious", "I'm creative", "I like routines", "I want a challenge", "I get lonely", "I want a companion who listens"],
          "MinSelections": 1,
          "MaxSelections": 11,
          "Version": "0.0.0",
          "Prefix": "emotional_needs"
        },
        {
          "PageNumber": 2,
          "Position": 0,
          "Question": "Pet Personality Preferences",
          "Options": ["Loyal like a dog", "Independent like a cat", "Silly like a ferret", "Regal like a horse", "Protective like a guard dog", "Mysterious like an owl", "Mischievous like a monkey", "Soothing like a fish"],
          "MinSelections": 1,
          "MaxSelections": 8,
          "Version": "0.0.0",
          "Prefix": "pet_preferences"
        }
      ];
      final questions = mockResponse.map((q) => PersonalityQuestion.fromJson(q)).toList();

      if (!_isDisposed) {
        state = state.copyWith(
          questions: questions,
          loading: false,
          currentPage: 1,
        );
      }
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(
          loading: false,
          error: 'Failed to load questions: $e',
        );
      }
    }
  }

  void toggleOption(String prefix, String option) {
    if (_isDisposed) return;

    final currentSelected = {...state.selectedOptions[prefix] ?? {}};

    if (currentSelected.contains(option)) {
      currentSelected.remove(option);
    } else {
      // Check max selections constraint
      final question = state.questions.firstWhere((q) => q.prefix == prefix);
      if (currentSelected.length < question.maxSelections) {
        currentSelected.add(option);
      }
    }

    final newSelectedOptions = {...state.selectedOptions};
    newSelectedOptions[prefix] = currentSelected;

    state = state.copyWith(selectedOptions: newSelectedOptions);
  }

  void nextPage() {
    if (_isDisposed || !state.isPageComplete()) return;

    final nextPage = state.currentPage + 1;
    if (nextPage <= _getMaxPage()) {
      state = state.copyWith(currentPage: nextPage);
    } else {
      // All pages completed, navigate to next screen
      _submitAnswers();
    }
  }

  void previousPage() {
    if (_isDisposed || state.currentPage <= 1) return;

    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  int _getMaxPage() {
    return state.questions.fold<int>(0, (max, q) => q.pageNumber > max ? q.pageNumber : max);
  }

  void _submitAnswers() {
    // TODO: Implement API call to submit answers
    print('Submitting answers: ${state.selectedOptions}');
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.learningVoiceScreen);
  }
}