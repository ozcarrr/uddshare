import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/marketplace/screens/marketplace_screen.dart';
import '../features/marketplace/screens/listing_detail_screen.dart';
import '../features/marketplace/screens/create_listing_screen.dart';
import '../features/notes/screens/notes_screen.dart';
import '../features/notes/screens/upload_note_screen.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppConstants.marketplaceRoute,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final loc = state.matchedLocation;
      final isAuthRoute =
          loc == AppConstants.loginRoute || loc == AppConstants.registerRoute;

      if (!isAuthenticated && !isAuthRoute) return AppConstants.loginRoute;
      if (isAuthenticated && isAuthRoute) return AppConstants.marketplaceRoute;
      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.marketplaceRoute,
        builder: (_, __) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: AppConstants.marketplaceNewRoute,
        builder: (_, __) => const CreateListingScreen(),
      ),
      GoRoute(
        path: '/marketplace/:id',
        builder: (_, state) => ListingDetailScreen(
          listingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppConstants.notesRoute,
        builder: (_, __) => const NotesScreen(),
      ),
      GoRoute(
        path: AppConstants.notesUploadRoute,
        builder: (_, __) => const UploadNoteScreen(),
      ),
    ],
  );
}
