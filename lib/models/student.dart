class Student {
  final String name;
  final String matricule;
  final double? ca;
  final double? exam;

  double? total;
  String? grade;
  int? rank;

  Student({
    required this.name,
    required this.matricule,
    this.ca,
    this.exam,
  });
}