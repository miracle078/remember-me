# Remember Me 💙 - Code Architecture Blueprint
## AI Companion for People with Dementia

## 💙 The App Strategy

**Why "Remember Me"?**
Using AI memory to help people who've lost theirs. Perfect for Track 1: "The Memory Master" → memory technology helping memory loss = poetic perfection.

**Branding Throughout Code:**
- App name: "Remember Me"
- Package name: `remember_me`
- Database name: `remember_me.db`
- Color scheme: Soft blues, greens, warm neutrals (elderly-friendly)
- UI: Large fonts (18pt min), high contrast, simple navigation

---

## 📁 Project Structure

```
remember_me/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── person.dart           # Person model with face embedding
│   │   ├── memory.dart           # Memory model (photo/voice/text)
│   │   └── reminder.dart         # Reminder model
│   ├── services/
│   │   ├── database_service.dart # SQLite operations
│   │   ├── ai_service.dart       # Qwen3 wrapper
│   │   ├── face_service.dart     # Liquid face recognition
│   │   └── memory_service.dart   # Semantic search
│   ├── screens/
│   │   ├── home_screen.dart      # Main photo grid
│   │   ├── family_screen.dart    # Family members list
│   │   ├── chat_screen.dart      # AI conversation
│   │   ├── add_person_screen.dart # Add family member
│   │   └── privacy_screen.dart   # Privacy dashboard
│   └── widgets/
│       ├── person_card.dart      # Person display widget
│       ├── large_button.dart     # Elderly-friendly button
│       └── photo_identifier.dart # Face recognition UI
├── assets/
│   └── models/
│       ├── qwen3-0.5b.gguf       # Conversation model
│       └── liquid-vision.gguf    # Face recognition model
└── pubspec.yaml
```

---

## 📦 pubspec.yaml Dependencies

```yaml
name: remember_me
description: AI companion for people with dementia - Memory helping memory

dependencies:
  flutter:
    sdk: flutter

  # Cactus SDK (check latest version from hackathon)
  cactus_sdk: ^1.0.0

  # Database
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  path: ^1.8.3

  # Camera & Photos
  image_picker: ^1.0.5
  camera: ^0.10.5
  photo_view: ^0.14.0

  # UI
  intl: ^0.18.1  # Date formatting
  flutter_svg: ^2.0.9

  # Utils
  uuid: ^4.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1

flutter:
  uses-material-design: true
  assets:
    - assets/models/
```

---

## 🏗️ Core Implementation

### 1. Model Classes

**lib/models/person.dart**
```dart
class Person {
  final String id;
  final String name;
  final String relationship; // "daughter", "son", "friend"
  final String? details; // "Lives in Seattle, teacher"
  final String? photoPath;
  final List<double>? faceEmbedding; // For face recognition

  Person({
    required this.id,
    required this.name,
    required this.relationship,
    this.details,
    this.photoPath,
    this.faceEmbedding,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'details': details,
      'photo_path': photoPath,
      'face_embedding': faceEmbedding != null
          ? _encodeEmbedding(faceEmbedding!)
          : null,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      relationship: map['relationship'],
      details: map['details'],
      photoPath: map['photo_path'],
      faceEmbedding: map['face_embedding'] != null
          ? _decodeEmbedding(map['face_embedding'])
          : null,
    );
  }

  // Encode embedding as bytes for SQLite
  static List<int> _encodeEmbedding(List<double> embedding) {
    final buffer = Float64List.fromList(embedding).buffer;
    return buffer.asUint8List();
  }

  static List<double> _decodeEmbedding(dynamic bytes) {
    final buffer = (bytes as List<int>).buffer.asByteData();
    return Float64List.view(buffer.buffer);
  }
}
```

**lib/models/memory.dart**
```dart
class Memory {
  final String id;
  final String type; // 'photo', 'voice', 'text'
  final String content;
  final DateTime date;
  final List<double>? embedding; // For semantic search
  final List<String> relatedPeople; // Person IDs

  Memory({
    required this.id,
    required this.type,
    required this.content,
    required this.date,
    this.embedding,
    this.relatedPeople = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'date': date.toIso8601String(),
      'embedding': embedding != null
          ? _encodeEmbedding(embedding!)
          : null,
      'related_people': jsonEncode(relatedPeople),
    };
  }

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'],
      type: map['type'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      embedding: map['embedding'] != null
          ? _decodeEmbedding(map['embedding'])
          : null,
      relatedPeople: List<String>.from(jsonDecode(map['related_people'] ?? '[]')),
    );
  }

  static List<int> _encodeEmbedding(List<double> embedding) {
    final buffer = Float64List.fromList(embedding).buffer;
    return buffer.asUint8List();
  }

  static List<double> _decodeEmbedding(dynamic bytes) {
    final buffer = (bytes as List<int>).buffer.asByteData();
    return Float64List.view(buffer.buffer);
  }
}
```

---

### 2. Database Service

**lib/services/database_service.dart**
```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/person.dart';
import '../models/memory.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'remember_me.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE people (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            relationship TEXT NOT NULL,
            details TEXT,
            photo_path TEXT,
            face_embedding BLOB
          )
        ''');

        await db.execute('''
          CREATE TABLE memories (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT NOT NULL,
            embedding BLOB,
            related_people TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE reminders (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            time TEXT NOT NULL,
            frequency TEXT
          )
        ''');
      },
    );
  }

  // CRUD for People
  Future<void> insertPerson(Person person) async {
    final db = await database;
    await db.insert(
      'people',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Person>> getAllPeople() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('people');
    return List.generate(maps.length, (i) => Person.fromMap(maps[i]));
  }

  Future<Person?> getPersonById(String id) async {
    final db = await database;
    final maps = await db.query(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Person.fromMap(maps.first);
  }

  Future<void> deletePerson(String id) async {
    final db = await database;
    await db.delete(
      'people',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD for Memories
  Future<void> insertMemory(Memory memory) async {
    final db = await database;
    await db.insert(
      'memories',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memory>> getAllMemories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memories',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Memory.fromMap(maps[i]));
  }

  Future<List<Memory>> getMemoriesByPerson(String personId) async {
    final db = await database;
    final allMemories = await getAllMemories();
    return allMemories
        .where((m) => m.relatedPeople.contains(personId))
        .toList();
  }
}
```

---

### 3. Face Recognition Service

**lib/services/face_service.dart**
```dart
import 'dart:io';
import 'package:cactus_sdk/cactus_sdk.dart';
import '../models/person.dart';
import 'database_service.dart';

class FaceService {
  late LiquidModel _liquidModel;
  final DatabaseService _dbService;
  bool _isInitialized = false;

  FaceService(this._dbService);

  Future<void> initialize() async {
    if (_isInitialized) return;

    _liquidModel = LiquidModel();
    await _liquidModel.loadModel('assets/models/liquid-vision.gguf');

    _isInitialized = true;
    print('Face Recognition Service initialized');
  }

  // Extract face embedding from photo
  Future<List<double>> extractFaceEmbedding(File photoFile) async {
    if (!_isInitialized) await initialize();

    try {
      final embedding = await _liquidModel.detectFaceAndEmbed(photoFile);
      return embedding;
    } catch (e) {
      print('Error extracting face embedding: $e');
      rethrow;
    }
  }

  // Recognize person from photo
  Future<Person?> recognizePerson(File photoFile) async {
    if (!_isInitialized) await initialize();

    // Extract face embedding from photo
    final faceEmbedding = await extractFaceEmbedding(photoFile);

    // Get all people from database
    final people = await _dbService.getAllPeople();

    // Find best match using cosine similarity
    Person? bestMatch;
    double highestSimilarity = 0.0;

    for (final person in people) {
      if (person.faceEmbedding == null) continue;

      final similarity = cosineSimilarity(faceEmbedding, person.faceEmbedding!);

      if (similarity > highestSimilarity && similarity > 0.7) {
        highestSimilarity = similarity;
        bestMatch = person;
      }
    }

    return bestMatch;
  }

  // Calculate cosine similarity between two vectors
  double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must be same length');
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0.0;

    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  void dispose() {
    _liquidModel.dispose();
    _isInitialized = false;
  }
}
```

---

### 4. AI Service (Qwen3 Wrapper)

**lib/services/ai_service.dart**
```dart
import 'package:cactus_sdk/cactus_sdk.dart';

class AIService {
  late Qwen3Model _qwen3;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _qwen3 = Qwen3Model();
    await _qwen3.loadModel('assets/models/qwen3-0.5b.gguf');

    _isInitialized = true;
    print('AI Service initialized');
  }

  // Generate text embedding for semantic search
  Future<List<double>> generateEmbedding(String text) async {
    if (!_isInitialized) await initialize();

    try {
      final embedding = await _qwen3.embed(text);
      return embedding;
    } catch (e) {
      print('Error generating embedding: $e');
      rethrow;
    }
  }

  // Generate conversational response
  Future<String> generateResponse(String prompt, {String? context}) async {
    if (!_isInitialized) await initialize();

    final systemPrompt = '''
You are a compassionate AI assistant helping someone with memory challenges.
Be warm, patient, and provide helpful context from their memories.
Keep responses brief and clear (2-3 sentences max).
''';

    final fullPrompt = context != null
        ? '$systemPrompt\n\nContext: $context\n\nUser: $prompt\nAssistant:'
        : '$systemPrompt\n\nUser: $prompt\nAssistant:';

    try {
      final result = await _qwen3.generate(
        prompt: fullPrompt,
        maxTokens: 150,
        temperature: 0.7,
      );
      return result.text.trim();
    } catch (e) {
      print('Error generating response: $e');
      return 'I apologize, but I had trouble understanding that. Could you try asking differently?';
    }
  }

  void dispose() {
    _qwen3.dispose();
    _isInitialized = false;
  }
}
```

---

### 5. Memory Service (Semantic Search)

**lib/services/memory_service.dart**
```dart
import '../models/memory.dart';
import '../models/person.dart';
import 'ai_service.dart';
import 'database_service.dart';

class MemoryService {
  final AIService _aiService;
  final DatabaseService _dbService;

  MemoryService(this._aiService, this._dbService);

  // Create memory with embedding
  Future<Memory> createMemory({
    required String type,
    required String content,
    List<String> relatedPeople = const [],
  }) async {
    // Generate embedding
    final embedding = await _aiService.generateEmbedding(content);

    final memory = Memory(
      id: Uuid().v4(),
      type: type,
      content: content,
      date: DateTime.now(),
      embedding: embedding,
      relatedPeople: relatedPeople,
    );

    await _dbService.insertMemory(memory);
    return memory;
  }

  // Search memories using semantic similarity
  Future<List<Memory>> searchMemories(
    String query,
    {int limit = 5, double threshold = 0.5}
  ) async {
    // Generate embedding for search query
    final queryEmbedding = await _aiService.generateEmbedding(query);

    // Get all memories with embeddings
    final allMemories = await _dbService.getAllMemories();
    final memoriesWithEmbeddings = allMemories
        .where((m) => m.embedding != null)
        .toList();

    // Calculate similarity scores
    final results = memoriesWithEmbeddings.map((memory) {
      final similarity = cosineSimilarity(
        queryEmbedding,
        memory.embedding!
      );
      return (memory: memory, similarity: similarity);
    }).toList();

    // Sort by similarity and filter by threshold
    results.sort((a, b) => b.similarity.compareTo(a.similarity));

    return results
        .where((r) => r.similarity >= threshold)
        .take(limit)
        .map((r) => r.memory)
        .toList();
  }

  // Ask question and get AI response with context
  Future<String> askQuestion(String question) async {
    // Search for relevant memories
    final relevantMemories = await searchMemories(question, limit: 5);

    // Build context from memories
    final context = buildContext(relevantMemories);

    // Generate AI response
    final response = await _aiService.generateResponse(question, context: context);

    return response;
  }

  // Build context string from memories
  String buildContext(List<Memory> memories) {
    if (memories.isEmpty) {
      return 'No relevant memories found.';
    }

    final context = memories.map((memory) {
      final date = memory.date.toString().split(' ')[0];
      return '$date: ${memory.content}';
    }).join('\n');

    return 'Relevant memories:\n$context';
  }

  // Calculate cosine similarity
  double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must be same length');
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0.0;

    return dotProduct / (sqrt(normA) * sqrt(normB));
  }
}
```

---

## 🎨 UI Components for Elderly Users

### Large Button Widget

**lib/widgets/large_button.dart**
```dart
class LargeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const LargeButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```

---

## 🚀 Build & Deploy Commands

### Development
```bash
# Run in debug mode
flutter run

# Hot reload
r

# Hot restart
R
```

### Release Build
```bash
# Android APK
flutter build apk --release

# Find APK at:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## ⚡ Performance Optimizations

### 1. Lazy Load Models
```dart
// Load models only when first needed
Future<void> _ensureModelsLoaded() async {
  if (!_modelsLoaded) {
    await _aiService.initialize();
    await _faceService.initialize();
    _modelsLoaded = true;
  }
}
```

### 2. Cache Face Recognition Results
```dart
class FaceService {
  final Map<String, Person?> _recognitionCache = {};

  Future<Person?> recognizePerson(File photoFile) async {
    final cacheKey = photoFile.path;
    if (_recognitionCache.containsKey(cacheKey)) {
      return _recognitionCache[cacheKey];
    }

    final result = await _performRecognition(photoFile);
    _recognitionCache[cacheKey] = result;
    return result;
  }
}
```

### 3. Limit Memory Search
```dart
// Only search recent memories for faster results
Future<List<Memory>> searchRecentMemories(String query) async {
  final recentMemories = await _dbService.getRecentMemories(limit: 100);
  // Perform search only on these 100 most recent
}
```

---

## 🎯 Testing Checklist

### Before Demo
- [ ] Fresh install works
- [ ] Can add person with photo
- [ ] Face recognition works reliably
- [ ] Search returns relevant memories
- [ ] AI conversation responds correctly
- [ ] Works in airplane mode
- [ ] Large UI elements are touch-friendly
- [ ] App launches quickly (<2 sec)
- [ ] Face recognition <1 sec

### Edge Cases
- [ ] Empty database (helpful message shown)
- [ ] No face detected in photo
- [ ] Multiple faces in photo
- [ ] Unknown person (no match)
- [ ] Long text in memory (truncates properly)

---

## 📱 Final APK Checklist

Before submission:
1. [ ] Change app name in `AndroidManifest.xml` to "Remember Me"
2. [ ] Add elderly-friendly app icon
3. [ ] Remove debug prints
4. [ ] Test face recognition threshold (0.7)
5. [ ] Ensure large fonts throughout (18pt min)
6. [ ] Test on multiple devices if possible
7. [ ] Generate release APK
8. [ ] Install and test fresh install
9. [ ] Upload to Drive with public link
10. [ ] Verify works offline (airplane mode)

---

## 💙 Accessibility Checklist

Final touches for elderly users:
- [ ] All fonts 18pt minimum
- [ ] High contrast colors everywhere
- [ ] Icons always have text labels
- [ ] Buttons are large (minimum 64px height)
- [ ] Simple navigation (max 3 taps to any feature)
- [ ] Loading states with friendly messages
- [ ] Error messages are clear and helpful
- [ ] No complex gestures (simple taps only)

---

**This architecture gives you a production-ready foundation for dementia care with dignity.

Remember: Memory helping memory. Build something that matters. Win the hackathon. 💙🏆**
