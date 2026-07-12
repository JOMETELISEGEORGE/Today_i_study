import 'dart:async';
import 'package:flutter/material.dart';
import '../models/study_session_model.dart';
import '../services/study_session_storage.dart';

class PomodoroPage extends StatefulWidget {
  final String topic;

  const PomodoroPage({
    super.key,
    required this.topic,
  });

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  Timer? _timer;

  int _selectedMinutes = 25; // editable
  late int _remainingSeconds;

  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _selectedMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds <= 0) {
          _finishSession();
        } else {
          setState(() => _remainingSeconds--);
        }
      },
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  Future<void> _finishSession() async {
    _timer?.cancel();
    _isRunning = false;

    final int studiedMinutes =
        ((_selectedMinutes * 60 - _remainingSeconds) / 60).ceil();

    if (studiedMinutes > 0) {
      final session = StudySession(
        widget.topic,
        studiedMinutes,
        DateTime.now(),
      );
      await StudySessionStorage.save(session);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Study session saved"),
        duration: Duration(seconds: 1),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pop(context);
  }

  void _resetTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deep Focus"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isRunning ? _stopTimer : () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Topic
            Text(
              widget.topic,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            // Timer
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // ⏱ Duration selector (only when stopped)
            if (!_isRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [15, 25, 45].map((m) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text("$m min"),
                      selected: _selectedMinutes == m,
                      onSelected: (_) => _resetTimer(m),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: const Text("Start"),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  child: const Text("Stop"),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: !_isRunning ? _finishSession : null,
                  child: const Text(
                    "Finish",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
