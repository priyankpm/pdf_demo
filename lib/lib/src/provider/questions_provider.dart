
import 'package:flutter/material.dart';
import 'package:whiskers_flutter_app/src/viewmodel/questions_viewmodel.dart';

class QuestionsProvider extends ChangeNotifier {
  final QuestionsViewModel _questionsViewModel = QuestionsViewModel();

  QuestionsViewModel get questionsViewModel => _questionsViewModel;
}
