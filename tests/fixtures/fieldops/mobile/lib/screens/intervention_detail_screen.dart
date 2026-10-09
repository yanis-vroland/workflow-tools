import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/intervention.dart';
import '../services/api_client.dart';

/// Détail d'une intervention : démarrage, photos et clôture.
class InterventionDetailScreen extends StatefulWidget {
  const InterventionDetailScreen({super.key, required this.intervention, required this.api});

  final Intervention intervention;
  final ApiClient api;

  @override
  State<InterventionDetailScreen> createState() => _InterventionDetailScreenState();
}

class _InterventionDetailScreenState extends State<InterventionDetailScreen> {
  final _picker = ImagePicker();
  final _reportController = TextEditingController();
  final List<XFile> _photos = [];

  Future<void> _start() async {
    // Position relevée au démarrage pour justifier la présence sur site
    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition();
    await widget.api.updateStatus(widget.intervention.id, 'in_progress');
  }

  Future<void> _takePhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _photos.add(photo));
    }
  }

  Future<void> _pickFromGallery() async {
    final photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() => _photos.add(photo));
    }
  }

  Future<void> _close() async {
    // FIXME: les photos ne sont pas encore envoyées à l'API
    await widget.api.updateStatus(widget.intervention.id, 'done', report: _reportController.text);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.intervention.address)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(onPressed: _start, child: const Text('Démarrer')),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.photo_camera), onPressed: _takePhoto),
              IconButton(icon: const Icon(Icons.photo_library), onPressed: _pickFromGallery),
              Text('${_photos.length} photo(s)'),
            ],
          ),
          TextField(controller: _reportController, maxLines: 5, decoration: const InputDecoration(labelText: 'Compte rendu')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _close, child: const Text('Clôturer')),
        ],
      ),
    );
  }
}
