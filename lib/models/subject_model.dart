class Subject {
  final String id;
  final String name;
  final DateTime examDate;
  final int totalModules;
  final int completedModules;

  Subject({
    required this.id,
    required this.name,
    required this.examDate,
    required this.totalModules,
    this.completedModules = 0,
  });

  int get daysLeft =>
      examDate.difference(DateTime.now()).inDays;

  int get remainingModules =>
      totalModules - completedModules;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'examDate': examDate.toIso8601String(),
        'totalModules': totalModules,
        'completedModules': completedModules,
      };

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      examDate: DateTime.parse(map['examDate']),
      totalModules: map['totalModules'],
      completedModules: map['completedModules'] ?? 0,
    );
  }
}
