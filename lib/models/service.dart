import 'package:kiosk/models/branch.dart';

class Service {
  final int? id;
  final int? branchId;
  final String? name;
  final String? code;
  final String? description;
  final int? lastTicketNumber;
  final int? waitingCount;
  final Branch? branch;

  Service({
    this.id,
    this.branchId,
    this.name,
    this.code,
    this.description,
    this.lastTicketNumber,
    this.waitingCount,
    this.branch,
  });

  Service copyWith({
    int? id,
    int? branchId,
    String? name,
    String? code,
    String? description,
    int? lastTicketNumber,
    int? waitingCount,
    Branch? branch,
  }) {
    return Service(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      lastTicketNumber: lastTicketNumber ?? this.lastTicketNumber,
      waitingCount: waitingCount ?? this.waitingCount,
      branch: branch ?? this.branch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch_id': branchId,
      'name': name,
      'code': code,
      'description': description,
      'last_ticket_number': lastTicketNumber,
      'waiting_count': waitingCount,
      'branch': branch?.toMap(),
    };
  }

  factory Service.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Service();
    return Service(
      id: map['id'],
      branchId: map['branch_id'],
      name: map['name'],
      code: map['code'],
      description: map['description'],
      lastTicketNumber: map['last_ticket_number'],
      waitingCount: map['waiting_count'],
      branch: map['branch'] != null ? Branch.fromMap(map['branch']) : null,
    );
  }

  @override
  String toString() => 'Service(id: $id, name: $name, code: $code)';
}