import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/memory.dart';
import '../models/person.dart';
import '../services/database_service.dart';

class MemoryTimelineScreen extends StatefulWidget {
  const MemoryTimelineScreen({super.key});

  @override
  State<MemoryTimelineScreen> createState() => _MemoryTimelineScreenState();
}

class _MemoryTimelineScreenState extends State<MemoryTimelineScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Memory> _memories = [];
  Map<String, Person> _peopleMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final memories = await _dbService.getAllMemories();
      final people = await _dbService.getAllPeople();

      // Create a map of person IDs to Person objects for quick lookup
      final peopleMap = <String, Person>{};
      for (final person in people) {
        peopleMap[person.id] = person;
      }

      setState(() {
        _memories = memories;
        _peopleMap = peopleMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading memories: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memories', style: TextStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _memories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 20),
                      Text(
                        'No memories yet',
                        style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Start adding people to create memories',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMemories,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _memories.length,
                    itemBuilder: (context, index) {
                      final memory = _memories[index];
                      return _MemoryCard(
                        memory: memory,
                        peopleMap: _peopleMap,
                      );
                    },
                  ),
                ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final Memory memory;
  final Map<String, Person> peopleMap;

  const _MemoryCard({
    required this.memory,
    required this.peopleMap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final relatedPeople = memory.relatedPeopleIds
        .map((id) => peopleMap[id]?.name)
        .where((name) => name != null)
        .join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Memory type icon and date
            Row(
              children: [
                _getMemoryIcon(memory.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (memory.title != null)
                        Text(
                          memory.title!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Text(
                        dateFormat.format(memory.date),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description/Content
            if (memory.description != null)
              Text(
                memory.description!,
                style: const TextStyle(fontSize: 16),
              ),

            // Related people
            if (relatedPeople.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.people, size: 18, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      relatedPeople,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getMemoryIcon(MemoryType type) {
    switch (type) {
      case MemoryType.photo:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.photo, color: Colors.blue.shade700),
        );
      case MemoryType.voice:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.mic, color: Colors.green.shade700),
        );
      case MemoryType.text:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.text_fields, color: Colors.purple.shade700),
        );
    }
  }
}
