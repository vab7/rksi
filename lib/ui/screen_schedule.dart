import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rksi_schedule/resourses/app_colors.dart';
import 'package:rksi_schedule/data/model/schedule/schedule_model.dart';
import 'package:rksi_schedule/data/schedule/schedule.dart';

import 'group_name/group_name.dart';
import 'search/search_action.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const GroupName(),
          centerTitle: true,
          actions: const [
            SearchAction(),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: const IndicatorRef(),
        ),
      ),
    );
  }
}

class IndicatorRef extends StatelessWidget {
  const IndicatorRef({Key? key}) : super(key: key);

  Future<void> getGroup(BuildContext context) async {
    await context
        .watch<ScheduleModel>()
        .getGroup(context.read<ScheduleModel>().resultGroup);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primary,
      displacement: 50,
      onRefresh: () => getGroup(context),
      child: const ScheduleBody(),
    );
  }
}

class ScheduleBody extends StatefulWidget {
  const ScheduleBody({Key? key}) : super(key: key);

  @override
  State<ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 100000,
      padding: const EdgeInsets.only(top: 5),
      physics: const BouncingScrollPhysics(),
      itemCount: context.watch<ScheduleModel>().group.length,
      itemBuilder: (context, index) {
        return Group(
          index: index,
        );
      },
    );
  }
}

class Group extends StatelessWidget {
  final int index;

  const Group({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = context.read<ScheduleModel>().group[index];
    final groupDate = DateTime.parse(group.date);

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final theDayAfterTomorrow = tomorrow.add(const Duration(days: 1));
    String? todayString;

    final String month;

    if (groupDate.day == today.day) {
      todayString = 'Сегодня';
    } else if (groupDate.day == tomorrow.day) {
      todayString = 'Завтра';
    } else if (groupDate.day == theDayAfterTomorrow.day) {
      todayString = 'Послезавтра';
    }

    switch (groupDate.month) {
      case 1:
        month = 'Янв.';
        break;
      case 2:
        month = 'Фев.';
        break;
      case 3:
        month = 'Мар.';
        break;
      case 4:
        month = 'Апр.';
        break;
      case 5:
        month = 'Мая';
        break;
      case 6:
        month = 'Июн.';
        break;
      case 7:
        month = 'Июл.';
        break;
      case 8:
        month = 'Авг.';
        break;
      case 9:
        month = 'Сен.';
        break;
      case 10:
        month = 'Окт.';
        break;
      case 11:
        month = 'Ноя.';
        break;
      case 12:
        month = 'Дек.';
        break;
      default:
        month = '';
    }

    final result = todayString ?? '${groupDate.day}, $month';

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                result,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: primary,
            ),
          ),
        ),
        ScheduleList(schedule: group.schedule),
      ],
    );
  }
}

class ScheduleList extends StatefulWidget {
  final List<Schedule> schedule;

  const ScheduleList({
    Key? key,
    required this.schedule,
  }) : super(key: key);

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.schedule.length,
      itemBuilder: (context, index) {
        return ScheduleT(
          schedule: widget.schedule[index],
        );
      },
    );
  }
}

class ScheduleT extends StatefulWidget {
  final Schedule schedule;

  const ScheduleT({
    Key? key,
    required this.schedule,
  }) : super(key: key);

  @override
  State<ScheduleT> createState() => _ScheduleTState();
}

class _ScheduleTState extends State<ScheduleT> {
  var duration = const Duration();

  Color? _colorLinearGradient;

  void timer() {
    var dateNow = DateTime.now();

    var startTime =
        DateTime.parse('${widget.schedule.date} ${widget.schedule.start}');
    var endTime =
        DateTime.parse('${widget.schedule.date} ${widget.schedule.end}');

    if (dateNow.isAfter(startTime) && dateNow.isBefore(endTime)) {
      _colorLinearGradient = secondaryText;
    } else if (dateNow.isAfter(endTime)) {
      _colorLinearGradient = end;
    } else {
      _colorLinearGradient = primary;
    }

    setState(() {
      const addSeconds = 1;

      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  @override
  void initState() {
    super.initState();

    var today = DateTime.now();
    if (today.month <= int.parse(widget.schedule.month)) {
      if (today.month < int.parse(widget.schedule.month)) {
        return;
      } else if (today.day <= int.parse(widget.schedule.day)) {
        if (today.day == int.parse(widget.schedule.day)) {
          timer();

          Timer.periodic(const Duration(seconds: 1), (_) {
            timer();
          });
        } else {
          _colorLinearGradient = primary;
        }
      } else {
        _colorLinearGradient = end;
      }
    } else {
      _colorLinearGradient = end;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String interval;

    switch (widget.schedule.start.split(':')[0]) {
      case '09':
        interval = '20';
        break;
      case '13':
        interval = '20';
        break;
      default:
        interval = '10';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0.02, 0.02],
            colors: [
              _colorLinearGradient!,
              Colors.white,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: thirdText),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
            ),
          ),
          margin: const EdgeInsets.only(left: 5.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        widget.schedule.subject,
                        maxLines: 2,
                        style: const TextStyle(
                          height: 1,
                          color: primaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        widget.schedule.teacher,
                        maxLines: 2,
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Кабинет ${widget.schedule.door}',
                        maxLines: 2,
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        '${widget.schedule.start} - ${widget.schedule.end}',
                        style: TextStyle(
                          color: _colorLinearGradient,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: Row(
                    children: [
                      Text(
                        interval,
                        style: const TextStyle(
                          color: Color.fromRGBO(222, 222, 222, 1),
                        ),
                      ),
                      const SizedBox(width: 1),
                      const Icon(
                        Icons.schedule,
                        size: 15,
                        color: Color.fromRGBO(222, 222, 222, 1),
                      ),
                    ],
                  ),
                  bottom: 2,
                  right: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
