class Pokemon {
  int? id;
  late String name;
  late String number;
  late List<dynamic> type;
  late String weight;
  late int? position;

  Pokemon(
      {this.id,
      required this.name,
      required this.number,
      required this.type,
      required this.weight,
      this.position});

  Pokemon.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['order'].toString();
    type = map['type'];
    weight = map['weight'].toString();
    position = map['position'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number.toString(),
      'type': type,
      'weight': weight.toString(),
      'position': position
    };
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      number: json['order'].toString(),
      type: json['types'],
      weight: json['weight'].toString(),
    );
  }

  @override
  String toString() {
    return 'Pokemon{id: $id, name: $name, types: $type}';
  }
}

class Types {
  int? slot;
  late Type type;
}

class Type {
  late String name;
  late String url;
}
