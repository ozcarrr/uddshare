import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../../../core/constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().fetchListings();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<MarketplaceProvider>().fetchListings(
          category: _selectedCategory,
          search: _searchCtrl.text.trim(),
        );
  }

  String _formatPrice(double price) =>
      '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    final currentUserId = context.watch<AuthProvider>().user?.id;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const UDDAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppConstants.marketplaceNewRoute),
        backgroundColor: const Color(0xFF005293),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva publicación'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Marketplace',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Encuentra materiales de curso usados por otros estudiantes UDD',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 16),
                // Search + filter row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Buscar productos, cursos...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        onSubmitted: (_) => _applyFilters(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('Todas')),
                          ...AppConstants.categories.map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(AppConstants.categoryLabels[c]!),
                              )),
                        ],
                        onChanged: (v) {
                          setState(() => _selectedCategory = v);
                          context.read<MarketplaceProvider>().fetchListings(
                                category: v,
                                search: _searchCtrl.text.trim(),
                              );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text('Buscar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Results
          Expanded(
            child: provider.isLoading
                ? const LoadingIndicator()
                : provider.listings.isEmpty
                    ? _EmptyState(onClear: () {
                        setState(() {
                          _searchCtrl.clear();
                          _selectedCategory = null;
                        });
                        context.read<MarketplaceProvider>().fetchListings();
                      })
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: Text(
                              '${provider.listings.length} '
                              '${provider.listings.length == 1 ? 'producto encontrado' : 'productos encontrados'}',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(builder: (ctx, constraints) {
                              final cols =
                                  constraints.maxWidth > 900 ? 3 : 2;
                              return GridView.builder(
                                padding: const EdgeInsets.all(24),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.78,
                                ),
                                itemCount: provider.listings.length,
                                itemBuilder: (_, i) => _ListingCard(
                                  listing: provider.listings[i],
                                  formatPrice: _formatPrice,
                                  currentUserId: currentUserId,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final ListingModel listing;
  final String Function(double) formatPrice;
  final String? currentUserId;

  const _ListingCard({
    required this.listing,
    required this.formatPrice,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = currentUserId != null && currentUserId == listing.sellerId;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: () => context.go('/marketplace/${listing.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: listing.imageUrl != null
                      ? Image.network(
                          '${AppConstants.uploadsBaseUrl}${listing.imageUrl}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _PlaceholderImage(),
                        )
                      : _PlaceholderImage(),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (listing.description != null)
                          Text(
                            listing.description!,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const Spacer(),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _Badge(
                              label: AppConstants.categoryLabels[listing.category] ??
                                  listing.category,
                              color: Colors.blue.shade50,
                              textColor: Colors.blue.shade800,
                            ),
                            _Badge(
                              label: AppConstants.conditionLabels[listing.condition] ??
                                  listing.condition,
                              color: Colors.green.shade50,
                              textColor: Colors.green.shade800,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatPrice(listing.price),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005293),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isOwner)
            Positioned(
              top: 4,
              right: 4,
              child: PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
                ),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Editar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outlined, color: Colors.red),
                      title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    context.go('/marketplace/${listing.id}/edit');
                  } else if (value == 'delete') {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('¿Eliminar publicación?'),
                        content: Text(
                            '¿Eliminar "${listing.title}"? Esta acción no se puede deshacer.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<MarketplaceProvider>().deleteListing(listing.id);
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(Icons.image_outlined,
              size: 48, color: Colors.grey.shade400),
        ),
      );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Badge(
      {required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w500)),
      );
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No se encontraron productos',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: onClear, child: const Text('Limpiar filtros')),
          ],
        ),
      );
}
