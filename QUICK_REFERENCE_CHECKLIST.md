# HACKATHON QUICK REFERENCE - PRINT THIS

## 🎯 YOUR APP: Remember Me 💙
**Track**: Memory Master (Track 1)
**Tagline**: "Your memories, your device, your dignity"
**The Magic**: Using AI memory to help people who've lost theirs

---

## 💙 THE NAME & PITCH

**Why "Remember Me"?**
- Emotional, simple, dignified
- Clear purpose (memory assistance for dementia)
- Beautiful irony: AI memory helping human memory loss
- Perfect for Track 1: "The Memory Master"

**The Poetic Pitch**:
"We're using AI memory to help people who've lost theirs—without stealing their dignity by sending intimate moments to the cloud."

---

## ⏱️ HOUR-BY-HOUR CHECKLIST

### **HOURS 0-2**: Setup ☑️
- [ ] Create Flutter project (remember_me)
- [ ] Install Cactus SDK
- [ ] Load Qwen3 model (0.5B or 1.5B) + Liquid vision model
- [ ] Test inference works
- [ ] Create SQLite database (people, memories, reminders)

### **HOURS 3-8**: Core Features ☑️
- [ ] Large, accessible UI (big buttons, high contrast)
- [ ] Photo grid of family members
- [ ] Camera integration
- [ ] Face recognition using Liquid model
- [ ] Display: "This is [Name], your [Relationship]"
- [ ] Basic memory search: "Who is Sarah?"
- [ ] Test: Face recognition → identification → show details

**DELIVERABLE**: Face recognition works, UI is elderly-friendly

---

### **HOURS 9-14**: Intelligence ☑️
- [ ] Voice recording button
- [ ] Speech-to-text (Qwen3 or Whisper)
- [ ] Store voice notes with embeddings
- [ ] Enhanced conversational AI
- [ ] Multi-modal search (photos + voice + text)
- [ ] Memory timeline view
- [ ] Medication reminders
- [ ] Test: Ask "Who is Sarah?" → rich context from all sources

**DELIVERABLE**: AI synthesizes info from multiple memories

---

### **HOURS 15-19**: Polish & Accessibility ☑️
**Sleep 5-7 AM** ⏰

- [ ] LARGE fonts (18pt min, 24pt headers)
- [ ] High contrast colors (elderly-friendly)
- [ ] Soft blues/greens color palette
- [ ] Icon + text labels everywhere
- [ ] Privacy dashboard: "0 MB uploaded to cloud"
- [ ] "Where Am I?" emergency card
- [ ] Airplane mode test (prove offline)
- [ ] Add ONE wow feature (caregiver controls/slideshow/quick access)

**DELIVERABLE**: Polished, accessible, emotional app

---

### **HOURS 20-23**: Ship It ☑️
- [ ] Build APK: `flutter build apk --release`
- [ ] Test on real device
- [ ] Record 2-min demo video (start with emotion!)
- [ ] Write README.md with research citations
- [ ] Upload APK to Drive/TestFlight
- [ ] Screenshots showing face recognition working

**DELIVERABLE**: Submittable package that makes judges cry

---

### **HOUR 24**: Submit ☑️
- [ ] **Submit at 4:00 PM** (1 hour early!)
- [ ] Test all links work
- [ ] Confirm receipt

---

## 🎬 DEMO SCRIPT (Memorize This)

**0-20 sec**: "55 million people with dementia face an impossible choice: lose independence to surveillance, or struggle alone. Research shows surveillance 'infringes on independence and dignity.'"

**20-40 sec**: "Remember Me is different. Face recognition, voice memory, AI conversation—all 100% on-device using Cactus SDK. Zero surveillance."

**40-80 sec**: [LIVE DEMO]
- Take photo → instant face recognition with context
- Ask "Who is Sarah?" → AI responds with rich details
- Record voice note → searchable transcript
- Show memory timeline
- Privacy dashboard: "0 MB uploaded"
- Works in airplane mode!

**80-100 sec**: "Powered by Qwen3 and Liquid, all local. The irony: we're using AI memory to help people who've lost theirs. Memory Master helping memory loss."

**100-120 sec**: "Because 55 million people deserve independence, dignity, and privacy—not surveillance disguised as care. Remember Me: Your memories, your device, your dignity."

---

## 💻 CODE SNIPPETS

### Database Schema
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
  related_people TEXT
);
```

### Face Recognition
```dart
Future<Person?> recognizeFace(File photo) async {
  final faceEmbedding = await LiquidModel.extractFaceEmbedding(photo);

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
```

### Memory Search
```dart
Future<String> askQuestion(String question) async {
  final queryEmbedding = await Qwen3.generateEmbedding(question);

  final memories = await db.getAllMemories();
  final relevantMemories = memories
      .map((m) => (memory: m, similarity: cosineSimilarity(queryEmbedding, m.embedding)))
      .where((m) => m.similarity > 0.5)
      .toList()
    ..sort((a, b) => b.similarity.compareTo(a.similarity));

  final context = buildContextFromMemories(relevantMemories.take(5).toList());
  final response = await Qwen3.generateResponse(question, context: context);

  return response;
}
```

---

## 🎯 JUDGE Q&A PREP

**Q: Why dementia care?**
A: "Track 1 is 'Memory Master.' We're using AI memory to help people who've lost theirs. That's not just technical—it's beautifully poetic. Plus, $1.2 trillion market by 2050 shows massive real-world need."

**Q: Why not cloud AI?**
A: "Dementia patients are extremely vulnerable. Research shows surveillance 'infringes on independence and dignity.' Cloud AI for this population isn't just worse—it's unethical. Dignity requires local processing."

**Q: How does this improve existing apps?**
A: "Current apps have terrible privacy. Systematic reviews found 'little focus on privacy and security.' We're the first privacy-first dementia care app. Face recognition, voice memory, AI companion—all without cloud surveillance."

**Q: What about caregivers monitoring?**
A: "Patient autonomy is key. Optional caregiver sharing, but patient controls it. Research shows care partners want monitoring, patients feel it infringes on independence. Our approach respects both."

**Q: Business model?**
A: "B2C: $15/month. B2B: Assisted living facilities $50/month per facility. Market huge and growing. Privacy is competitive moat."

---

## ⚠️ EMERGENCY FIXES

**Face recognition not accurate?**
→ Tune threshold (start 0.7), add manual confirmation "Is this Sarah?"

**Model too slow?**
→ Use Qwen3 0.5B, simplify conversation to Q&A only

**Elderly users can't navigate?**
→ Extreme simplification, big buttons only, 3 screens max, voice commands

**Out of time?**
→ Cut voice journal, focus face recognition + conversation

**Demo doesn't convey emotion?**
→ Start with personal story: "My grandmother had Alzheimer's..."

---

## 🏆 WINNING FACTORS

✅ Perfect Track 1 fit (memory helping memory)
✅ Emotional impact (judges will cry)
✅ Privacy-critical (vulnerable population)
✅ Massive market ($1.2T by 2050)
✅ Can't replicate with cloud (ethical imperative)
✅ Research-backed (30+ citations)
✅ **Poetic perfection** ("Memory Master" helping memory loss)

---

## ⏰ CRITICAL DEADLINES

**5:00 PM (Hour 0)**: Must have models loaded
**12:00 AM (Hour 7)**: Must have face recognition working
**7:00 AM (Hour 14)**: Sleep 2 hours
**4:00 PM (Hour 23)**: SUBMIT (1hr early)

---

## 🚨 DO NOT FORGET

- [ ] Charge phone + laptop
- [ ] Test builds at Hour 0
- [ ] Test face recognition extensively
- [ ] Prepare sample "family photos" for demo
- [ ] Save to GitHub continuously
- [ ] Sleep 2-3 hours (you'll code better)
- [ ] Submit EARLY (last-minute fails)
- [ ] Demo in airplane mode (prove offline)
- [ ] **Make it emotional** - this helps real people

---

## 💪 MANTRAS

1. **"Memory helping memory"** - Your Track 1 pitch
2. **"Dignity over surveillance"** - The ethical core
3. **"Make them cry (good tears)"** - Emotion wins
4. **"Privacy isn't optional"** - For vulnerable population
5. **"Face recognition WOW"** - The demo moment

---

## 📱 APP FEATURES (Priority)

### Must Have:
1. Photo memory bank with face recognition (Liquid)
2. "Who is this?" real-time identification
3. Conversational AI companion (Qwen3)
4. Semantic search across all memories
5. Large, accessible UI for elderly

### Nice to Have:
6. Voice memory journal
7. Memory timeline view
8. Smart reminders
9. Pattern recognition (routines)

### If Time:
10. Caregiver dashboard (patient-controlled)
11. Emergency SOS mode
12. Photo slideshow mode

---

## 🎨 UI PRIORITIES

**Hour 3-8**: Functional, accessible basics
**Hour 15-19**: Polish for elderly users

**Colors**: Soft blues, greens, warm neutrals (avoid red)
**Fonts**: 18pt minimum, 24pt headers
**Buttons**: LARGE, high contrast
**Icons**: Always with text labels
**Navigation**: Simple, clear back button always

---

## 📊 PERFORMANCE TARGETS

- Face recognition: < 1 sec
- Memory search: < 1 sec
- AI response: < 2 sec (acceptable for elderly users)
- App launch: < 2 sec

---

## 🎯 SUBMISSION CHECKLIST

Final Hour:
- [ ] APK uploaded and link works
- [ ] Demo video under 2 minutes (emotion-focused!)
- [ ] README explains memory helping memory
- [ ] All features work in airplane mode
- [ ] Tested on fresh install
- [ ] Screenshots of face recognition working
- [ ] Emphasize Track 1 perfect fit

---

## 📝 README TEMPLATE

```markdown
# Remember Me 💙

## Your memories, your device, your dignity

## The Beautiful Irony
We're using AI memory to help people who've lost theirs.
Track 1 is "The Memory Master"—we're building memory
technology to address memory loss.

## The Problem
55 million people with dementia. Research shows surveillance
"infringes on independence and dignity." $1.2T by 2050.

## The Solution
100% on-device AI companion. Face recognition (Liquid).
Voice memory. Conversational AI (Qwen3). Zero surveillance.

Memory helping memory.

[Rest of README...]
```

---

## 🏁 EXPECTED OUTCOME

If you follow this:
✅ Working face recognition
✅ AI memory helping human memory (perfect Track 1)
✅ Judges emotionally moved
✅ Clear edge AI necessity (dignity)
✅ **Top 3 finalist minimum**
✅ **Strong chance of winning**

---

## 💙 WHY THIS WINS

**Technical**: Multi-modal AI (face + voice + conversation) all local
**Emotional**: Helping grandma recognize her grandchildren
**Market**: $1.2T by 2050, 55M people need this
**Track 1**: "Memory Master" helping memory loss = PERFECT
**Ethics**: Can't do this with cloud without violating dignity
**Story**: Memory helping memory = poetic perfection

Judges will remember "Remember Me" - the app that uses AI memory to help those who've lost theirs.

---

**PRINT THIS. TAPE IT TO YOUR MONITOR. BUILD SOMETHING THAT MATTERS. WIN THIS. 💙🏆**

**Remember: Memory helping memory. That's your winning story.**
