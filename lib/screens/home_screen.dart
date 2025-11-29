import 'package:flutter/material.dart';
import '../widgets/large_button.dart';
import 'add_person_screen.dart';
import 'recognize_face_screen.dart';
import 'memory_timeline_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Remember Me',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App description
              const Text(
                'Your memories, your device, your dignity',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Recognize Face Button
              LargeButton(
                text: 'Who Is This?',
                icon: Icons.face,
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecognizeFaceScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Add Person Button
              LargeButton(
                text: 'Add Someone',
                icon: Icons.person_add,
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPersonScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // View Memories Button
              LargeButton(
                text: 'My Memories',
                icon: Icons.photo_library,
                color: Colors.purple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MemoryTimelineScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Chat with AI Button
              LargeButton(
                text: 'Talk to Me',
                icon: Icons.chat,
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Privacy indicator
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '100% Private • All data stays on your device',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
