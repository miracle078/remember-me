import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:image/image.dart' as img;
import '../models/person.dart';
import '../utils/vector_utils.dart';
import 'database_service.dart';

class FaceService {
  final DatabaseService _dbService = DatabaseService();
  bool _isInitialized = false;

  // Similarity threshold for face recognition (0.7 = 70% similar)
  static const double similarityThreshold = 0.7;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // TODO: Initialize Cactus SDK Liquid model for face recognition
    // Example:
    // _liquidModel = LiquidModel();
    // await _liquidModel.loadModel('assets/models/liquid-vision.gguf');

    _isInitialized = true;
  }

  /// Extract face embedding from a photo
  Future<Uint8List> extractFaceEmbedding(File photoFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    // TODO: Use Cactus SDK to extract face embedding
    // For now, using a simplified version with image processing

    // Read and process image
    final bytes = await photoFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // For demo purposes, create a mock embedding
    // In production, this would use Cactus Liquid model
    return _generateMockEmbedding(image);
  }

  /// Generate a mock face embedding (for testing without Cactus models)
  /// Replace this with actual Cactus SDK call when models are available
  Uint8List _generateMockEmbedding(img.Image image) {
    // Create a simple embedding based on image characteristics
    // This is just for demo - replace with Cactus SDK!
    final embedding = List<double>.filled(128, 0.0);

    // Use image properties to create a unique embedding
    final random = Random(image.width * image.height);
    for (int i = 0; i < embedding.length; i++) {
      embedding[i] = random.nextDouble() * 2 - 1; // Range: -1 to 1
    }

    // Normalize the embedding
    final normalized = VectorUtils.normalize(embedding);

    return VectorUtils.doublesToBytes(normalized);
  }

  /// Recognize a person from a photo
  Future<Person?> recognizePerson(File photoFile) async {
    final faceEmbedding = await extractFaceEmbedding(photoFile);
    final people = await _dbService.getAllPeople();

    Person? bestMatch;
    double highestSimilarity = 0.0;

    for (final person in people) {
      if (person.faceEmbedding == null) continue;

      final similarity = VectorUtils.cosineSimilarity(
        faceEmbedding,
        person.faceEmbedding!,
      );

      if (similarity > highestSimilarity && similarity > similarityThreshold) {
        highestSimilarity = similarity;
        bestMatch = person;
      }
    }

    return bestMatch;
  }

  /// Add a new person with face embedding
  Future<Person> addPersonWithFace({
    required String id,
    required String name,
    required String relationship,
    required File photoFile,
    String? details,
  }) async {
    final faceEmbedding = await extractFaceEmbedding(photoFile);

    // Save photo to app directory
    final photoPath = await _savePhoto(photoFile, id);

    final person = Person(
      id: id,
      name: name,
      relationship: relationship,
      details: details,
      photoPath: photoPath,
      faceEmbedding: faceEmbedding,
    );

    await _dbService.insertPerson(person);
    return person;
  }

  /// Save photo to app storage
  Future<String> _savePhoto(File photoFile, String personId) async {
    // TODO: Save to proper app directory using path_provider
    // For now, return the original path
    return photoFile.path;
  }

  /// Get confidence score for a recognition (0-100%)
  double getConfidencePercentage(Uint8List embedding1, Uint8List embedding2) {
    final similarity = VectorUtils.cosineSimilarity(embedding1, embedding2);
    return ((similarity + 1) / 2 * 100).clamp(0, 100);
  }
}
