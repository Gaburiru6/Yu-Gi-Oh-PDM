import 'dart:convert';

List<HeroModel> heroModelFromJson(String str) =>
    List<HeroModel>.from(json.decode(str).map((x) => HeroModel.fromJson(x)));

int _parseJsonInt(dynamic value) {
  if (value == null || value == 'null') return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

class HeroModel {
  final int id;
  final String name;
  final Powerstats powerstats;
  final Appearance appearance;
  final Biography biography;
  final Images images;

  HeroModel({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.appearance,
    required this.biography,
    required this.images,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) => HeroModel(
    id: _parseJsonInt(json["id"]),
    name: json["name"],
    powerstats: Powerstats.fromJson(json["powerstats"]),
    appearance: Appearance.fromJson(json["appearance"]),
    biography: Biography.fromJson(json["biography"]),
    images: Images.fromJson(json["images"]),
  );

  factory HeroModel.fromMap(Map<String, dynamic> map) => HeroModel(
    id: map["id"],
    name: map["name"],
    powerstats: Powerstats.fromJson(json.decode(map["powerstats"])),
    appearance: Appearance.fromJson(json.decode(map["appearance"])),
    biography: Biography.fromJson(json.decode(map["biography"])),
    images: Images.fromJson(json.decode(map["images"])),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "powerstats": json.encode(powerstats.toJson()),
    "appearance": json.encode(appearance.toJson()),
    "biography": json.encode(biography.toJson()),
    "images": json.encode(images.toJson()),
  };
}

class Appearance {
  final String gender;
  final String race;
  final List<String> height;
  final List<String> weight;

  Appearance({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) => Appearance(
    gender: json["gender"] ?? 'N/A',
    race: json["race"] ?? 'N/A',
    height: List<String>.from(json["height"]?.map((x) => x) ?? ['N/A']),
    weight: List<String>.from(json["weight"]?.map((x) => x) ?? ['N/A']),
  );

  Map<String, dynamic> toJson() => {
    "gender": gender,
    "race": race,
    "height": List<dynamic>.from(height.map((x) => x)),
    "weight": List<dynamic>.from(weight.map((x) => x)),
  };
}

class Biography {
  final String fullName;
  final String publisher;

  Biography({
    required this.fullName,
    required this.publisher,
  });

  factory Biography.fromJson(Map<String, dynamic> json) => Biography(
    fullName: json["fullName"] ?? 'N/A',
    publisher: json["publisher"] ?? 'N/A',
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "publisher": publisher,
  };
}

class Images {
  final String xs;
  final String sm;
  final String md;
  final String lg;

  Images({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    xs: json["xs"],
    sm: json["sm"],
    md: json["md"],
    lg: json["lg"],
  );

  Map<String, dynamic> toJson() => {
    "xs": xs,
    "sm": sm,
    "md": md,
    "lg": lg,
  };
}

class Powerstats {
  final int intelligence;
  final int strength;
  final int speed;
  final int durability;
  final int power;
  final int combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });


  factory Powerstats.fromJson(Map<String, dynamic> json) => Powerstats(
    intelligence: _parseJsonInt(json["intelligence"]),
    strength: _parseJsonInt(json["strength"]),
    speed: _parseJsonInt(json["speed"]),
    durability: _parseJsonInt(json["durability"]),
    power: _parseJsonInt(json["power"]),
    combat: _parseJsonInt(json["combat"]),
  );

  Map<String, dynamic> toJson() => {
    "intelligence": intelligence,
    "strength": strength,
    "speed": speed,
    "durability": durability,
    "power": power,
    "combat": combat,
  };
}

