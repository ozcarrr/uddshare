class AppConstants {
  // API
  static const String apiBaseUrl = 'http://localhost:8000/api/v1';
  static const String uploadsBaseUrl = 'http://localhost:8000';

  // Secure storage keys
  static const String tokenKey = 'uddshare_token';
  static const String userKey = 'uddshare_user';

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String marketplaceRoute = '/marketplace';
  static const String marketplaceNewRoute = '/marketplace/new';
  static const String notesRoute = '/notes';
  static const String notesUploadRoute = '/notes/upload';

  // UI labels
  static const String appName = 'UDDShare';
  static const String appTagline = 'Plataforma exclusiva para estudiantes UDD';

  // Marketplace categories
  static const List<String> categories = [
    'textbook',
    'supplies',
    'electronics',
    'other',
  ];

  static const Map<String, String> categoryLabels = {
    'textbook': 'Libro de texto',
    'supplies': 'Material de laboratorio',
    'electronics': 'Electrónica',
    'other': 'Otro',
  };

  // Item conditions
  static const List<String> conditions = [
    'new',
    'like_new',
    'good',
    'acceptable',
  ];

  static const Map<String, String> conditionLabels = {
    'new': 'Nuevo',
    'like_new': 'Como nuevo',
    'good': 'Buen estado',
    'acceptable': 'Aceptable',
  };

  // UDD faculties / careers
  static const List<String> careers = [
    'Medicina',
    'Ingeniería',
    'Arquitectura y Arte',
    'Comunicaciones',
    'Derecho',
    'Economía y Negocios',
    'Psicología',
    'Diseño',
  ];

  static const uddBlue = 0xFF005293;
}
