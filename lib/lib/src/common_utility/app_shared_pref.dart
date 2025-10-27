import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  factory AppSharedPref() {
    return _instance;
  }

  AppSharedPref._internal();

  static final AppSharedPref _instance = AppSharedPref._internal();
  late SharedPreferences _prefs;

  static AppSharedPref get instance => _instance;

  /// Asynchronously initializes the shared preferences.
  ///
  /// This function initializes the shared preferences by calling the `getInstance()` method of the `SharedPreferences` class.
  /// Once the shared preferences are initialized, `_prefs` is set to the instance of `SharedPreferences` returned by the `getInstance()` method.
  ///
  /// Returns `Future<void>` that completes when the shared preferences are successfully initialized.
  Future<void> initPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Checks whether the given key is present in the preferences.
  ///
  /// Returns `true` if the key is present, otherwise `false`.
  /// The [key] parameter specifies the key to be checked.
  /// Returns a boolean value indicating whether the key is present in the preferences.
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Removes a key-value pair from the shared preferences.
  ///
  /// This method takes a [key] as an input and removes the corresponding key-value pair from the shared preferences.
  /// It returns a [Future<bool>] which completes with a value indicating whether the remove operation was successful or not.
  Future<bool> removeKey(String key) async {
    return _prefs.remove(key);
  }

  /// Stores a boolean value in shared preferences with the specified key.
  ///
  /// Takes a [key] and a [val] as input arguments. The [key] is used as
  /// the identifier for storing the boolean value in shared preferences.
  /// The [val] represents the boolean value to be stored.
  ///
  /// Returns a [Future] that completes with void once the value has been
  /// successfully stored in shared preferences.
  Future<void> addBool(String key, bool val) async {
    await _prefs.setBool(key, val);
  }

  bool? getBoolValue(String key, [bool? defaultVal]) {
    bool? val = _prefs.getBool(key);

    return val ??= defaultVal;
  }

  /// Takes a [key] and a [val] as input arguments and sets the value of the [val] associated with the [key]
  /// in shared preferences using `_prefs.setString()`.
  /// Returns a Future that completes when the value is set in shared preferences.
  Future<void> addString(String key, String val) async {
    await _prefs.setString(key, val);
  }

  String? getStringValue(String key, [String? defaultVal]) {
    String? val = _prefs.getString(key);

    return val ??= defaultVal;
  }

  /// Sets an integer value in shared preferences with the given key.
  ///
  /// The [key] parameter denotes the key under which the value is stored.
  /// The [val] parameter denotes the integer value to be set.
  ///
  /// Returns a [Future] that completes when the integer value has been stored
  /// in the shared preferences. The [Future] has no return value (void).
  Future<void> addInt(String key, int val) async {
    await _prefs.setInt(key, val);
  }

  int? getIntValue(String key, [int? defaultVal]) {
    int? val = _prefs.getInt(key);

    return val ??= defaultVal;
  }

  /// Sets the provided [val] as a double value against the given [key] in shared preferences.
  ///
  /// Returns a [Future] that completes with [void] once the operation is complete.
  ///
  /// The [key] parameter represents the key to be used to store the value in shared preferences.
  ///
  /// The [val] parameter represents the double value to be stored in shared preferences.
  Future<void> addDouble(String key, double val) async {
    await _prefs.setDouble(key, val);
  }

  double? getDoubleValue(String key, [double? defaultVal]) {
    double? val = _prefs.getDouble(key);

    return val ??= defaultVal;
  }

  /// A function to clear all the data stored in shared preferences.
  ///
  /// This function does not take any arguments.
  ///
  /// The return type of this function is Future<void>.
  Future<void> clear() async {
    await _prefs.clear();
  }
}
