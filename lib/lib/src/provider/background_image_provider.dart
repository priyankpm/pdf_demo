import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class BackgroundImageProvider extends ChangeNotifier {
  static const _boxName = 'background_images';
  late Box<String> _imageBox;

  List<String> _imagePaths = [];
  int _currentIndex = 0;
  bool _isInitialized = false;

  // --- Getters ---
  List<String> get imagePaths => List.unmodifiable(_imagePaths);

  /// Returns the current image, or null if it's the upload slot
  String? get currentImage {
    if (_imagePaths.isEmpty) return null;
    if (_currentIndex >= _imagePaths.length) return null;
    return _imagePaths[_currentIndex];
  }

  int get currentIndex => _currentIndex;

  bool get hasImages => _imagePaths.isNotEmpty;

  bool get hasMultipleImages => _imagePaths.length > 1;

  /// True if at the upload slot (after last image)
  bool get isLast => _currentIndex == _imagePaths.length;

  /// True if at the first image
  bool get isFirst => _currentIndex == 0 && _imagePaths.isNotEmpty;

  /// Total number of slots (images + upload slot)
  int get totalSlots => _imagePaths.length + 1;

  bool get isNotEmpty => _imagePaths.isNotEmpty;

  bool get isEmpty => _imagePaths.isEmpty;

  bool get isInitialized => _isInitialized;

  BackgroundImageProvider() {
    _initHive();
  }

  // --- Hive init ---
  Future<void> _initHive() async {
    try {
      _imageBox = await Hive.openBox<String>(_boxName);
      _imagePaths = _imageBox.values.toList();
      _currentIndex = _imagePaths.isEmpty ? 0 : 0;
      _isInitialized = true;

      // DEBUG: Print what's actually in Hive
      print('=== HIVE INITIALIZATION DEBUG ===');
      print('Raw Hive contents: ${_imageBox.values.toList()}');
      print('Processed imagePaths: $_imagePaths');
      print('=================================');

      notifyListeners();
    } catch (e) {
      print('Error initializing BackgroundImageProvider: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }
  // --- Add new image ---
  Future<void> addImage(String path) async {
    if (!_isInitialized) {
      if (kDebugMode) {
        print('BackgroundImageProvider not initialized yet');
      }
      return;
    }

    try {
      await _imageBox.add(path);
      _imagePaths = _imageBox.values.toList();
      _currentIndex = _imagePaths.length - 1; // Move to newly added image
      notifyListeners();

      if (kDebugMode) {
        print('=== IMAGE ADDED ===');
        print('Path: $path');
        print('Total images: ${_imagePaths.length}');
        print('Current index: $_currentIndex');
        print('===================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding image: $e');
      }
      rethrow;
    }
  }

  // --- Set multiple images at once ---
  Future<void> setBackgroundImages(List<String> paths) async {
    if (!_isInitialized) {
      print('BackgroundImageProvider not initialized yet');
      return;
    }

    try {
      // Clear existing data
      await _imageBox.clear();

      // Store each path individually
      for (final path in paths) {
        await _imageBox.add(path);
        print('Stored in Hive: $path');
      }

      _imagePaths = _imageBox.values.toList();
      _currentIndex = _imagePaths.isEmpty ? 0 : 0;

      print('=== BACKGROUND IMAGES SET IN HIVE ===');
      print('Stored ${paths.length} images');
      print('Hive now contains: $_imagePaths');
      print('=====================================');

      notifyListeners();
    } catch (e) {
      print('Error setting background images in Hive: $e');
      rethrow;
    }
  }
  // --- Navigation ---
  void previousImage() {
    if (!_isInitialized || totalSlots <= 1) return;

    _currentIndex = (_currentIndex - 1 + totalSlots) % totalSlots;
    notifyListeners();

    if (kDebugMode) {
      print('=== PREVIOUS IMAGE ===');
      print('New index: $_currentIndex');
      print('Current image: ${currentImage ?? "Upload Slot"}');
      print('=====================');
    }
  }

  void nextImage() {
    if (!_isInitialized || totalSlots <= 1) return;

    _currentIndex = (_currentIndex + 1) % totalSlots;
    notifyListeners();

    if (kDebugMode) {
      print('=== NEXT IMAGE ===');
      print('New index: $_currentIndex');
      print('Current image: ${currentImage ?? "Upload Slot"}');
      print('==================');
    }
  }

  // --- Jump to specific index ---
  void jumpToIndex(int index) {
    if (!_isInitialized) return;

    if (index >= 0 && index < totalSlots) {
      _currentIndex = index;
      notifyListeners();

      if (kDebugMode) {
        print('=== JUMP TO INDEX ===');
        print('New index: $_currentIndex');
        print('Current image: ${currentImage ?? "Upload Slot"}');
        print('=====================');
      }
    }
  }

  // --- Remove image ---
  Future<void> removeImage(int index) async {
    if (!_isInitialized || index < 0 || index >= _imagePaths.length) return;

    try {
      if (kDebugMode) {
        print('=== REMOVING IMAGE ===');
        print('Removing index: $index');
        print('Path: ${_imagePaths[index]}');
      }

      await _imageBox.deleteAt(index);
      _imagePaths = _imageBox.values.toList();

      // Adjust current index safely
      if (_imagePaths.isEmpty) {
        _currentIndex = 0; // Back to upload slot
      } else if (_currentIndex >= _imagePaths.length) {
        _currentIndex = _imagePaths.length - 1; // Move to last image
      } else if (_currentIndex >= index) {
        _currentIndex = _currentIndex - 1; // Adjust for removed item
        if (_currentIndex < 0) _currentIndex = 0;
      }

      notifyListeners();

      if (kDebugMode) {
        print('Image removed successfully');
        print('Remaining images: ${_imagePaths.length}');
        print('New current index: $_currentIndex');
        print('====================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing image: $e');
      }
      rethrow;
    }
  }

  // --- Remove current image ---
  Future<void> removeCurrentImage() async {
    if (!_isInitialized || _imagePaths.isEmpty) return;
    await removeImage(_currentIndex);
  }

  // --- Clear all ---
  Future<void> clearAllImages() async {
    if (!_isInitialized) return;

    try {
      await _imageBox.clear();
      _imagePaths.clear();
      _currentIndex = 0; // Back to upload slot
      notifyListeners();

      if (kDebugMode) {
        print('=== ALL IMAGES CLEARED ===');
        print('Back to upload slot');
        print('==========================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing images: $e');
      }
      rethrow;
    }
  }

  // --- Check if image exists at index ---
  bool imageExistsAt(int index) {
    return index >= 0 && index < _imagePaths.length;
  }

  // --- Get image at specific index ---
  String? getImageAt(int index) {
    if (index >= 0 && index < _imagePaths.length) {
      return _imagePaths[index];
    }
    return null;
  }

  // --- Dispose ---
  @override
  void dispose() {
    _imageBox.close();
    super.dispose();
  }
}