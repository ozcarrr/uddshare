import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

/// Compact side navigation for narrow viewports.
/// Not used in the primary web layout (which uses the top AppBar nav),
/// but available for responsive breakpoints.
class UDDNavRail extends StatelessWidget {
  const UDDNavRail({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = location.startsWith(AppConstants.notesRoute) ? 1 : 0;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) {
        context.go(i == 0 ? AppConstants.marketplaceRoute : AppConstants.notesRoute);
      },
      labelType: NavigationRailLabelType.all,
      indicatorColor: const Color(0xFF005293).withOpacity(0.12),
      selectedIconTheme: const IconThemeData(color: Color(0xFF005293)),
      selectedLabelTextStyle: const TextStyle(
        color: Color(0xFF005293),
        fontWeight: FontWeight.bold,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.store_outlined),
          selectedIcon: Icon(Icons.store),
          label: Text('Marketplace'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description),
          label: Text('Apuntes'),
        ),
      ],
    );
  }
}
