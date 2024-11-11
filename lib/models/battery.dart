class Battery {
  final int level;
  final bool isCharging;

  Battery({required this.level, required this.isCharging});

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      level: json['level'],
      isCharging: json['is_charging'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'is_charging': isCharging,
    };
  }
}
