import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/common_widgets.dart';

class JobNotesScreen extends StatefulWidget {
  final String jobId;
  const JobNotesScreen({super.key, required this.jobId});

  @override
  State<JobNotesScreen> createState() => _JobNotesScreenState();
}

class _JobNotesScreenState extends State<JobNotesScreen> {
  final _noteCtrl = TextEditingController();
  List<Map<String, dynamic>> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('job_notes_${widget.jobId}');
    if (data != null) {
      _notes = (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
    }
    setState(() => _loading = false);
  }

  Future<void> _addNote() async {
    final text = _noteCtrl.text.trim();
    if (text.isEmpty) return;

    final note = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _notes.insert(0, note);
      _noteCtrl.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_notes_${widget.jobId}', jsonEncode(_notes));
  }

  Future<void> _deleteNote(String id) async {
    setState(() => _notes.removeWhere((n) => n['id'] == id));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_notes_${widget.jobId}', jsonEncode(_notes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Job Notes'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : Column(
              children: [
                Expanded(
                  child: _notes.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.note_alt_outlined, color: AppColors.grey, size: 48),
                              SizedBox(height: 12),
                              Text('No notes yet', style: TextStyle(color: AppColors.grey)),
                              SizedBox(height: 4),
                              Text('Add notes about this job below', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            final timestamp = DateTime.tryParse(note['timestamp'] ?? '');
                            final timeStr = timestamp != null
                                ? '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} • ${timestamp.day}/${timestamp.month}'
                                : '';

                            return Dismissible(
                              key: Key(note['id']),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: AppColors.red,
                                child: const Icon(Icons.delete_rounded, color: Colors.white),
                              ),
                              onDismissed: (_) => _deleteNote(note['id']),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(note['text'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                                    const SizedBox(height: 6),
                                    Text(timeStr, style: const TextStyle(color: AppColors.grey, fontSize: 11)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteCtrl,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          minLines: 1,
                          decoration: const InputDecoration(
                            hintText: 'Add a note...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _addNote,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
