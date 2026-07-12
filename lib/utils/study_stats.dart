import '../models/subject_model.dart';
import '../models/study_session_model.dart';
import '../models/study_subtopic_item.dart';

class StudyStats {
  /// ===============================
  /// BASIC STUDY STATS
  /// ===============================

  static int totalMinutes(List<StudySession> sessions) {
    return sessions.fold(0, (sum, s) => sum + s.minutes);
  }

  static int totalSessions(List<StudySession> sessions) {
    return sessions.length;
  }

  /// Most studied topic (used in Study History)
  static String topTopic(List<StudySession> sessions) {
    if (sessions.isEmpty) return "-";

    final Map<String, int> topicMinutes = {};

    for (var s in sessions) {
      topicMinutes[s.topic] =
          (topicMinutes[s.topic] ?? 0) + s.minutes;
    }

    return topicMinutes.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// ===============================
  /// SUBJECT-LEVEL ANALYTICS
  /// ===============================

  /// Minutes studied per subject (topic text match)
  static Map<String, int> minutesPerSubject(
    List<StudySession> sessions,
    List<Subject> subjects,
  ) {
    final Map<String, int> result = {
      for (var s in subjects) s.name: 0,
    };

    for (var session in sessions) {
      for (var subject in subjects) {
        if (session.topic
            .toLowerCase()
            .contains(subject.name.toLowerCase())) {
          result[subject.name] =
              (result[subject.name] ?? 0) + session.minutes;
        }
      }
    }
    return result;
  }

  /// Time-based progress (PRIMARY metric)
  static double subjectProgress(
    Subject subject,
    int studiedMinutes,
  ) {
    final requiredMinutes = subject.totalModules * 60;
    if (requiredMinutes == 0) return 0;
    return (studiedMinutes / requiredMinutes)
        .clamp(0, 1)
        .toDouble();
  }

  /// Checklist coverage (SECONDARY metric)
  static double checklistCoverage(
    List<StudySubtopicItem> items,
  ) {
    if (items.isEmpty) return 0;

    final completed =
        items.where((e) => e.isCompleted).length;
    return completed / items.length;
  }

  /// Subject needing attention (lowest time progress)
  static String prioritySubject(
    List<Subject> subjects,
    Map<String, int> minutesMap,
  ) {
    double lowest = 1.0;
    String name = "-";

    for (var s in subjects) {
      final studied = minutesMap[s.name] ?? 0;
      final progress = subjectProgress(s, studied);

      if (progress < lowest) {
        lowest = progress;
        name = s.name;
      }
    }
    return name;
  }
}
