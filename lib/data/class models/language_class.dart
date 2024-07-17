class Region {
  final String name;
  final String queryCode;

  Region({required this.name, required this.queryCode});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['name'],
      queryCode: json['queryCode'],
    );
  }
}
