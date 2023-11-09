import 'dart:convert';

List<ItemValue> itemValueFromJson(String str) =>
    List<ItemValue>.from(json.decode(str).map((x) => ItemValue.fromMap(x)));

String itemValueToJson(List<ItemValue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ItemValue {
  String? name;
  String? description;
  String? value;
  bool? state;

  ItemValue({
    this.name,
    this.description,
    this.value,
    this.state,
  });

  ItemValue copyWith({
    String? name,
    String? description,
    String? value,
    bool? state,
  }) =>
      ItemValue(
        name: name ?? this.name,
        description: description ?? this.description,
        value: value ?? this.value,
        state: state ?? this.state,
      );

  factory ItemValue.fromMap(Map<String, dynamic> json) => ItemValue(
        name: json["name"],
        description: json["description"],
        value: json["value"],
        state: json["state"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "value": value,
        "state": state,
      };
}
