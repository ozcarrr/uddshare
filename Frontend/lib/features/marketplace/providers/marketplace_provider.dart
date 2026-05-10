import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../shared/services/api_service.dart';

class ListingModel {
  final String id;
  final String sellerId;
  final String title;
  final String? description;
  final double price;
  final String category;
  final String condition;
  final String status;
  final String? imageUrl;
  final DateTime createdAt;

  const ListingModel({
    required this.id,
    required this.sellerId,
    required this.title,
    this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.status,
    this.imageUrl,
    required this.createdAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) => ListingModel(
        id: json['id'] as String,
        sellerId: json['seller_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        category: json['category'] as String,
        condition: json['condition'] as String,
        status: json['status'] as String,
        imageUrl: json['image_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}

class MarketplaceProvider extends ChangeNotifier {
  final Dio _dio = ApiService.instance.dio;

  List<ListingModel> _listings = [];
  ListingModel? _selected;
  bool _isLoading = false;
  String? _error;

  List<ListingModel> get listings => _listings;
  ListingModel? get selected => _selected;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchListings({String? category, String? search}) async {
    _setLoading(true);
    try {
      final params = <String, dynamic>{};
      if (category != null) params['category'] = category;
      if (search != null && search.isNotEmpty) params['search'] = search;
      final response = await _dio.get('/listings/', queryParameters: params);
      _listings = (response.data as List)
          .map((j) => ListingModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al cargar publicaciones');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchListing(String id) async {
    _setLoading(true);
    try {
      final response = await _dio.get('/listings/$id');
      _selected = ListingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al cargar la publicación');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createListing({
    required String title,
    String? description,
    required double price,
    required String category,
    required String condition,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    _setLoading(true);
    try {
      final formData = FormData.fromMap({
        'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        'price': price.toString(),
        'category': category,
        'condition': condition,
        if (imageBytes != null && imageFileName != null)
          'image': MultipartFile.fromBytes(imageBytes, filename: imageFileName),
      });
      final response = await _dio.post('/listings/', data: formData);
      _listings.insert(0, ListingModel.fromJson(response.data as Map<String, dynamic>));
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al crear publicación');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteListing(String id) async {
    try {
      await _dio.delete('/listings/$id');
      _listings.removeWhere((l) => l.id == id);
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = _extractError(e, 'Error al eliminar publicación');
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
