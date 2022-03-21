import 'package:hive/hive.dart';
part 'schedule.g.dart';

@HiveType(typeId: 2)
class Schedule {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String group;

  @HiveField(2)
  final String week;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final String start;

  @HiveField(6)
  final String end;

  @HiveField(7)
  final String teacher;

  @HiveField(8)
  final String door;

  @HiveField(9)
  final String subject;

  @HiveField(10)
  final String day;

  @HiveField(11)
  final String month;

  Schedule({
    required this.id,
    required this.group,
    required this.week,
    required this.date,
    required this.time,
    required this.start,
    required this.end,
    required this.teacher,
    required this.door,
    required this.subject,
    required this.day,
    required this.month,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return Schedule(
    id: json['tt_id'] as String,
    group: json['tt_gr'] as String,
    week: json['tt_week'] as String,
    date: json['tt_date'] as String,
    time: json['tt_time'] as String,
    start: json['tt_start'] as String,
    end: json['tt_end'] as String,
    teacher: json['tt_teacher'] as String,
    door: json['tt_cab'] as String,
    subject: json['tt_sub'] as String,
    day: json['tt_day'] as String,
    month: json['tt_month'] as String,
  );
}
