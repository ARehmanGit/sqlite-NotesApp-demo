class Note {
  int? id;
  final String name;
  final String description;

  Note({required this.name, required this.description, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Note.fromJson(Map<String, dynamic> map) {
    return Note(
      name: map['name'],
      description: map['description'],
      id: map['id'],
    );
  }
}
