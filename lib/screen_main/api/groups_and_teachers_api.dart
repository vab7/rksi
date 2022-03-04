import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rksi_schedule/screen_main/group/group.dart';

class GroupsAndTeachersApi {
  static int? groupsLength;

  static void _saveGroupsLength(int groupsLength) async {
    final boxGroupsLength = await Hive.openBox<int>('groupsLength_box');
    boxGroupsLength.put('groupsLength', groupsLength);
  }

  static Future<String> getFirstGroup() async {
    String? groupName;
    const uriGroup = 'https://rksi.ru/export/schedule.php?type=groups';

    final urlGroup = Uri?.parse(uriGroup);

    try {
      final responseGroups = await http.get(urlGroup);

      final bodyGroups = json.decode(responseGroups.body);

      groupName = bodyGroups[0] + '#0';
    } catch (_) {}

    return groupName ?? 'нет интернета';
  }

  static Future<List<String>> searchName() async {
    var jsonList = <String>[];

    const uriGroups = 'https://rksi.ru/export/schedule.php?type=groups';
    const uriTeachers = 'https://rksi.ru/export/schedule.php?type=teachers';

    final urlGroups = Uri?.parse(uriGroups);
    final urlTeachers = Uri?.parse(uriTeachers);

    try {
      final responseGroups = await http.get(urlGroups);
      final responseTeachers = await http.get(urlTeachers);

      final bodyGroups = json.decode(responseGroups.body);
      final bodyTearchers = json.decode(responseTeachers.body);

      groupsLength = bodyGroups.toList().length;

      _saveGroupsLength(groupsLength!);

      final body =
          (bodyGroups as List<dynamic>) + (bodyTearchers as List<dynamic>);
      var i = 0;
      jsonList =
          body.map<String>((json) => json + ('#${i++}').toString()).toList();
    } catch (_) {}

    return jsonList;
  }

  static Future<List<Group>> getGroup(int index) async {
    final http.Response response;

    final boxGroupsLength = await Hive.openBox<int>('groupsLength_box');

    if (boxGroupsLength.values.isNotEmpty) {
      void readGroupFromHive() {
        groupsLength = boxGroupsLength.get('groupsLength')!;
      }

      readGroupFromHive();
      boxGroupsLength.listenable().addListener(readGroupFromHive);
    }

    if (groupsLength == null) {
      response = await http.get(
        Uri?.parse(
            'https://rksi.ru/export/schedule.php?type=teacher&item=$index'),
      );
    } else if (index >= groupsLength!) {
      index -= groupsLength!;
      response = await http.get(
        Uri?.parse(
            'https://rksi.ru/export/schedule.php?type=teacher&item=$index'),
      );
    } else {
      response = await http.get(
        Uri?.parse(
            'https://rksi.ru/export/schedule.php?type=group&item=$index'),
      );
    }

    if (response.statusCode == 200) {
      final bodyGroups = json.decode(response.body) as List<dynamic>;
      return bodyGroups
          .map<Group>((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<bool> internet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {}

    return false;
  }
}
