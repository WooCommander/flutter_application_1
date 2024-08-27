import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<String?> loadJsonFromFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result != null && result.files.single.path != null) {
    final file = File(result.files.single.path!);
    return await file.readAsString();
  }

  return null;
}
