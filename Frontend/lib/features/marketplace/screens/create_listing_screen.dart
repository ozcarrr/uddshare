import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _category;
  String? _condition;
  Uint8List? _imageBytes;
  String? _imageFileName;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await StorageService.pickImage();
    if (file != null) {
      setState(() {
        _imageBytes = file.bytes;
        _imageFileName = file.name;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<MarketplaceProvider>();
    final ok = await provider.createListing(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      category: _category!,
      condition: _condition!,
      imageBytes: _imageBytes,
      imageFileName: _imageFileName,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicación creada con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppConstants.marketplaceRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al crear publicación'),
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
      body: SingleChildScrollView(
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
                  style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
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
                            'Nueva Publicación',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Completa los datos de tu artículo',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          // Title
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
                          // Description
                          TextFormField(
                            controller: _descCtrl,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                              prefixIcon: Icon(Icons.description_outlined),
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Price
                          TextFormField(
                            controller: _priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Precio (CLP) *',
                              prefixIcon: Icon(Icons.attach_money),
                              prefixText: '\$ ',
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingresa un precio';
                              if (double.tryParse(v) == null) {
                                return 'Precio inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Category
                          DropdownButtonFormField<String>(
                            value: _category,
                            decoration: const InputDecoration(
                              labelText: 'Categoría *',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            items: AppConstants.categories
                                .map((c) => DropdownMenuItem(
                                    value: c,
                                    child:
                                        Text(AppConstants.categoryLabels[c]!)))
                                .toList(),
                            onChanged: (v) => setState(() => _category = v),
                            validator: (v) =>
                                v == null ? 'Selecciona una categoría' : null,
                          ),
                          const SizedBox(height: 16),
                          // Condition
                          DropdownButtonFormField<String>(
                            value: _condition,
                            decoration: const InputDecoration(
                              labelText: 'Estado del artículo *',
                              prefixIcon: Icon(Icons.star_outline),
                            ),
                            items: AppConstants.conditions
                                .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                        AppConstants.conditionLabels[c]!)))
                                .toList(),
                            onChanged: (v) => setState(() => _condition = v),
                            validator: (v) =>
                                v == null ? 'Selecciona el estado' : null,
                          ),
                          const SizedBox(height: 20),
                          // Image picker
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(
                                    color: Colors.grey.shade300,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(_imageBytes!,
                                          fit: BoxFit.cover,
                                          width: double.infinity),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate_outlined,
                                            size: 40,
                                            color: Colors.grey.shade400),
                                        const SizedBox(height: 8),
                                        Text('Agregar imagen (opcional)',
                                            style: TextStyle(
                                                color: Colors.grey.shade500)),
                                      ],
                                    ),
                            ),
                          ),
                          if (_imageFileName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '📎 $_imageFileName',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ),
                          const SizedBox(height: 28),
                          if (provider.isLoading)
                            const LoadingIndicator()
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.publish),
                                label: const Text('Publicar Artículo',
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
