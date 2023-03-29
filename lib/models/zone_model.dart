class ZoneModel {
  String description;
  String sigla;
  String id;

  ZoneModel({required this.description, required this.sigla, required this.id});

  Map<String, dynamic> toJson() =>
      {'description': description, 'sigla': sigla, 'id': id};

  static ZoneModel fromJson(Map<String, dynamic> json) => ZoneModel(
      description: json['description'], sigla: json['sigla'], id: json['id']);
}
