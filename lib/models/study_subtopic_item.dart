class StudySubtopicItem {
  final String parentTopic;
  final String text;
  bool isCompleted;

  StudySubtopicItem({
    required this.parentTopic,
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'parentTopic': parentTopic,
        'text': text,
        'isCompleted': isCompleted,
      };

  factory StudySubtopicItem.fromMap(Map<String, dynamic> map) {
    return StudySubtopicItem(
      parentTopic: map['parentTopic'],
      text: map['text'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
