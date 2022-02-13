class ToDo {
  final int? id;
  final String title;
  final String description;
  final String date;

  ToDo({this.id, required this.title, required this.description, required this.date});

  factory ToDo.fromMap(Map<String, dynamic> json) => ToDo(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    date: json['date'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}