import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rksi_schedule/data/model/schedule/schedule_model.dart';

class GroupName extends StatelessWidget {
  const GroupName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupName = context.watch<ScheduleModel>().groupName;

    return Text(groupName);
  }
}
