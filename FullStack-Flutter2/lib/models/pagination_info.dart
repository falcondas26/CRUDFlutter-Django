class PaginationInfo {
  final int count;
  final String next;
  final String previous;

  PaginationInfo({
    required this.count,
    required this.next,
    required this.previous
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      count: json['count'] ?? 1,
      next: json['next'],
      previous: json['previous'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous
    };
  }

  bool get hasNextPage => next.isNotEmpty;
  bool get hasPreviousPage => previous.isNotEmpty;
}
