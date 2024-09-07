class Task {
  int? id;
  String title;
  String? description;
  DateTime dueDate;
  String status;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status == 'Completed' ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      status: map['status'] == 1 ? 'Completed' : 'Incomplete',
    );
  }
}
