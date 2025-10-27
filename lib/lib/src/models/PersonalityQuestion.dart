class PersonalityQuestion {
  final int pageNumber;
  final int position;
  final String question;
  final List<String> options;
  final int minSelections;
  final int maxSelections;
  final String version;
  final String prefix;

  PersonalityQuestion({
    required this.pageNumber,
    required this.position,
    required this.question,
    required this.options,
    required this.minSelections,
    required this.maxSelections,
    required this.version,
    required this.prefix,
  });

  factory PersonalityQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalityQuestion(
      pageNumber: json['PageNumber'] ?? json['pageNumber'] ?? 0,
      position: json['Position'] ?? json['position'] ?? 0,
      question: json['Question'] ?? json['question'] ?? '',
      options: _parseOptions(json['Options'] ?? json['options']),
      minSelections: json['MinSelections'] ?? json['minSelections'] ?? 1,
      maxSelections: json['MaxSelections'] ?? json['maxSelections'] ?? 1,
      version: json['Version'] ?? json['version'] ?? '0.0.0',
      prefix: json['Prefix'] ?? json['prefix'] ?? '',
    );
  }

  static List<String> _parseOptions(dynamic optionsData) {
    if (optionsData is List) {
      return optionsData.map((item) => item.toString()).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'PageNumber': pageNumber,
      'Position': position,
      'Question': question,
      'Options': options,
      'MinSelections': minSelections,
      'MaxSelections': maxSelections,
      'Version': version,
      'Prefix': prefix,
    };
  }
}

class PersonalityState {
  final List<PersonalityQuestion> questions;
  final Map<String, Set<String>> selectedOptions;
  final int currentPage;
  final bool loading;
  final String? error;

  PersonalityState({
    required this.questions,
    required this.selectedOptions,
    required this.currentPage,
    this.loading = false,
    this.error,
  });

  PersonalityState copyWith({
    List<PersonalityQuestion>? questions,
    Map<String, Set<String>>? selectedOptions,
    int? currentPage,
    bool? loading,
    String? error,
  }) {
    return PersonalityState(
      questions: questions ?? this.questions,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      currentPage: currentPage ?? this.currentPage,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  List<PersonalityQuestion> getCurrentPageQuestions() {
    return questions
        .where((q) => q.pageNumber == currentPage)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  bool isPageComplete() {
    final pageQuestions = getCurrentPageQuestions();
    for (final question in pageQuestions) {
      final selected = selectedOptions[question.prefix] ?? {};
      if (selected.length < question.minSelections) {
        return false;
      }
    }
    return true;
  }

  bool isLastPage() {
    if (questions.isEmpty) return true;
    final maxPage = questions.fold<int>(0, (max, q) => q.pageNumber > max ? q.pageNumber : max);
    return currentPage >= maxPage;
  }

  // Helper method to check if there are any questions
  bool get hasQuestions => questions.isNotEmpty;

  // Helper method to get total pages
  int get totalPages {
    if (questions.isEmpty) return 0;
    return questions.fold<int>(0, (max, q) => q.pageNumber > max ? q.pageNumber : max);
  }

  // Helper method to get progress percentage
  double get progress {
    if (totalPages == 0) return 0.0;
    return currentPage / totalPages;
  }
}