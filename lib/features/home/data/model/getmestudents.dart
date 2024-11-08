import 'dart:convert';

class Getmestudents {
  List<Result> results;

  Getmestudents({
    required this.results,
  });

  Getmestudents copyWith({
    List<Result>? results,
  }) =>
      Getmestudents(
        results: results ?? this.results,
      );

  factory Getmestudents.fromRawJson(String str) => Getmestudents.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Getmestudents.fromJson(Map<String, dynamic> json) => Getmestudents(
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  int id;
  String searchImagePath;
  String scanId;
  int student;
  String studentName;
  DateTime createdAt;

  Result({
    required this.id,
    required this.searchImagePath,
    required this.scanId,
    required this.student,
    required this.studentName,
    required this.createdAt,
  });

  Result copyWith({
    int? id,
    String? searchImagePath,
    String? scanId,
    int? student,
    String? studentName,
    DateTime? createdAt,
  }) =>
      Result(
        id: id ?? this.id,
        searchImagePath: searchImagePath ?? this.searchImagePath,
        scanId: scanId ?? this.scanId,
        student: student ?? this.student,
        studentName: studentName ?? this.studentName,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    searchImagePath: json["search_image_path"],
    scanId: json["scan_id"],
    student: json["student"],
    studentName: json["student_name"], // Directly accessing the string value
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "search_image_path": searchImagePath,
    "scan_id": scanId,
    "student": student,
    "student_name": studentName,
    "created_at": createdAt.toIso8601String(),
  };
}
