
import 'package:kiosk/models/settings.dart';

class Branch {
  final int? id;
  final String? name;
  final String? code;
  final String? address;
  final Setting? settings;

  Branch({
    this.id,
    this.name,
    this.code,
    this.address,
    this.settings,
  });

  Branch copyWith({
    int? id,
    String? name,
    String? code,
    String? address,
    Setting? settings,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'settings': settings?.toMap(),
    };
  }

  factory Branch.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Branch();
    return Branch(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      address: map['address'],
      settings: map['settings'] != null ? Setting.fromMap(map['settings']) : null,
    );
  }

  @override
  String toString() => 'Branch(id: $id, name: $name, code: $code)';
}
