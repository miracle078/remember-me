# Mobile Agent Hackathon: Your Winning Strategy Guide
## Remember Me - AI Companion for People with Dementia

**Event**: Cactus Mobile Agent Hackathon
**Date**: November 28-29, 2025 (5 PM - 5 PM GMT)
**Goal**: Win the main prize (SF trip + YC lunch)

---

## 🎯 RECOMMENDED TRACK & PROBLEM

### Track Selection: **Track 1 - The Memory Master**

**Why This Track:**
- ✅ Clear technical challenge with measurable success criteria
- ✅ Less competition (most teams will go for Main Track)
- ✅ Natural fit for edge AI advantages (privacy-sensitive data)
- ✅ Easier to demonstrate value (memory = visible intelligence)
- ✅ **PERFECT POETIC FIT**: Using AI memory to help people who've lost theirs

### Recommended Problem: **AI Companion for People with Dementia**

**The Pitch:**
"55 million people with dementia face an impossible choice: lose independence to constant surveillance, or struggle alone without support. Remember Me uses AI memory to help people who've lost theirs—without stealing their dignity by sending intimate moments to the cloud."

**Why This Wins:**
1. **Perfect Track 1 Fit**: Memory Master helping memory loss (beautifully ironic)
2. **Privacy-Critical Use Case**: Vulnerable population, dignity is non-negotiable
3. **Real Market Pain**: $203B → $1.2 trillion by 2050 in dementia care costs
4. **Emotional Resonance**: Helping grandma recognize her grandchildren will make judges cry
5. **Demonstrable Intelligence**: Face recognition, memory search, conversational AI
6. **Edge Advantage**: Surveillance violates dignity - local processing is the ONLY ethical choice

---

## 💙 YOUR APP NAME: "Remember Me"

### The Perfect Name

**Why "Remember Me" is Brilliant:**
- 💙 **Emotionally Powerful**: Simple, universal, dignified
- 💙 **Clear Purpose**: Immediately understand what it does
- 💙 **Respects Patients**: Not cutesy, not condescending
- 💙 **Memorable**: Easy to say, ironic given the use case
- 💙 **Double Meaning**: "Remember me (the person)" + "Remember me (the app helps you remember)"

**Tagline**: "Your memories, your device, your dignity"

**Alternative Taglines**:
- "Memory helping memory"
- "Independence without surveillance"
- "Remember the people you love—privately"

### The Brilliant Metaphor

**The Poetic Irony:**
> "We're using AI memory to help people who've lost theirs. But we're doing it without stealing their dignity by sending intimate moments to the cloud."

**Why This Resonates:**
- Memory technology helping memory loss = beautiful symmetry
- Privacy for vulnerable population = ethical imperative
- Dignity over surveillance = choosing humanity over convenience

---

## 📱 EXACT IMPLEMENTATION PLAN

### Tech Stack Decision

**Framework**: **Flutter** (Recommended)
- Fast development
- Single codebase (iOS + Android)
- Good accessibility features for elderly
- Large, customizable UI components
- Cactus SDK supports it

**Models to Use**:
1. **Qwen3** (Primary) - For conversation, embeddings, text understanding
2. **Liquid** (Vision) - For face recognition and photo analysis
3. **Whisper** (Optional) - For voice-to-text transcription

**Storage**:
- **SQLite** for structured data (people, photos, voice notes, reminders)
- **Vector embeddings** for semantic search across memories
- **AES-256 encryption** for all local data

---

## 🏗️ APP FEATURES (Priority Ordered)

### Core Features (Must Have)
1. **Photo Memory Bank with Face Recognition**
   - Upload photos of family members
   - Local face recognition using Liquid vision model
   - Tag: "This is Sarah, your daughter, lives in Seattle"
   - When patient opens app, shows family photos with reminders
   - **Privacy**: Photos never leave device, face models trained locally

2. **"Who Is This?" Photo Identification**
   - Take photo of someone in real-time
   - App identifies: "This is Michael, your son, he's a teacher"
   - Pull context from past entries: "You talked about him yesterday"

3. **Voice Memory Journal**
   - Record daily moments, conversations
   - Local speech-to-text (using Qwen3 or Whisper)
   - Searchable transcripts
   - **Privacy**: Voice recordings stored encrypted locally

4. **Conversational AI Companion**
   - Chat with AI using Qwen3
   - Ask: "Who is Sarah?" → AI searches memories and responds with context
   - Remembers past conversations (vector embeddings)
   - Provides companionship without judgment

5. **Smart Reminders with Context**
   - Medication reminders
   - Appointment reminders
   - Routine-based: "You usually take walks at 3pm"
   - Local notifications only

### Secondary Features (Nice to Have)
6. **Memory Timeline**
   - Visual timeline of photos, voice notes, important events
   - "Today one year ago you went to the beach with Sarah"
   - Helps maintain sense of continuity

7. **Daily Routine Tracker**
   - Learn patterns: "You usually eat breakfast at 8am"
   - Gentle prompts if routine disrupted
   - Pattern recognition identifies behavior changes

8. **"Where Am I?" Safe Mode**
   - Shows patient their home address
   - Emergency contact information
   - GPS location (stored locally, only shared if SOS pressed)

### Polish Features (Final Hours)
9. **Caregiver Dashboard (Optional Sharing)**
   - Patient controls what caregiver sees
   - Health metrics, medication adherence
   - Behavior pattern alerts
   - **Key**: Requires patient consent, transparent about what's shared

10. **Emergency SOS Mode**
    - One-button SOS to designated caregiver
    - Sends location ONLY when button pressed
    - Shows patient their info: "Your name is [X], you live at [Y]"

---

## ⏱️ HOUR-BY-HOUR EXECUTION TIMELINE

### **HOURS 0-2: Setup & Foundation**
**5:00 PM - 7:00 PM**

#### Tasks:
- [ ] Create Flutter project (name: remember_me)
- [ ] Install Cactus SDK
- [ ] Download Qwen3 model (smallest variant: 0.5B or 1.5B)
- [ ] Download Liquid vision model for face recognition
- [ ] Test basic inference with both models
- [ ] Set up SQLite database with schema:
  ```sql
  CREATE TABLE people (
    id TEXT PRIMARY KEY,
    name TEXT,
    relationship TEXT,
    details TEXT,
    photo_path TEXT,
    face_embedding BLOB
  );

  CREATE TABLE memories (
    id TEXT PRIMARY KEY,
    type TEXT, -- 'photo', 'voice', 'text'
    content TEXT,
    date TEXT,
    embedding BLOB,
    related_people TEXT -- JSON array of person IDs
  );

  CREATE TABLE reminders (
    id TEXT PRIMARY KEY,
    title TEXT,
    time TEXT,
    frequency TEXT
  );
  ```

#### Deliverable:
- Flutter app runs on your phone
- Both models load successfully
- Database created with accessible schema

---

### **HOURS 3-8: Core Functionality**
**7:00 PM - 12:00 AM**

#### Tasks:

**Hour 3-4: Basic UI with Accessibility**
- [ ] Large, high-contrast home screen
- [ ] Big buttons: "My Family" | "Talk to Me" | "My Day"
- [ ] Photo grid view of family members
- [ ] Simple navigation (back button always visible)

**Hour 5-6: Face Recognition**
- [ ] Camera integration
- [ ] Take photo functionality
- [ ] Liquid model face detection
- [ ] Match face to stored person
- [ ] Display: "This is [Name], your [Relationship]"

**Hour 7-8: Memory Search Foundation**
- [ ] Embedding generation for text using Qwen3
- [ ] Store person details with embeddings
- [ ] Basic search: "Who is Sarah?"
- [ ] Display person info from database

#### Code Skeleton:
```dart
// Face recognition
Future<Person?> recognizeFace(File photoFile) async {
  final faceEmbedding = await LiquidModel.extractFaceEmbedding(photoFile);

  // Search database for matching face
  final people = await db.getAllPeople();
  Person? bestMatch;
  double bestSimilarity = 0.0;

  for (final person in people) {
    final similarity = cosineSimilarity(faceEmbedding, person.faceEmbedding);
    if (similarity > bestSimilarity && similarity > 0.7) {
      bestSimilarity = similarity;
      bestMatch = person;
    }
  }

  return bestMatch;
}

// Memory search
Future<String> askQuestion(String question) async {
  final queryEmbedding = await Qwen3.generateEmbedding(question);

  // Search all memories
  final memories = await db.getAllMemories();
  final relevantMemories = memories
      .map((m) => (memory: m, similarity: cosineSimilarity(queryEmbedding, m.embedding)))
      .where((m) => m.similarity > 0.5)
      .toList()
    ..sort((a, b) => b.similarity.compareTo(a.similarity));

  // Build context and generate response
  final context = buildContextFromMemories(relevantMemories.take(5).toList());
  final response = await Qwen3.generateResponse(question, context: context);

  return response;
}
```

#### Deliverable:
- Can take photo and recognize faces
- Can ask "Who is [person]?" and get answer
- Large, accessible UI works smoothly

---

### **HOURS 9-14: Intelligence Layer**
**12:00 AM - 5:00 AM**

#### Tasks:

**Hour 9-10: Voice Memory Journal**
- [ ] Record voice button
- [ ] Speech-to-text using Qwen3 or Whisper
- [ ] Store voice note with transcript
- [ ] Generate embedding for search
- [ ] Display voice notes in timeline

**Hour 11-12: Advanced AI Companion**
- [ ] Enhanced conversational AI
- [ ] Multi-turn conversations (remember context)
- [ ] Synthesize information from multiple sources
- [ ] Example: "Tell me about Sarah" → pulls from photos, voice notes, tags

**Hour 13-14: Smart Features**
- [ ] Medication reminders (time-based)
- [ ] Person tagging in photos (manual)
- [ ] Memory timeline view
- [ ] Pattern recognition: "You usually [do X] at [time]"

#### Deliverable:
- Voice recording and transcription works
- AI can synthesize information from multiple memories
- App demonstrates clear intelligence and usefulness
- Timeline view shows patient's day/week

---

### **HOURS 15-19: Polish & Accessibility**
**5:00 AM - 10:00 AM**

#### Sleep Break: 5:00 AM - 7:00 AM
**Sleep for 2 hours. You'll be sharper after rest.**

**Hour 15-16 (7-8 AM): UI Polish for Elderly Users**
- [ ] LARGE fonts (18pt minimum, 24pt for headers)
- [ ] High contrast colors (black on white or white on dark blue)
- [ ] Soft, calming color palette (blues, greens, warm neutrals)
- [ ] Icon + text labels (not just icons)
- [ ] Simple navigation (breadcrumbs, clear back button)
- [ ] Loading states with friendly messages

**Hour 17-18: Privacy & Safety Features**
- [ ] Privacy dashboard: "0 MB uploaded to cloud, 100% local"
- [ ] Emergency contact card: "If found, contact [Name] at [Number]"
- [ ] "Where Am I?" button showing home address
- [ ] Airplane mode test (ensure everything works offline)

**Hour 19: Unique Differentiator**
Pick ONE impressive feature:
- [ ] **Option A**: Caregiver sharing controls (patient decides what to share)
- [ ] **Option B**: Photo slideshow mode with gentle reminders
- [ ] **Option C**: "Important People" quick access (favorite 5 people)

---

### **HOURS 20-23: Testing & Submission Prep**
**10:00 AM - 1:00 PM**

**Hour 20: Build & Test**
- [ ] Generate release APK: `flutter build apk --release`
- [ ] Install on physical device and test all features
- [ ] Test with sample "elderly user" scenario
- [ ] Ensure large UI elements are touch-friendly
- [ ] Fix any critical bugs

**Hour 21: Demo Video Recording**
Record 2-minute demo following this script:

```
0:00-0:20 - Hook
"55 million people with dementia face an impossible choice:
lose independence to constant surveillance, or struggle alone.

Research shows surveillance technology 'infringes on independence
and dignity.' Care partners want safety, but patients feel stripped
of autonomy."

0:20-0:40 - Solution
"Remember Me is different. An AI companion that helps people with
dementia maintain independence—without surveillance.

Face recognition, voice memory, conversational AI—all 100%
on-device using the Cactus SDK. Zero cloud, zero surveillance."

0:40-1:20 - Demo
[Screen recording showing:]
- Take photo of person → instant recognition with context
- Ask "Who is Sarah?" → AI responds with rich details from memories
- Record voice note → searchable transcript
- Show memory timeline
- Privacy dashboard: "0 MB uploaded to cloud"
- Works in airplane mode

1:20-1:40 - Tech
"Powered by Qwen3 for conversation and memory, Liquid for
face recognition—all running locally.

The irony: We're using AI memory to help people who've lost theirs.
Memory Master helping memory loss."

1:40-2:00 - Impact
"Because 55 million people deserve independence, dignity, and
privacy—not surveillance disguised as care.

Remember Me: Your memories, your device, your dignity."
```

**Hour 22: Documentation**
Create README.md:
```markdown
# Remember Me 💙

## Your memories, your device, your dignity

## The Problem
55 million people worldwide live with dementia. Current technology
offers two terrible choices: lose independence to constant
surveillance, or struggle alone without support. Research shows
surveillance violates dignity and feels stigmatizing.

## The Solution
Remember Me is an AI companion for people with dementia that runs
100% on-device using the Cactus SDK. Face recognition helps identify
family members. Voice memory captures moments. AI conversation
provides companionship. All without sending intimate moments to
the cloud.

## The Beautiful Irony
We're using AI memory to help people who've lost theirs. Track 1
is "The Memory Master"—we're building memory technology to help
memory loss. That's not just technical innovation—it's poetic.

## Technical Implementation
- **Framework**: Flutter
- **AI Models**: Qwen3 (conversation, embeddings), Liquid (face recognition)
- **Memory Strategy**: Vector embeddings + SQLite
- **Privacy**: 100% on-device, AES-256 encryption, zero cloud
- **Performance**: Face recognition <1 sec, conversations <2 sec

## Key Features
- Photo memory bank with face recognition
- "Who is this?" real-time identification
- Voice memory journal
- Conversational AI companion
- Smart reminders
- Completely offline
- Privacy dashboard

## Why Edge AI is Essential
Dementia patients are vulnerable. Intimate moments (bathroom,
bedroom, daily struggles) cannot ethically be sent to cloud
surveillance systems. Dignity requires local processing.

## Market Opportunity
- 55M people with dementia globally
- $203B → $1.2T by 2050 in US care costs
- Current apps have poor privacy practices
- First privacy-first dementia care app

## Installation
[Link to APK / TestFlight]

## Demo
[Link to video]

Built for the Cactus Mobile Agent Hackathon 🚀
Track 1: The Memory Master

Remember Me: Memory helping memory.
```

**Hour 23: Final Checks**
- [ ] Test APK one more time
- [ ] Upload to Google Drive / TestFlight
- [ ] Prepare submission form responses
- [ ] Screenshot all features (especially face recognition working)
- [ ] Ensure demo emphasizes emotion + privacy + Track 1 fit

---

### **HOUR 24: SUBMIT EARLY**
**1:00 PM - 2:00 PM**

- [ ] Submit at 4:00 PM (1 hour before deadline)
- [ ] Double-check all links work
- [ ] Confirm submission received
- [ ] Breathe - you built something amazing

---

## 🎯 SUCCESS CRITERIA CHECKLIST

### Technical Requirements
- [ ] Uses Cactus SDK ✓
- [ ] Functional AI features running locally ✓
- [ ] Deliverable APK/IPA works ✓

### Track 1 Criteria (Memory Master)
- [ ] Demonstrates persistent memory across sessions
- [ ] Semantic search through stored knowledge
- [ ] Memory improves AI responses over time
- [ ] **Perfect fit**: AI memory helping people who've lost theirs

### Competitive Edge
- [ ] Solves a real problem (dementia care, $1.2T market)
- [ ] Privacy is core value prop (dignity for vulnerable population)
- [ ] Demonstrates measurable performance
- [ ] Polished, accessible UX (elderly-friendly)
- [ ] **Emotional resonance** (judges will cry)
- [ ] **Poetic perfection** (memory helping memory)

---

## 🚀 DIFFERENTIATION STRATEGIES

### Why Your App Wins

**1. Perfect Track 1 Fit**
- Track is "The Memory Master"
- You're using AI memory to help people who've lost theirs
- This is beautifully ironic and meaningful
- Memory helping memory = poetic perfection

**2. Emotional Impact Unlike Any Other**
- Helping grandma recognize her grandchildren
- Preserving dignity in vulnerable population
- Judges will cry (in a good way)
- This matters on a human level

**3. Privacy is an Ethical Imperative**
- Dementia patients are vulnerable
- Surveillance violates dignity
- Research-backed: "infringes on independence"
- Can't do this ethically with cloud AI

**4. Massive, Growing Market**
- $203B → $1.2T by 2050
- 55M people globally with dementia
- Elder care tech market exploding
- No privacy-first competitors

**5. Technical Excellence**
- Multi-modal: face recognition + voice + conversation
- Semantic search across all memories
- Pattern recognition for routines
- Accessible UI for elderly users

**6. Clear Startup Path**
- B2C: $15/month subscription
- B2B: Assisted living facilities
- Privacy is competitive moat
- Growing demographic (aging population)

---

## 🛠️ TECHNICAL DEEP DIVE

### Memory Architecture

```
USER INTERACTION
    ↓
[Take photo] OR [Record voice] OR [Ask question]
    ↓
LOCAL AI PROCESSING
    ↓
[Liquid: Face recognition] OR [Qwen3: Voice→Text] OR [Qwen3: Q&A]
    ↓
GENERATE EMBEDDINGS (Qwen3)
    ↓
STORE IN LOCAL SQLITE (AES-256 encrypted)
    ↓
[Photos + Face embeddings] | [Voice notes + text] | [Memories + context]

USER QUERIES
    ↓
"Who is Sarah?" → Convert query to embedding
    ↓
SEMANTIC SEARCH (cosine similarity across all memories)
    ↓
RETRIEVE: Photos of Sarah + Voice notes mentioning Sarah + Past conversations
    ↓
CONTEXT INJECTION to Qwen3
    ↓
PERSONALIZED RESPONSE:
"This is Sarah, your daughter. She lives in Seattle. You talked about
her yesterday when you mentioned her new job as a teacher. Here's a
photo of you two from last summer."
```

### Key Implementation Details

**Face Recognition Pipeline**:
```dart
Future<Person?> identifyPerson(File photo) async {
  // Extract face embedding using Liquid
  final faceEmbedding = await LiquidModel.detectAndEmbed(photo);

  // Search database
  final people = await db.getAllPeople();

  // Find best match using cosine similarity
  Person? bestMatch;
  double highestSimilarity = 0.0;

  for (final person in people) {
    final similarity = cosineSimilarity(
      faceEmbedding,
      person.storedFaceEmbedding
    );

    if (similarity > highestSimilarity && similarity > 0.7) {
      highestSimilarity = similarity;
      bestMatch = person;
    }
  }

  return bestMatch;
}
```

**Semantic Memory Search**:
```dart
Future<List<Memory>> searchMemories(String query) async {
  final queryEmbedding = await Qwen3.generateEmbedding(query);

  final allMemories = await db.getAllMemories();

  final results = allMemories.map((memory) {
    final similarity = cosineSimilarity(
      queryEmbedding,
      memory.embedding
    );
    return (memory: memory, score: similarity);
  }).where((r) => r.score > 0.5).toList();

  results.sort((a, b) => b.score.compareTo(a.score));

  return results.take(10).map((r) => r.memory).toList();
}
```

**Context Building**:
```dart
String buildContext(String question, List<Memory> relevantMemories) {
  final context = relevantMemories.map((m) {
    switch (m.type) {
      case 'photo':
        return 'Photo: ${m.content} (${m.date})';
      case 'voice':
        return 'Voice note: ${m.content} (${m.date})';
      case 'text':
        return 'Note: ${m.content} (${m.date})';
      default:
        return m.content;
    }
  }).join('\n');

  return '''
You are a compassionate AI assistant helping someone with memory challenges.
Based on this information about them:

$context

Answer their question: "$question"

Be warm, patient, and provide helpful context.
''';
}
```

---

## 🎬 DEMO SCRIPT & PITCH

### 30-Second Elevator Pitch
"Remember Me is an AI companion for people with dementia. Face recognition helps identify family. Voice memory captures moments. AI conversation provides companionship. All 100% on-device using Cactus SDK. The beautiful irony: we're using AI memory to help people who've lost theirs—without stealing their dignity by sending intimate moments to the cloud."

### Live Demo Flow (90 seconds)
1. **Show the problem** (10 sec)
   - Stats on screen: "55M people, $1.2T by 2050"
   - "Current tech: surveillance vs. abandonment"

2. **Face recognition** (25 sec)
   - Open app, show photo grid of "family"
   - Take new photo of someone
   - Instant recognition: "This is Sarah, your daughter, lives in Seattle"
   - Show rich details pulled from memories

3. **Memory search** (20 sec)
   - Ask: "Who is Sarah?"
   - AI synthesizes info from photos, voice notes, past conversations
   - Responds with context: "Your daughter, teacher, visited last week"

4. **Voice memory** (15 sec)
   - Record short note: "Had coffee with Michael today"
   - Show instant transcription
   - Searchable in memory timeline

5. **Privacy proof** (10 sec)
   - Privacy dashboard: "0 MB uploaded. 100% local."
   - Toggle airplane mode → everything still works

6. **The impact** (10 sec)
   - "Memory helping memory. Independence preserved. Dignity maintained."

### Judge Q&A Prep

**Expected Questions & Answers**:

Q: "Why did you choose dementia care?"
A: "The hackathon track is 'The Memory Master.' We're using AI memory to help people who've lost theirs. That's not just a technical solution—it's beautifully poetic. Plus, the $1.2 trillion market shows this is a massive real-world need."

Q: "Why not use cloud AI for better quality?"
A: "Dementia patients are extremely vulnerable. Research shows surveillance technology 'infringes on independence and dignity.' When care partners use monitoring, patients report feeling stigmatized. Cloud AI for this population isn't just worse—it's unethical. Dignity requires local processing."

Q: "How does this improve on existing dementia apps?"
A: "Current apps have terrible privacy practices. A systematic review found 'little focus on privacy and security' and 'gaps in data privacy standards.' We're the first privacy-first dementia care app. Face recognition, voice memory, AI companion—all without cloud surveillance."

Q: "What about caregivers who need to monitor safety?"
A: "Patient autonomy is key. The app has optional caregiver sharing, but the patient controls it. Research shows care partners want monitoring, but patients feel it infringes on independence. Our approach respects both needs—transparency about what's shared, patient consent required."

Q: "How scalable is this?"
A: "55 million people with dementia globally, growing to 139 million by 2050. Vector embeddings scale well—thousands of memories in under 100MB. For enterprise scale at assisted living facilities, we'd add cloud backup with end-to-end encryption, but processing stays local."

Q: "What's the business model?"
A: "B2C: Freemium model, $15/month premium. B2B: Sell to assisted living facilities at $50/month per facility for unlimited residents. Market is enormous and growing. Privacy is our competitive moat—once you breach trust with this vulnerable population, it's gone forever."

---

## ⚠️ RISK MITIGATION

### Common Failure Modes & Solutions

**Problem**: Face recognition not accurate enough
**Solution**: Tune similarity threshold (start at 0.7, adjust based on testing). Add manual confirmation: "Is this Sarah?" with Yes/No buttons.

**Problem**: Model too slow on device
**Solution**: Use Qwen3 0.5B (smallest variant). If still slow, simplify conversation model to basic Q&A rather than multi-turn dialogue.

**Problem**: Elderly users can't navigate UI
**Solution**: Extreme simplification. Big buttons only. Three main screens max. Voice commands as alternative to touch.

**Problem**: Out of time for voice features
**Solution**: Cut voice journal. Focus on face recognition + conversational AI. Those two alone are enough to win.

**Problem**: Can't demonstrate with real dementia patient
**Solution**: Use "simulation" approach. "Imagine you're having memory challenges..." Show how it helps with realistic scenarios.

**Problem**: Demo doesn't convey emotion
**Solution**: Start with statistics and personal story. "My grandmother had Alzheimer's. She didn't recognize me the last year of her life. This app could have helped." Make it personal.

---

## 📊 COMPETITIVE ANALYSIS

### Existing Solutions & Their Flaws

**Timeless** (cloud-based photo app)
- ❌ Sends photos to cloud
- ❌ Privacy concerns
- ❌ No AI companion
- ❌ Basic face tagging

**Greymatters** (life storybook)
- ❌ Cloud storage
- ❌ No real-time recognition
- ❌ Limited intelligence
- ❌ No conversation

**Amazon Echo / Google Home**
- ❌ Always-on surveillance
- ❌ Privacy nightmare
- ❌ No personalization for dementia
- ❌ Cloud-dependent

**ElliQ 3** ($20,000 robot)
- ❌ Extremely expensive
- ❌ Cloud-connected
- ❌ Not portable
- ❌ Surveillance-based

### Your Competitive Advantage

✅ **Only privacy-first dementia care app**
✅ **Multi-modal memory** (face + voice + text)
✅ **Real-time face recognition without cloud**
✅ **AI companion with context**
✅ **Affordable** (app vs. $20k robot)
✅ **Portable** (phone, not home device)
✅ **Patient-centered** (dignity first)
✅ **Research-backed** (addressing documented problems)

---

## 🏆 WINNING FACTORS MATRIX

| Factor | Remember Me | Generic Health App | Mental Health App |
|--------|-------------|-------------------|-------------------|
| Privacy Value Prop | ⭐⭐⭐⭐⭐ Ethical imperative | ⭐⭐⭐⭐ Important | ⭐⭐⭐⭐⭐ Critical |
| Track 1 Fit (Memory) | ⭐⭐⭐⭐⭐ Perfect poetry | ⭐⭐⭐⭐ Good fit | ⭐⭐⭐⭐ Good fit |
| Emotional Impact | ⭐⭐⭐⭐⭐ Judges will cry | ⭐⭐⭐⭐ Solid | ⭐⭐⭐⭐⭐ Very strong |
| Market Size | ⭐⭐⭐⭐⭐ $1.2T by 2050 | ⭐⭐⭐⭐ Large | ⭐⭐⭐⭐⭐ Huge |
| Edge AI Necessity | ⭐⭐⭐⭐⭐ Only ethical choice | ⭐⭐⭐⭐ Strong case | ⭐⭐⭐⭐⭐ Strong case |
| Competition | ⭐⭐⭐⭐⭐ None privacy-focused | ⭐⭐⭐ Some exist | ⭐⭐⭐⭐⭐ Few good options |
| Demo Impact | ⭐⭐⭐⭐⭐ Face recognition wow | ⭐⭐⭐⭐ Good | ⭐⭐⭐⭐ Solid |
| Startup Potential | ⭐⭐⭐⭐⭐ B2C + B2B | ⭐⭐⭐⭐ Good | ⭐⭐⭐⭐⭐ Excellent |
| **TOTAL** | **40/40** 🏆 | **30/40** | **37/40** |

---

## 📝 SUBMISSION CHECKLIST

### Required Materials
- [ ] Working APK or TestFlight link
- [ ] Demo video (max 2 minutes)
- [ ] GitHub repo with README
- [ ] Architecture diagram (optional but impressive)

### Submission Form Responses

**Project Name**: Remember Me

**Tagline**: Your memories, your device, your dignity

**Track**: Track 1 - Memory Master (also eligible for Main Track)

**Tech Stack**:
- Flutter
- Cactus SDK
- Qwen3 (conversation, embeddings)
- Liquid (face recognition)
- SQLite + Vector search
- AES-256 encryption

**Problem Statement**:
55 million people worldwide live with dementia, facing an impossible choice: lose independence to constant surveillance or struggle alone. Research shows surveillance technology "infringes on independence and dignity," yet current apps all use cloud-based monitoring. Dementia care costs will reach $1.2 trillion by 2050 in the US alone.

**Solution**:
Remember Me is an AI companion for people with dementia that runs 100% on-device using the Cactus SDK. Face recognition helps identify family members. Voice memory captures moments. AI conversation provides companionship and searches across all memories. All processing happens locally with AES-256 encryption, ensuring dignity is preserved.

**Key Innovation**:
The beautiful irony: we're using AI memory to help people who've lost theirs. Track 1 is "The Memory Master"—we're building memory technology to address memory loss. Semantic search across photos, voice notes, and conversations creates a comprehensive memory assistant. Face recognition using Liquid, conversation using Qwen3, all local. Memory helping memory.

**Edge AI Advantages**:
- Privacy: Dementia patients are vulnerable; surveillance violates dignity
- Offline: Works in hospitals, homes, anywhere—no connectivity required
- Latency: Real-time face recognition and instant memory search
- Ethics: Can't do this with cloud without compromising patient autonomy
- Cost: No cloud API fees, unlimited usage

**Why This Matters**:
Because 55 million people deserve independence, dignity, and privacy—not surveillance disguised as care. Current solutions force a trade-off between safety and autonomy. We prove you can have both through edge AI.

**Demo Link**: [Your video URL]

**Installation**: [APK link]

**Source Code**: [GitHub repo]

---

## 💪 MINDSET & EXECUTION TIPS

### Mental Framework

**Hour 0-8**: Builder Mode
- Get face recognition working ASAP
- Ugly UI is fine initially
- One feature at a time
- Test on device continuously

**Hour 9-16**: Intelligence Mode
- Add semantic search
- Multi-modal memory synthesis
- AI conversation depth
- Prove memory helping memory

**Hour 17-24**: Impact Mode
- Elderly-friendly UI polish
- Emotional demo preparation
- Privacy messaging clear
- Practice pitch until it makes YOU emotional

### Team Dynamics (if applicable)

**Solo**:
- Pros: Full control, clear vision
- Cons: Limited features
- Strategy: Nail face recognition + conversation

**Duo**:
- Person A: Flutter UI + face recognition
- Person B: Qwen3 integration + memory search
- Communication: Sync every 2 hours

**Trio**:
- Person A: Flutter UI + accessibility
- Person B: Face recognition (Liquid)
- Person C: Conversation AI (Qwen3) + demo prep
- Communication: Standup every 3 hours

---

## 🎯 SUCCESS MANTRAS

1. **"Memory helping memory"** - The perfect Track 1 pitch
2. **"Dignity over surveillance"** - The ethical imperative
3. **"Make them cry (good tears)"** - Emotional impact wins
4. **"Privacy isn't optional"** - It's the core value
5. **"One WOW moment"** - Face recognition demo

---

## 🚨 FINAL REMINDERS

### Day Before (Nov 27)
- [ ] Get 8 hours of sleep
- [ ] Charge all devices
- [ ] Download all models (Qwen3 + Liquid)
- [ ] Test camera permissions
- [ ] Prepare sample "family photos" for demo
- [ ] Have elderly-friendly UI mockup ready

### During Hackathon
- [ ] Stay hydrated
- [ ] Eat real food
- [ ] Take 5-minute breaks every hour
- [ ] Sleep 2-3 hours around hour 16-18
- [ ] Test on device constantly (not just emulator)
- [ ] Make sure face recognition works reliably

### Last Hour
- [ ] Submit at 4:00 PM (1 hour before deadline)
- [ ] Test all links work
- [ ] Demo video emphasizes emotion + privacy + Track 1
- [ ] Save all work to GitHub + Drive
- [ ] Relax—you built something that matters

---

## 🏁 EXPECTED OUTCOME

If you execute this plan:
- ✅ Working app with face recognition
- ✅ Demonstrates clear AI memory helping human memory
- ✅ Shows undeniable edge AI advantage (dignity)
- ✅ Judges will be emotionally moved
- ✅ Perfect Track 1 alignment
- ✅ **Top 3 finalist (minimum)**
- ✅ **Strong chance of winning**

The winner comes down to:
1. **Execution quality** (this guide ensures that)
2. **Emotional resonance** (dementia care has it)
3. **Track alignment** (memory helping memory = perfect)
4. **Technical innovation** (multi-modal local AI)
5. **A bit of luck** (you've maximized your odds)

**You're building something that genuinely helps vulnerable people while pushing the boundaries of edge AI. This is what winning looks like.** 💙

---

## 📞 EMERGENCY CONTACTS & RESOURCES

### If You Get Stuck

**Technical Issues**:
- Cactus SDK docs: [Check hackathon Discord/Slack]
- Flutter camera: Image_picker package
- Face recognition: Liquid model documentation
- Memory issues: Try smaller Qwen3 variant (0.5B)

**Design Inspiration**:
- Elderly-friendly apps: Look at large-button interfaces
- Accessibility: iOS accessibility guidelines
- Colors: Soft blues, greens, avoid red
- Icons: Material Symbols with text labels

**Demo Anxiety**:
- Remember: This app helps real people
- The emotion is genuine—lean into it
- Judges want to see passion, not perfection
- You're solving a $1.2T problem

---

## 📈 POST-HACKATHON

### If You Win
- Refine the prototype
- Test with actual early-stage dementia patients
- Partner with assisted living facilities
- Apply to YC (you'll have had lunch with a partner!)
- This could be a real company

### If You Don't Win
- You built something meaningful in 24 hours
- Open source it (portfolio piece)
- Dementia associations would love this
- The technology is valuable regardless
- Consider building it anyway—market need is real

---

**Last Updated**: November 26, 2025
**Version**: 3.0 - Remember Me Edition

**Build something that matters. Help people maintain dignity. Use AI memory to help those who've lost theirs. Win the hackathon.** 💙🏆

Remember: Memory helping memory. That's your winning story.
