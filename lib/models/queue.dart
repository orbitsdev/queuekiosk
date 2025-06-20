import 'package:kiosk/models/branch.dart';
import 'package:kiosk/models/service.dart';

class Queue {
  final int? id;
  final int? branchId;
  final int? serviceId;
  final int? counterId;
  final int? userId;
  final int? number;
  final String? ticketNumber;
  final String? status;
  final String? createdAt;
  final String? formattedDate;
  final String? formattedTime;
  final String? formattedDatetime;
  final Service? service;
  final Branch? branch;

  Queue({
    this.id,
    this.branchId,
    this.serviceId,
    this.counterId,
    this.userId,
    this.number,
    this.ticketNumber,
    this.status,
    this.createdAt,
    this.formattedDate,
    this.formattedTime,
    this.formattedDatetime,
    this.service,
    this.branch,
  });

  Queue copyWith({
    int? id,
    int? branchId,
    int? serviceId,
    int? counterId,
    int? userId,
    int? number,
    String? ticketNumber,
    String? status,
    String? createdAt,
    String? formattedDate,
    String? formattedTime,
    String? formattedDatetime,
    Service? service,
    Branch? branch,
  }) {
    return Queue(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      serviceId: serviceId ?? this.serviceId,
      counterId: counterId ?? this.counterId,
      userId: userId ?? this.userId,
      number: number ?? this.number,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      formattedDate: formattedDate ?? this.formattedDate,
      formattedTime: formattedTime ?? this.formattedTime,
      formattedDatetime: formattedDatetime ?? this.formattedDatetime,
      service: service ?? this.service,
      branch: branch ?? this.branch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'branch_id': branchId,
      'service_id': serviceId,
      'counter_id': counterId,
      'user_id': userId,
      'number': number,
      'ticket_number': ticketNumber,
      'status': status,
      'created_at': createdAt,
      'formatted_date': formattedDate,
      'formatted_time': formattedTime,
      'formatted_datetime': formattedDatetime,
      'service': service?.toMap(),
      'branch': branch?.toMap(),
    };
  }

  factory Queue.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Queue();
    return Queue(
      id: map['id'],
      branchId: map['branch_id'],
      serviceId: map['service_id'],
      counterId: map['counter_id'],
      userId: map['user_id'],
      number: map['number'],
      ticketNumber: map['ticket_number'],
      status: map['status'],
      createdAt: map['created_at'],
      formattedDate: map['formatted_date'],
      formattedTime: map['formatted_time'],
      formattedDatetime: map['formatted_datetime'],
      service: map['service'] != null ? Service.fromMap(map['service']) : null,
      branch: map['branch'] != null ? Branch.fromMap(map['branch']) : null,
    );
  }

  @override
  String toString() => 'Queue(id: $id, ticketNumber: $ticketNumber, status: $status)';
}