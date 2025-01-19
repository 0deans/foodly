class ScanHistory {
  final String id;
  final String imageUrl;
  final DateTime scannedAt;
  final String userId;

  ScanHistory({
    required this.id,
    required this.imageUrl,
    required this.scannedAt,
    required this.userId,
  });

  factory ScanHistory.fromJson(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'] as String,
      imageUrl: map['imageUrl'].toString().replaceFirst(
          "http://s3.localhost.localstack.cloud", "http://10.0.2.2"),
      scannedAt: DateTime.parse(map['scannedAt'] as String),
      userId: map['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'scannedAt': scannedAt.toIso8601String(),
      'userId': userId,
    };
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalScans;
  final int limit;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalScans,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalScans: json['totalScans'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalScans': totalScans,
      'limit': limit,
    };
  }
}

class ScanHistoryResponse {
  final List<ScanHistory> data;
  final Pagination pagination;

  ScanHistoryResponse({
    required this.data,
    required this.pagination,
  });

  factory ScanHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ScanHistoryResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => ScanHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
