class TaskModel {
  String id;
  String title;
  String description;
  String category;
  DateTime dueDate;
  String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      status: map['status'] ?? 'Pending',
    );
  }
}
