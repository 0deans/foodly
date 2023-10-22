import 'dart:typed_data';

class ScanHistory {
  final int id;
  final Uint8List image;
  final DateTime createdAt;

  const ScanHistory({
    required this.id,
    required this.image,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'],
      image: map['image'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
