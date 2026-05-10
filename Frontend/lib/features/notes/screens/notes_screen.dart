import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/notes_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedCareer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().fetchNotes();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _download(NoteModel note) async {
    final provider = context.read<NotesProvider>();
    final relativeUrl = await provider.downloadNote(note.id);
    if (relativeUrl == null || !mounted) return;

    final fullUrl = '${AppConstants.uploadsBaseUrl}$relativeUrl';
    final uri = Uri.parse(fullUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const UDDAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppConstants.notesUploadRoute),
        backgroundColor: const Color(0xFF005293),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: const Text('Subir Apunte'),
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
                  'Centro Colaborativo',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Apuntes y materiales de estudio compartidos por la comunidad UDD',
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
                          hintText: 'Buscar apuntes, cursos...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        onSubmitted: (_) => _applyFilters(provider),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCareer,
                        decoration: InputDecoration(
                          labelText: 'Carrera',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('Todas las carreras')),
                          ...AppConstants.careers.map((c) =>
                              DropdownMenuItem(value: c, child: Text(c))),
                        ],
                        onChanged: (v) {
                          setState(() => _selectedCareer = v);
                          provider.fetchNotes(
                              career: v,
                              search: _searchCtrl.text.trim());
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _applyFilters(provider),
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
                : provider.notes.isEmpty
                    ? _EmptyState(onClear: () {
                        setState(() {
                          _searchCtrl.clear();
                          _selectedCareer = null;
                        });
                        provider.fetchNotes();
                      })
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: Text(
                              '${provider.notes.length} '
                              '${provider.notes.length == 1 ? 'apunte encontrado' : 'apuntes encontrados'}',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (ctx, constraints) {
                                final cols =
                                    constraints.maxWidth > 900 ? 3 : 2;
                                return GridView.builder(
                                  padding: const EdgeInsets.all(24),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: cols,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.85,
                                  ),
                                  itemCount: provider.notes.length,
                                  itemBuilder: (_, i) => _NoteCard(
                                    note: provider.notes[i],
                                    onDownload: () =>
                                        _download(provider.notes[i]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
          // Info banner
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '¿Quieres compartir tus apuntes? Ayuda a la comunidad UDD subiendo tus resúmenes. '
                    'Todos los materiales son gratuitos.',
                    style: TextStyle(color: Colors.blue.shade800, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters(NotesProvider provider) {
    provider.fetchNotes(
      career: _selectedCareer,
      search: _searchCtrl.text.trim(),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onDownload;

  const _NoteCard({required this.note, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + file type badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.description,
                      size: 28, color: Colors.green.shade600),
                ),
                const Spacer(),
                if (note.fileType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      note.fileType!.toUpperCase(),
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              note.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.description != null) ...[
              const SizedBox(height: 6),
              Text(
                note.description!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Spacer(),
            // Course & career
            Text(
              note.course,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(
              note.career,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Downloads + date + download button
            Row(
              children: [
                Icon(Icons.download, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  '${note.downloadCount}',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Descargar', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF005293),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6)),
                  onPressed: onDownload,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
            const Text('No se encontraron apuntes',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: onClear, child: const Text('Limpiar filtros')),
          ],
        ),
      );
}
