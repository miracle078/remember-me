# AI Models for Remember Me

This folder should contain the Cactus SDK-compatible AI models for the Remember Me app.

## Required Models

### 1. Qwen3 Model (Conversational AI)
- **Model**: Qwen3-1.5B or Qwen3-3B (GGUF format)
- **Purpose**: Conversational AI companion, text generation, and embeddings
- **Download**: Check Cactus SDK documentation or Hugging Face
- **File name**: `qwen3-1.5b.gguf` or `qwen3-3b.gguf`

### 2. Liquid Vision Model (Face Recognition)
- **Model**: Liquid vision model (GGUF format)
- **Purpose**: Face detection and face embedding extraction
- **Download**: Check Cactus SDK documentation
- **File name**: `liquid-vision.gguf`

## How to Add Models

1. Download the models from the Cactus SDK documentation or official sources
2. Place the `.gguf` files in this directory (`assets/models/`)
3. Update the model loading code in the services if filenames differ:
   - `lib/services/face_service.dart` - Face recognition model
   - `lib/services/ai_service.dart` - Qwen3 conversation model

## Model Sizes

- Qwen3-1.5B: ~1-2GB
- Qwen3-3B: ~2-3GB
- Liquid Vision: ~200-500MB

Total: ~3-6GB depending on which models you choose

## Important Notes

- The app currently uses mock implementations for face recognition and AI chat
- These work for testing the UI and database functionality
- To get full functionality, you MUST add the actual Cactus SDK models
- Make sure your device has sufficient storage space
- Models are loaded once at app startup and kept in memory

## Testing Without Models

For hackathon demo purposes, the app will work without real models:
- Face recognition uses a mock embedding system
- AI chat uses rule-based responses
- All other features (database, UI, photos) work normally

## Integration Steps

Once you have the models:

1. **For Face Recognition** (in `face_service.dart`):
```dart
// Replace the mock implementation with:
import 'package:cactus/cactus.dart';

late LiquidModel _liquidModel;

Future<void> initialize() async {
  _liquidModel = LiquidModel();
  await _liquidModel.loadModel('assets/models/liquid-vision.gguf');
  _isInitialized = true;
}

Future<Uint8List> extractFaceEmbedding(File photoFile) async {
  return await _liquidModel.extractFaceEmbedding(photoFile);
}
```

2. **For AI Chat** (in `ai_service.dart`):
```dart
// Replace the mock implementation with:
import 'package:cactus/cactus.dart';

late QwenModel _qwenModel;

Future<void> initialize() async {
  _qwenModel = QwenModel();
  await _qwenModel.loadModel('assets/models/qwen3-1.5b.gguf');
  _isInitialized = true;
}

Future<String> chat(String userMessage) async {
  return await _qwenModel.generate(userMessage, context: _buildContext());
}
```

## Resources

- Cactus SDK Documentation: https://cactuscompute.com/docs
- Hackathon Resources: Check the event page for model downloads
- Hugging Face GGUF Models: https://huggingface.co/models?library=gguf

## For Hackathon Judges

This app demonstrates:
- ✅ Complete on-device architecture
- ✅ Face recognition flow (UI + mock backend)
- ✅ AI conversation flow (UI + mock backend)
- ✅ SQLite database with embeddings
- ✅ Privacy-first design (no network calls)
- ✅ Accessibility for elderly users

The mock implementations allow testing without 3-6GB of model downloads during setup.
Real Cactus SDK integration is a straightforward swap once models are available.
