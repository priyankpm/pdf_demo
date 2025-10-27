import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_account_model.freezed.dart';

@freezed
abstract class CreateAccountModel with _$CreateAccountModel {
  factory CreateAccountModel({
    required String userId,
    required String? fullName,
    required String? email,
    required String? phoneNumber,
    required String? password,
  }) = _CreateAccountModel;
  const CreateAccountModel._();
}