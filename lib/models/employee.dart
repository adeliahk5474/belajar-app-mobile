class Employee {
  final String id;
  String name;
  String role;
  double salary;
  String? imagePath; // lokal
  String? imageUrl; // cloud (opsional)

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
    this.imagePath,
    this.imageUrl,
  });

  Employee copyWith({
    String? name,
    String? role,
    double? salary,
    String? imagePath,
    String? imageUrl,
  }) => Employee(
    id: id,
    name: name ?? this.name,
    role: role ?? this.role,
    salary: salary ?? this.salary,
    imagePath: imagePath ?? this.imagePath,
    imageUrl: imageUrl ?? this.imageUrl,
  );
}
