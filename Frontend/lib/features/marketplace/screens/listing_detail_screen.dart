import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;
  const ListingDetailScreen({super.key, required this.listingId});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().fetchListing(widget.listingId);
    });
  }

  String _formatPrice(double price) =>
      '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const UDDAppBar(),
      body: provider.isLoading
          ? const LoadingIndicator()
          : provider.selected == null
              ? _NotFound()
              : _DetailBody(
                  listing: provider.selected!,
                  formatPrice: _formatPrice,
                ),
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Publicación no encontrada',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al Marketplace'),
              onPressed: () => context.go(AppConstants.marketplaceRoute),
            ),
          ],
        ),
      );
}

class _DetailBody extends StatelessWidget {
  final ListingModel listing;
  final String Function(double) formatPrice;

  const _DetailBody({required this.listing, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          TextButton.icon(
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Volver al Marketplace'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
            onPressed: () => context.go(AppConstants.marketplaceRoute),
          ),
          const SizedBox(height: 16),
          // Main layout
          LayoutBuilder(builder: (ctx, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _ImageSection(listing: listing)),
                  const SizedBox(width: 32),
                  Expanded(child: _InfoSection(listing: listing, formatPrice: formatPrice)),
                ],
              );
            }
            return Column(
              children: [
                _ImageSection(listing: listing),
                const SizedBox(height: 24),
                _InfoSection(listing: listing, formatPrice: formatPrice),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final ListingModel listing;
  const _ImageSection({required this.listing});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: listing.imageUrl != null
            ? Image.network(
                '${AppConstants.uploadsBaseUrl}${listing.imageUrl}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey.shade200,
        child:
            Center(child: Icon(Icons.image_outlined, size: 80, color: Colors.grey.shade400)),
      );
}

class _InfoSection extends StatelessWidget {
  final ListingModel listing;
  final String Function(double) formatPrice;

  const _InfoSection({required this.listing, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & badges
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.title,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(
                          AppConstants.categoryLabels[listing.category] ??
                              listing.category),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: TextStyle(color: Colors.blue.shade800),
                    ),
                    Chip(
                      label: Text(
                          AppConstants.conditionLabels[listing.condition] ??
                              listing.condition),
                      backgroundColor: Colors.green.shade50,
                      labelStyle: TextStyle(color: Colors.green.shade800),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  formatPrice(listing.price),
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005293)),
                ),
                const Divider(height: 32),
                _DetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Categoría',
                    value: AppConstants.categoryLabels[listing.category] ??
                        listing.category),
                const SizedBox(height: 12),
                _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Publicado',
                    value: _formatDate(listing.createdAt)),
                const Divider(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.message_outlined),
                    label: const Text('Contactar al Vendedor',
                        style: TextStyle(fontSize: 15)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Contacta al vendedor por correo UDD o en el campus'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Description
        if (listing.description != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Descripción',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(listing.description!,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.6,
                          fontSize: 15)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        // Safety notice
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.security, size: 18, color: Colors.amber.shade800),
                const SizedBox(width: 8),
                Text('Consejos de Seguridad',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                        fontSize: 14)),
              ]),
              const SizedBox(height: 8),
              ...const [
                '• Conoce al vendedor en un lugar público dentro del campus',
                '• Verifica el estado del producto antes de pagar',
                '• No compartas información personal sensible',
              ].map((t) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(t,
                        style: TextStyle(
                            color: Colors.amber.shade800, fontSize: 13)),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(value,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
