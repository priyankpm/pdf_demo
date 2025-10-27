// login_model.dart (your state class)
class LoginModel {
  final String? email;
  final String? password;
  final bool loading;
  final String? errorMessage;
  final bool isValid;
  final dynamic response;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? userData;

  const LoginModel({
    this.email,
    this.password,
    this.loading = false,
    this.errorMessage,
    this.isValid = false,
    this.response,
    this.accessToken,
    this.refreshToken,
    this.userData,
  });

  LoginModel copyWith({
    String? email,
    String? password,
    bool? loading,
    String? errorMessage,
    bool? isValid,
    dynamic response,
    String? accessToken,
    String? refreshToken,
    Map<String, dynamic>? userData,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      isValid: isValid ?? this.isValid,
      response: response ?? this.response,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userData: userData ?? this.userData,
    );
  }
}