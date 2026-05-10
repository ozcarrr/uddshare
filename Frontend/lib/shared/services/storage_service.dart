import 'package:file_picker/file_picker.dart';

class StorageService {
  static Future<PlatformFile?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    return result?.files.first;
  }

  static Future<PlatformFile?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'pptx', 'doc', 'xlsx', 'ppt'],
      withData: true,
    );
    return result?.files.first;
  }
}
