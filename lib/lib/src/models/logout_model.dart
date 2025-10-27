import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_model.freezed.dart';

@freezed
abstract class LogoutModel with _$LogoutModel {
  factory LogoutModel({
    required bool? showLogoutScreen,
  }) = _LogoutModel;
  const LogoutModel._();
}