// services/shared_preferences_service.dart
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  static const String _backgroundImagesKey = 'background_images';
  static const String _petImagesKey = 'pet_images';

  Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> setUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, userData);
  }

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataKey);
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userIdKey);
  }

  Future<void> storeBackgroundImages(List<File?> images) async { // Change to List<File?>
    final prefs = await SharedPreferences.getInstance();

    // Store paths for uploaded images, and null for default images
    final List<String?> imagePaths = images.map((image) => image?.path).toList();

    // Convert to List<String> with placeholders for null values
    final List<String> storedPaths = imagePaths.map((path) => path ?? 'DEFAULT').toList();

    await prefs.setStringList(_backgroundImagesKey, storedPaths);
  }

  Future<List<File?>?> getBackgroundImages() async { // Change to List<File?>?
    final prefs = await SharedPreferences.getInstance();
    final storedPaths = prefs.getStringList(_backgroundImagesKey);
    if (storedPaths == null) return null;

    // Convert back to List<File?> where 'DEFAULT' becomes null
    return storedPaths.map((path) {
      return path == 'DEFAULT' ? null : File(path);
    }).toList();
  }

  Future<void> setUserBirthday(String birthday) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_birthday', birthday);
  }

  Future<String?> getUserBirthday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_birthday');
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<void> clearBackgroundImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_backgroundImagesKey);
  }

  Future<void> setPetName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_name', name);
  }

  Future<String?> getPetName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pet_name');
  }

  Future<void> setPetBirthday(String birthday) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_birthday', birthday);
  }

  Future<String?> getPetBirthday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pet_birthday');
  }

  Future<void> setPetGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_gender', gender);
  }

  Future<String?> getPetGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pet_gender');
  }

  // Pet Images Storage
  Future<void> storePetImages(List<File> images) async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = images.map((image) => image.path).toList();
    await prefs.setStringList(_petImagesKey, imagePaths);
  }

  Future<List<File>?> getPetImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = prefs.getStringList(_petImagesKey);
    if (imagePaths == null) return null;

    return imagePaths.map((path) => File(path)).toList();
  }

  Future<void> clearPetImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_petImagesKey);
  }

  Future<void> storePetPortraitUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_portrait_url', url);
  }

  Future<String?> getPetPortraitUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pet_portrait_url');
  }

  Future<void> storePetPortraitKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_portrait_key', key);
  }

  Future<String?> getPetPortraitKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pet_portrait_key');
  }

  Future<void> storePetImageId(String imageId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_image_id', imageId);
  }

  Future<String?> getPetImageId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pet_image_id');
  }
}