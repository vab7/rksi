import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rksi_schedule/data/api/api.dart';
import 'package:rksi_schedule/data/group/group.dart';

class ScheduleModel extends ChangeNotifier {
  String? _resultGroup;
  var _group = <Group>[];
  String? _groupName;

  ScheduleModel() {
    _registerAdapter();
  }

  String get resultGroup => _resultGroup!;
  List<Group> get group => _group.toList();
  String get groupName => _groupName ?? 'Группа';

  Future<void> getGroup(String index) async {
    _resultGroup = index;

    Api.internet().then((connection) async {
      if (connection) {
        _group.clear();

        notifyListeners();

        _group = await Api.getGroup(int.parse(index));

        notifyListeners();

        saveGroup();
      }
    });
  }

  void saveGroup() async {
    final boxGroup = await Hive.openBox<List<dynamic>>('group_box');
    boxGroup.put('group', _group);

    final boxGroupName = await Hive.openBox<String>('groupName_box');
    final boxIndexGroup = await Hive.openBox<String>('indexGroup_box');

    boxGroupName.put('groupName', _groupName!);
    boxIndexGroup.put('indexGroup', _resultGroup!);
  }

  void _registerAdapter() async {
    final boxGroupName = await Hive.openBox<String>('groupName_box');
    final boxIndexGroup = await Hive.openBox<String>('indexGroup_box');
    final boxGroup = await Hive.openBox<List<dynamic>>('group_box');

    if (boxGroup.values.isNotEmpty) {
      void readGroupFromHive() {
        _group = boxGroup.get('group')!.map((e) => e as Group).toList();

        notifyListeners();
      }

      readGroupFromHive();
      boxGroup.listenable().addListener(readGroupFromHive);
    } else {
      final groupName = await Api.getFirstGroup();
      getGroup(groupName);
    }

    if (boxGroupName.values.isNotEmpty) {
      void readGroupFromHive() {
        _groupName = boxGroupName.get('groupName');

        notifyListeners();
      }

      readGroupFromHive();
      boxGroupName.listenable().addListener(readGroupFromHive);
    }

    if (boxIndexGroup.values.isNotEmpty) {
      void readGroupFromHive() {
        _resultGroup = boxIndexGroup.get('indexGroup');

        notifyListeners();
      }

      readGroupFromHive();
      boxIndexGroup.listenable().addListener(readGroupFromHive);
    }
  }
}
