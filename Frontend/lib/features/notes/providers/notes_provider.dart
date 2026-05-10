import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../shared/services/api_service.dart';

class NoteModel {
  final String id;
  final String uploaderId;
  final String title;
  final String? description;
  final String career;
  final String course;
  final String? semester;
  final String fileUrl;
  final String? fileType;
  final int downloadCount;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.uploaderId,
    required this.title,
    this.description,
    required this.career,
    required this.course,
    this.semester,
    required this.fileUrl,
    this.fileType,
    required this.downloadCount,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'] as String,
        uploaderId: json['uploader_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        career: json['career'] as String,
        course: json['course'] as String,
        semester: json['semester'] as String?,
        fileUrl: json['file_url'] as String,
        fileType: json['file_type'] as String?,
        downloadCount: json['download_count'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  NoteModel copyWith({int? downloadCount}) => NoteModel(
        id: id,
        uploaderId: uploaderId,
        title: title,
        description: description,
        career: career,
        course: course,
        semester: semester,
        fileUrl: fileUrl,
        fileType: fileType,
        downloadCount: downloadCount ?? this.downloadCount,
        createdAt: createdAt,
      );
}

class NotesProvider extends ChangeNotifier {
  final Dio _dio = ApiService.instance.dio;

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNotes({String? career, String? course, String? search}) async {
    _setLoading(true);
    try {
      final params = <String, dynamic>{};
      if (career != null) params['career'] = career;
      if (course != null) params['course'] = course;
      if (search != null && search.isNotEmpty) params['search'] = search;
      final response = await _dio.get('/notes/', queryParameters: params);
      _notes = (response.data as List)
          .map((j) => NoteModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al cargar apuntes');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadNote({
    required String title,
    String? description,
    required String career,
    required String course,
    String? semester,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    _setLoading(true);
    try {
      final formData = FormData.fromMap({
        'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        'career': career,
        'course': course,
        if (semester != null && semester.isNotEmpty) 'semester': semester,
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });
      final response = await _dio.post('/notes/', data: formData);
      _notes.insert(0, NoteModel.fromJson(response.data as Map<String, dynamic>));
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al subir apunte');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> downloadNote(String id) async {
    try {
      final response = await _dio.post('/notes/$id/download');
      final data = response.data as Map<String, dynamic>;
      final idx = _notes.indexWhere((n) => n.id == id);
      if (idx >= 0) {
        _notes[idx] = _notes[idx].copyWith(
          downloadCount: data['download_count'] as int,
        );
        notifyListeners();
      }
      return data['file_url'] as String;
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteNote(String id) async {
    try {
      await _dio.delete('/notes/$id');
      _notes.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al eliminar apunte');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _error = null;
    notifyListeners();
  }

  String _extractError(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map) return (data['detail'] as String?) ?? fallback;
    return fallback;
  }
}
