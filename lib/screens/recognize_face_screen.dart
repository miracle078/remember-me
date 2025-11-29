import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/face_service.dart';
import '../models/person.dart';

class RecognizeFaceScreen extends StatefulWidget {
  const RecognizeFaceScreen({super.key});

  @override
  State<RecognizeFaceScreen> createState() => _RecognizeFaceScreenState();
}

class _RecognizeFaceScreenState extends State<RecognizeFaceScreen> {
  final FaceService _faceService = FaceService();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  Person? _recognizedPerson;
  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
        _recognizedPerson = null;
        _errorMessage = null;
      });
      _recognizeFace();
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
        _recognizedPerson = null;
        _errorMessage = null;
      });
      _recognizeFace();
    }
  }

  Future<void> _recognizeFace() async {
    if (_imageFile == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final person = await _faceService.recognizePerson(_imageFile!);

      setState(() {
        _recognizedPerson = person;
        _isProcessing = false;
        if (person == null) {
          _errorMessage = "I don't recognize this person. Would you like to add them?";
        }
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Error recognizing face: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Who Is This?', style: TextStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo display area
              Expanded(
                child: GestureDetector(
                  onTap: _showPhotoOptions,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 80, color: Colors.grey.shade600),
                              const SizedBox(height: 20),
                              Text(
                                'Tap to take or choose a photo',
                                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                              if (_isProcessing)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Result card
              if (_recognizedPerson != null || _errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _recognizedPerson != null
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _recognizedPerson != null
                          ? Colors.green.shade200
                          : Colors.orange.shade200,
                      width: 2,
                    ),
                  ),
                  child: _recognizedPerson != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                                const SizedBox(width: 12),
                                const Text(
                                  'I recognize them!',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Name: ${_recognizedPerson!.name}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Relationship: ${_recognizedPerson!.relationship}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (_recognizedPerson!.details != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Notes: ${_recognizedPerson!.details}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ],
                        )
                      : Row(
                          children: [
                            Icon(Icons.info, color: Colors.orange.shade700, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                ),

              const SizedBox(height: 20),

              // Action buttons
              SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _showPhotoOptions,
                  icon: const Icon(Icons.camera_alt, size: 28),
                  label: const Text(
                    'Try Another Photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, size: 30),
              title: const Text('Take Photo', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, size: 30),
              title: const Text('Choose from Gallery', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }
}
