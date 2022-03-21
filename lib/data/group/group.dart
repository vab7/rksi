import 'package:hive/hive.dart';
import 'package:rksi_schedule/data/schedule/schedule.dart';
part 'group.g.dart';

@HiveType(typeId: 1)
class Group {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<Schedule> schedule;

  Group({
    required this.date,
    required this.schedule,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    date: json['date'] as String,
    schedule: (json['schedule'] as List<dynamic>)
        .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
