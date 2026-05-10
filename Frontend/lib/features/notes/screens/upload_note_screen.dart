import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class UploadNoteScreen extends StatefulWidget {
  const UploadNoteScreen({super.key});

  @override
  State<UploadNoteScreen> createState() => _UploadNoteScreenState();
}

class _UploadNoteScreenState extends State<UploadNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _semesterCtrl = TextEditingController();
  String? _career;
  Uint8List? _fileBytes;
  String? _fileName;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _courseCtrl.dispose();
    _semesterCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await StorageService.pickDocument();
    if (file != null) {
      setState(() {
        _fileBytes = file.bytes;
        _fileName = file.name;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un archivo para subir'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final provider = context.read<NotesProvider>();
    final ok = await provider.uploadNote(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      career: _career!,
      course: _courseCtrl.text.trim(),
      semester: _semesterCtrl.text.trim(),
      fileBytes: _fileBytes!,
      fileName: _fileName!,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apunte subido con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppConstants.notesRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al subir apunte'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
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
                  label: const Text('Volver al Centro Colaborativo'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700),
                  onPressed: () => context.go(AppConstants.notesRoute),
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
                            'Subir Apunte',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Comparte tus apuntes con la comunidad UDD',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          // Title
                          TextFormField(
                            controller: _titleCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Título del apunte *',
                              prefixIcon: Icon(Icons.title),
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
                          // Career
                          DropdownButtonFormField<String>(
                            value: _career,
                            decoration: const InputDecoration(
                              labelText: 'Carrera *',
                              prefixIcon: Icon(Icons.school_outlined),
                            ),
                            items: AppConstants.careers
                                .map((c) => DropdownMenuItem(
                                    value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setState(() => _career = v),
                            validator: (v) =>
                                v == null ? 'Selecciona tu carrera' : null,
                          ),
                          const SizedBox(height: 16),
                          // Course
                          TextFormField(
                            controller: _courseCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del curso *',
                              prefixIcon: Icon(Icons.book_outlined),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Ingresa el curso'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          // Semester
                          TextFormField(
                            controller: _semesterCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Semestre (ej: 2025-1)',
                              prefixIcon: Icon(Icons.date_range_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // File picker
                          GestureDetector(
                            onTap: _pickFile,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: _fileBytes != null
                                    ? Colors.green.shade50
                                    : Colors.grey.shade100,
                                border: Border.all(
                                  color: _fileBytes != null
                                      ? Colors.green.shade300
                                      : Colors.grey.shade300,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _fileBytes != null
                                        ? Icons.check_circle_outline
                                        : Icons.upload_file,
                                    size: 40,
                                    color: _fileBytes != null
                                        ? Colors.green.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _fileName ??
                                        'Haz clic para seleccionar PDF, DOCX, PPTX...',
                                    style: TextStyle(
                                      color: _fileBytes != null
                                          ? Colors.green.shade700
                                          : Colors.grey.shade500,
                                      fontWeight: _fileBytes != null
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          if (provider.isLoading)
                            const LoadingIndicator()
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.cloud_upload_outlined),
                                label: const Text('Publicar Apunte',
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
