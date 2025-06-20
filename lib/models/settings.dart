
class Setting {
  final String? ticketPrefix;
  final bool? printLogo;

  Setting({
    this.ticketPrefix,
    this.printLogo,
  });

  Setting copyWith({
    String? ticketPrefix,
    bool? printLogo,
  }) {
    return Setting(
      ticketPrefix: ticketPrefix ?? this.ticketPrefix,
      printLogo: printLogo ?? this.printLogo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticket_prefix': ticketPrefix,
      'print_logo': printLogo,
    };
  }

  factory Setting.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Setting();
    return Setting(
      ticketPrefix: map['ticket_prefix'],
      printLogo: map['print_logo'],
    );
  }

  @override
  String toString() => 'Setting(ticketPrefix: $ticketPrefix, printLogo: $printLogo)';
}
