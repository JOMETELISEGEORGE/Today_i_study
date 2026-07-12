class DailyPlanItem {
  final String id;
  final String task;
  final DateTime date;
  bool isCompleted;

  DailyPlanItem({
    required this.id,
    required this.task,
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'task': task,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory DailyPlanItem.fromMap(Map<String, dynamic> map) {
    return DailyPlanItem(
      id: map['id'],
      task: map['task'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
