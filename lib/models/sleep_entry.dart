class SleepEntry {
  final DateTime sleepTime;
  final DateTime wakeTime;

  SleepEntry({required this.sleepTime, required this.wakeTime});

  Duration get duration => wakeTime.difference(sleepTime);

  Map<String, dynamic> toJson() => {
    'sleepTime': sleepTime.toIso8601String(),
    'wakeTime': wakeTime.toIso8601String(),
  };

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      sleepTime: DateTime.parse(json['sleepTime'] as String,),
      wakeTime: DateTime.parse(json['wakeTime'] as String,),
    );
  }
}
