// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 2;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule(
      id: fields[0] as String,
      group: fields[1] as String,
      week: fields[2] as String,
      date: fields[3] as String,
      time: fields[4] as String,
      start: fields[5] as String,
      end: fields[6] as String,
      teacher: fields[7] as String,
      door: fields[8] as String,
      subject: fields[9] as String,
      day: fields[10] as String,
      month: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.group)
      ..writeByte(2)
      ..write(obj.week)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.start)
      ..writeByte(6)
      ..write(obj.end)
      ..writeByte(7)
      ..write(obj.teacher)
      ..writeByte(8)
      ..write(obj.door)
      ..writeByte(9)
      ..write(obj.subject)
      ..writeByte(10)
      ..write(obj.day)
      ..writeByte(11)
      ..write(obj.month);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
