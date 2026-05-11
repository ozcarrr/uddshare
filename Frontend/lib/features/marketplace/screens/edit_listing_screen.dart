import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class EditListingScreen extends StatefulWidget {
  final String listingId;
  const EditListingScreen({super.key, required this.listingId});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _category;
  String? _condition;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadListing());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _loadListing() {
    final provider = context.read<MarketplaceProvider>();
    final matches = provider.listings.where((l) => l.id == widget.listingId);
    if (matches.isEmpty) {
      context.go(AppConstants.marketplaceRoute);
      return;
    }
    final listing = matches.first;
    _titleCtrl.text = listing.title;
    _descCtrl.text = listing.description ?? '';
    _priceCtrl.text = listing.price.toStringAsFixed(0);
    setState(() {
      _category = listing.category;
      _condition = listing.condition;
      _loaded = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<MarketplaceProvider>();
    final ok = await provider.updateListing(
      widget.listingId,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      category: _category!,
      condition: _condition!,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicación actualizada'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppConstants.marketplaceRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al actualizar'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const UDDAppBar(),
      body: !_loaded
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Volver al Marketplace'),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700),
                        onPressed: () => context.go(AppConstants.marketplaceRoute),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Editar Publicación',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Modifica los datos de tu artículo',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _titleCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Título del artículo *',
                                    prefixIcon: Icon(Icons.sell_outlined),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Ingresa un título'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _descCtrl,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Descripción',
                                    prefixIcon:
                                        Icon(Icons.description_outlined),
                                    alignLabelWithHint: true,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _priceCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Precio (CLP) *',
                                    prefixIcon: Icon(Icons.attach_money),
                                    prefixText: '\$ ',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Ingresa un precio';
                                    }
                                    if (double.tryParse(v) == null) {
                                      return 'Precio inválido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _category,
                                  decoration: const InputDecoration(
                                    labelText: 'Categoría *',
                                    prefixIcon:
                                        Icon(Icons.category_outlined),
                                  ),
                                  items: AppConstants.categories
                                      .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(
                                              AppConstants.categoryLabels[c]!)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _category = v),
                                  validator: (v) => v == null
                                      ? 'Selecciona una categoría'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _condition,
                                  decoration: const InputDecoration(
                                    labelText: 'Estado del artículo *',
                                    prefixIcon: Icon(Icons.star_outline),
                                  ),
                                  items: AppConstants.conditions
                                      .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(AppConstants
                                              .conditionLabels[c]!)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _condition = v),
                                  validator: (v) => v == null
                                      ? 'Selecciona el estado'
                                      : null,
                                ),
                                const SizedBox(height: 28),
                                if (provider.isLoading)
                                  const LoadingIndicator()
                                else
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.save),
                                      label: const Text('Guardar Cambios',
                                          style: TextStyle(fontSize: 15)),
                                      onPressed: _submit,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
