import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_accepted_model.freezed.dart';

@freezed
abstract class TermsAcceptedModel with _$TermsAcceptedModel {
  factory TermsAcceptedModel({
    required bool? isTermsAccepted,
  }) = _TermsAcceptedModel;
  const TermsAcceptedModel._();
}