import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rksi_schedule/data/model/schedule/schedule_model.dart';

import 'network_search.dart';

class SearchAction extends StatefulWidget {
  const SearchAction({Key? key}) : super(key: key);

  @override
  State<SearchAction> createState() => _SearchActionState();
}

class _SearchActionState extends State<SearchAction> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return IconButton(
        onPressed: () async {
          final result = await showSearch(
            context: context,
            delegate: SearchSchedule(),
          );
          if (result != "") {
            context.read<ScheduleModel>().getGroup(result!);
          }
        },
        icon: const Icon(Icons.search),
      );
    });
  }
}
