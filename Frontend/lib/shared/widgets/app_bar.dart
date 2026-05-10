import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../features/auth/providers/auth_provider.dart';

class UDDAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UDDAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'UDD',
              style: TextStyle(
                color: Color(0xFF005293),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            AppConstants.appName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      actions: [
        _NavButton(
          label: 'Marketplace',
          route: AppConstants.marketplaceRoute,
          currentLocation: location,
        ),
        _NavButton(
          label: 'Centro Colaborativo',
          route: AppConstants.notesRoute,
          currentLocation: location,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white70),
          tooltip: 'Cerrar sesión',
          onPressed: () => context.read<AuthProvider>().logout(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String route;
  final String currentLocation;

  const _NavButton({
    required this.label,
    required this.route,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentLocation.startsWith(route);
    return TextButton(
      onPressed: () => context.go(route),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.white : Colors.white70,
        backgroundColor:
            isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}
