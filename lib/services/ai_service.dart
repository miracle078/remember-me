import 'dart:typed_data';
import '../models/person.dart';
import '../models/memory.dart';
import '../utils/vector_utils.dart';
import 'database_service.dart';

class AIService {
  final DatabaseService _dbService = DatabaseService();
  bool _isInitialized = false;

  // Conversation history
  final List<Map<String, String>> _conversationHistory = [];

  Future<void> initialize() async {
    if (_isInitialized) return;

    // TODO: Initialize Cactus SDK Qwen3 model
    // Example:
    // _qwenModel = QwenModel();
    // await _qwenModel.loadModel('assets/models/qwen3-1.5b.gguf');

    _isInitialized = true;
  }

  /// Generate a text embedding for semantic search
  Future<Uint8List> generateTextEmbedding(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    // TODO: Use Cactus SDK to generate embedding from text
    // For now, using a mock implementation

    return _generateMockTextEmbedding(text);
  }

  /// Generate mock text embedding (replace with Cactus SDK)
  Uint8List _generateMockTextEmbedding(String text) {
    // Create a simple embedding based on text characteristics
    final embedding = List<double>.filled(128, 0.0);

    // Use text properties for a simple hash-based embedding
    for (int i = 0; i < text.length && i < embedding.length; i++) {
      embedding[i] = (text.codeUnitAt(i) % 100) / 100.0;
    }

    final normalized = VectorUtils.normalize(embedding);
    return VectorUtils.doublesToBytes(normalized);
  }

  /// Chat with the AI companion
  Future<String> chat(String userMessage, {Person? contextPerson}) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Add user message to history
    _conversationHistory.add({'role': 'user', 'content': userMessage});

    // Build context from database
    final context = await _buildContext(contextPerson);

    // TODO: Use Cactus SDK Qwen3 for actual generation
    // For now, using rule-based responses

    final response = _generateMockResponse(userMessage, context, contextPerson);

    // Add AI response to history
    _conversationHistory.add({'role': 'assistant', 'content': response});

    return response;
  }

  /// Build context for the AI from database
  Future<String> _buildContext(Person? person) async {
    final people = await _dbService.getAllPeople();
    final memories = await _dbService.getAllMemories();

    String context = 'You are a helpful AI companion for someone with memory difficulties.\n';
    context += 'Be patient, kind, and supportive.\n\n';

    if (people.isNotEmpty) {
      context += 'People they know:\n';
      for (final p in people.take(5)) {
        context += '- ${p.name} (${p.relationship})\n';
      }
    }

    if (person != null) {
      context += '\nCurrent person: ${person.name} (${person.relationship})\n';
      if (person.details != null) {
        context += 'Details: ${person.details}\n';
      }
    }

    return context;
  }

  /// Generate a mock response (replace with Cactus SDK)
  String _generateMockResponse(String userMessage, String context, Person? person) {
    final lowerMessage = userMessage.toLowerCase();

    // Simple pattern matching for demo
    if (lowerMessage.contains('who') && lowerMessage.contains('this')) {
      if (person != null) {
        return 'This is ${person.name}, your ${person.relationship}. ${person.details ?? ""}';
      }
      return "I can help you identify people. Please show me a photo!";
    }

    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return "Hello! I'm here to help you remember. Would you like to look at some photos or talk about someone?";
    }

    if (lowerMessage.contains('help')) {
      return "I can help you:\n• Recognize people from photos\n• Remember details about your loved ones\n• Look at past memories\n• Have a conversation";
    }

    if (lowerMessage.contains('remember') || lowerMessage.contains('memory')) {
      return "Memories are precious. Would you like to add a new memory, or look at past ones?";
    }

    // Default response
    return "I'm here to help. You can ask me about people, memories, or just chat!";
  }

  /// Search memories by semantic similarity
  Future<List<Memory>> searchMemories(String query) async {
    if (!_isInitialized) {
      await initialize();
    }

    final queryEmbedding = await generateTextEmbedding(query);
    final memories = await _dbService.getAllMemories();

    // Calculate similarities and sort
    final memoriesWithScores = memories.where((m) => m.embedding != null).map((memory) {
      final similarity = VectorUtils.cosineSimilarity(queryEmbedding, memory.embedding!);
      return {'memory': memory, 'score': similarity};
    }).toList();

    memoriesWithScores.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

    return memoriesWithScores.take(10).map((item) => item['memory'] as Memory).toList();
  }

  /// Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
  }

  /// Get conversation history
  List<Map<String, String>> get conversationHistory => List.unmodifiable(_conversationHistory);
}
