import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/common_widgets.dart';

class TimeTrackingScreen extends StatefulWidget {
  final String jobId;
  const TimeTrackingScreen({super.key, required this.jobId});

  @override
  State<TimeTrackingScreen> createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  bool _isRunning = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  List<Map<String, dynamic>> _entries = [];
  String? _startTime;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('time_entries_${widget.jobId}');
    if (data != null) {
      _entries = (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
    }
    final running = prefs.getBool('time_running_${widget.jobId}') ?? false;
    if (running) {
      final start = prefs.getString('time_start_${widget.jobId}');
      if (start != null) {
        _startTime = start;
        _isRunning = true;
        _elapsedSeconds = DateTime.now().difference(DateTime.parse(start)).inSeconds;
        _startTimer();
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('time_entries_${widget.jobId}', jsonEncode(_entries));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _start() async {
    final now = DateTime.now();
    _startTime = now.toIso8601String();
    _elapsedSeconds = 0;
    _isRunning = true;
    _startTimer();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('time_running_${widget.jobId}', true);
    await prefs.setString('time_start_${widget.jobId}', _startTime!);
    setState(() {});
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _isRunning = false;

    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'start': _startTime,
      'end': DateTime.now().toIso8601String(),
      'duration': _elapsedSeconds,
      'label': 'Work Session ${_entries.length + 1}',
    };

    _entries.insert(0, entry);
    await _saveEntries();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('time_running_${widget.jobId}', false);
    await prefs.remove('time_start_${widget.jobId}');

    setState(() => _elapsedSeconds = 0);
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  int get _totalTime {
    int total = _elapsedSeconds;
    for (final e in _entries) {
      total += (e['duration'] as int?) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Time Tracking'),
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
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isRunning ? AppColors.green : AppColors.border,
                        width: 4,
                      ),
                      color: AppColors.card,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isRunning ? Icons.timer_rounded : Icons.timer_off_rounded,
                          color: _isRunning ? AppColors.green : AppColors.grey,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDuration(_elapsedSeconds),
                          style: TextStyle(
                            color: _isRunning ? AppColors.green : Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isRunning ? 'Running' : 'Stopped',
                          style: TextStyle(
                            color: _isRunning ? AppColors.green : AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _isRunning ? _stop : _start,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _isRunning ? AppColors.red : AppColors.green,
                      shape: BoxShape.circle,
                      boxShadow: _isRunning ? AppShadows.red : AppShadows.green,
                    ),
                    child: Icon(
                      _isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Time', style: TextStyle(color: AppColors.grey)),
                      Text(_formatDuration(_totalTime), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text('WORK LOG', style: TextStyle(color: AppColors.grey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                      const Spacer(),
                      Text('${_entries.length} entries', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _entries.isEmpty
                      ? const Center(child: Text('No time entries yet', style: TextStyle(color: AppColors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _entries.length,
                          itemBuilder: (context, index) {
                            final entry = _entries[index];
                            final start = DateTime.tryParse(entry['start'] ?? '');
                            final startStr = start != null
                                ? '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
                                : '';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, color: AppColors.grey, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry['label'] ?? 'Session',
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                  Text(startStr, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                                  const SizedBox(width: 10),
                                  Text(
                                    _formatDuration(entry['duration'] ?? 0),
                                    style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
