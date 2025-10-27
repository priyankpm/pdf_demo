
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:whiskers_flutter_app/src/models/question_model.dart';
import 'package:whiskers_flutter_app/src/repository/hive_repository.dart';

class QuestionsViewModel with ChangeNotifier {
  final HiveRepository _hiveRepository = HiveRepository();
  final TextEditingController answerController = TextEditingController();
  final GlobalKey<FormState> answerGlobalKey = GlobalKey<FormState>();

  List<QuestionModel> _questions = [];
  int _currentPage = 0;

  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentPage] : null;

  QuestionsViewModel() {
    _loadQuestions();
  }

  void _loadQuestions() {
    // Static JSON for demonstration
    _questions = [
      QuestionModel(
        pageNumber: 0,
        position: 0,
        question: 'What do you want to name your pet?',
        options: [],
      ),
      QuestionModel(
        pageNumber: 1,
        position: 0,
        question: 'How old is your pet?',
        options: [],
      ),
      QuestionModel(
        pageNumber: 2,
        position: 0,
        question: 'What is your pet\'s breed?',
        options: [],
      ),
    ];
    notifyListeners();
  }

  void updateAnswer(String answer) {
    // For now, just update the text controller
    // In a real scenario, you might want to store this in a temporary model
  }

  Future<void> nextQuestion(BuildContext context) async {
    if (currentQuestion != null) {
      await _hiveRepository.saveAnswer(
          currentQuestion!.pageNumber.toString(), answerController.text);
    }

    if (_currentPage < _questions.length - 1) {
      _currentPage++;
      answerController.clear(); // Clear for the next question
      notifyListeners();
    } else {
      // All questions answered, navigate to next screen or show completion
      print('All questions answered!');
      // TODO: Navigate to the next screen after all questions are answered
    }
  }
}
