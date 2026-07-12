class StudySession {
  final String topic;
  final int minutes;
  final DateTime date;

  StudySession(
    this.topic,
    this.minutes,
    this.date,
  );

  Map<String, dynamic> toMap() => {
        'topic': topic,
        'minutes': minutes,
        'date': date.toIso8601String(),
      };

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      map['topic'],
      map['minutes'],
      DateTime.parse(map['date']),
    );
  }
}
