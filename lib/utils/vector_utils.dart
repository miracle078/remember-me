import 'dart:typed_data';
import 'dart:math';

class VectorUtils {
  /// Calculate cosine similarity between two embeddings
  /// Returns value between -1 and 1, where 1 means identical
  static double cosineSimilarity(Uint8List embedding1, Uint8List embedding2) {
    // Convert bytes to doubles
    final vec1 = _bytesToDoubles(embedding1);
    final vec2 = _bytesToDoubles(embedding2);

    if (vec1.length != vec2.length) {
      throw ArgumentError('Embeddings must have the same length');
    }

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < vec1.length; i++) {
      dotProduct += vec1[i] * vec2[i];
      norm1 += vec1[i] * vec1[i];
      norm2 += vec2[i] * vec2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) {
      return 0.0;
    }

    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }

  /// Convert byte array to list of doubles
  static List<double> _bytesToDoubles(Uint8List bytes) {
    final buffer = bytes.buffer;
    final float32List = Float32List.view(buffer);
    return float32List.toList();
  }

  /// Convert list of doubles to byte array
  static Uint8List doublesToBytes(List<double> doubles) {
    final float32List = Float32List.fromList(doubles);
    return float32List.buffer.asUint8List();
  }

  /// Normalize a vector to unit length
  static List<double> normalize(List<double> vector) {
    double norm = 0.0;
    for (final value in vector) {
      norm += value * value;
    }
    norm = sqrt(norm);

    if (norm == 0.0) {
      return vector;
    }

    return vector.map((value) => value / norm).toList();
  }
}
