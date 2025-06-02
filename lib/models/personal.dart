class Personal {
  final String id;
  final String usuarioId;

  Personal({
    required this.id,
    required this.usuarioId,
  });

  factory Personal.fromMap(Map<String, dynamic> map, String id) {
    return Personal(
      id: id,
      usuarioId: map['usuarioId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
    };
  }
}
