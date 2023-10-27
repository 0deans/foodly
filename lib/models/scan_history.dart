import 'dart:typed_data';

class ScanHistory {
  final int id;
  final String imagePath;
  final DateTime createdAt;

  const ScanHistory({
    required this.id,
    required this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'],
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
