import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class MultiFormDataManager {
  final Map<String, String> textData = {};
  final Map<String, List<File>> fileData = {}; // Store files with custom keys

  // Add text data
  void addTextData(String key, String value) {
    textData[key] = value;
  }

  // Add multiple text data
  void addMultipleTextData(Map<String, String> data) {
    textData.addAll(data);
  }

  // Add image files from XFile with a custom key
  Future<void> addImages(List<XFile> images, {required String key}) async {
    fileData.putIfAbsent(key, () => []);
    for (var image in images) {
      fileData[key]!.add(File(image.path));
    }
  }

  // Add image files from File with a custom key
  void addImageFiles(List<File> files, {required String key}) {
    fileData.putIfAbsent(key, () => []);
    fileData[key]!.addAll(files);
  }

  // Add single image file with a custom key
  void addImageFile(File file, {required String key}) {
    fileData.putIfAbsent(key, () => []);
    fileData[key]!.add(file);
  }

  // Add documents from PlatformFile with a custom key
  Future<void> addDocuments(List<PlatformFile> files, {required String key}) async {
    fileData.putIfAbsent(key, () => []);
    for (var file in files) {
      if (file.path != null) {
        fileData[key]!.add(File(file.path!));
      }
    }
  }

  // Add document files from File with a custom key
  void addDocumentFiles(List<File> files, {required String key}) {
    fileData.putIfAbsent(key, () => []);
    fileData[key]!.addAll(files);
  }

  // Add single document file with a custom key
  void addDocumentFile(File file, {required String key}) {
    fileData.putIfAbsent(key, () => []);
    fileData[key]!.add(file);
  }

  // Add any type of file with a custom key
  void addFiles(List<File> files, {required String key}) {
    fileData.putIfAbsent(key, () => []);
    fileData[key]!.addAll(files);
  }

  // Add single file with a custom key
  void addFile(File file, {required String key}) {
    fileData.putIfAbsent(key, () => []);
    fileData[key]!.add(file);
  }

  // Remove text data by key
  void removeTextData(String key) {
    textData.remove(key);
  }

  // Remove file by index for a specific key
  void removeFileAt(String key, int index) {
    if (fileData.containsKey(key) && index >= 0 && index < fileData[key]!.length) {
      fileData[key]!.removeAt(index);
      if (fileData[key]!.isEmpty) {
        fileData.remove(key); // Clean up empty key
      }
    }
  }

  // Clear all data
  void clear() {
    textData.clear();
    fileData.clear();
  }

  // Clear only text data
  void clearTextData() {
    textData.clear();
  }

  // Clear files for a specific key
  void clearFiles(String key) {
    fileData.remove(key);
  }

  // Clear all files
  void clearAllFiles() {
    fileData.clear();
  }

  // Check if form data is empty
  bool isEmpty() {
    return textData.isEmpty && fileData.isEmpty;
  }

  // Get total file count
  int get totalFileCount {
    return fileData.values.fold(0, (sum, files) => sum + files.length);
  }

  // Get total size of all files in bytes
  Future<int> getTotalSize() async {
    int totalSize = 0;
    for (var files in fileData.values) {
      for (var file in files) {
        totalSize += await file.length();
      }
    }
    return totalSize;
  }

  // Convert to Dio FormData (synchronous version)
  FormData toFormData() {
    final formData = FormData();

    // Add text fields
    textData.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    // Add files with their respective keys
    fileData.forEach((key, files) {
      for (var i = 0; i < files.length; i++) {
        formData.files.add(MapEntry(
          key,
          MultipartFile.fromFileSync(
            files[i].path,
            filename: _getFileName(files[i], '${key}_$i'),
          ),
        ));
      }
    });

    return formData;
  }

  // Async version for large files
  Future<FormData> toFormDataAsync() async {
    final formData = FormData();

    // Add text fields
    textData.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    // Add files with their respective keys
    for (var entry in fileData.entries) {
      final key = entry.key;
      final files = entry.value;
      for (var i = 0; i < files.length; i++) {
        formData.files.add(MapEntry(
          key,
          await MultipartFile.fromFile(
            files[i].path,
            filename: _getFileName(files[i], '${key}_$i'),
          ),
        ));
      }
    }

    return formData;
  }

  // Enhanced method with validation
  Future<FormData> toFormDataWithValidation({
    int maxFileSize = 10 * 1024 * 1024, // 10MB default
    Map<String, List<String>> allowedFileTypes = const {}, // Map of key to allowed extensions
  }) async {
    final formData = FormData();
    final errors = <String>[];

    // Validate and add text fields
    textData.forEach((key, value) {
      if (value.isEmpty) {
        errors.add('Field "$key" cannot be empty');
      }
      formData.fields.add(MapEntry(key, value));
    });

    // Validate and add files
    for (var entry in fileData.entries) {
      final key = entry.key;
      final files = entry.value;
      final allowedTypes = allowedFileTypes[key] ?? ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'doc', 'docx', 'txt', 'rtf'];

      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final extension = _getFileExtension(file.path);

        if (!allowedTypes.contains(extension.toLowerCase())) {
          errors.add('File ${file.path} for key "$key" has invalid type: $extension');
          continue;
        }

        final length = await file.length();
        if (length > maxFileSize) {
          errors.add('File ${file.path} for key "$key" exceeds maximum size (${maxFileSize ~/ (1024 * 1024)}MB)');
          continue;
        }

        formData.files.add(MapEntry(
          key,
          await MultipartFile.fromFile(
            file.path,
            filename: _getFileName(file, '${key}_$i'),
          ),
        ));
      }
    }

    if (errors.isNotEmpty) {
      throw FormatException('Validation failed: ${errors.join(", ")}');
    }

    return formData;
  }

  // Helper method to get file name with extension
  String _getFileName(File file, String fallbackName) {
    final path = file.path;
    final fileName = path.split('/').last;
    return fileName.isNotEmpty ? fileName : '$fallbackName.${_getFileExtension(path)}';
  }

  // Helper method to get file extension
  String _getFileExtension(String path) {
    final parts = path.split('.');
    return parts.length > 1 ? parts.last : 'bin';
  }

  // Get summary of form data (useful for debugging)
  Future<Map<String, dynamic>> getSummary() async {
    final fileSummary = <String, List<String>>{};
    fileData.forEach((key, files) {
      fileSummary[key] = files.map((f) => f.path).toList();
    });

    return {
      'textFields': textData.length,
      'totalFiles': totalFileCount,
      'totalSize': await getTotalSize(),
      'textData': textData,
      'fileData': fileSummary,
    };
  }

  // Create a copy of the form data manager
  MultiFormDataManager copy() {
    final copy = MultiFormDataManager();
    copy.textData.addAll(textData);
    fileData.forEach((key, files) {
      copy.fileData[key] = List.from(files);
    });
    return copy;
  }
}