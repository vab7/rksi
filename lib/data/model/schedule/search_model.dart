import 'package:flutter/material.dart';
import 'package:rksi_schedule/data/api/api.dart';

class SearchModel {
  final _groupsName = Api.searchName();

  late String _queryText, _remainingText;

  late dynamic _data;

  Future<List<String>> get groupsName => _groupsName;
  String get queryText => _queryText;
  String get remainingText => _remainingText;

  void getSuggestions(var suggestions, var index, var query) {
    final suggestion = suggestions[index];
    final group = suggestion.split('#');

    final groupName = group[0];

    _queryText = groupName.substring(0, query.length);
    _remainingText = groupName.substring(query.length);
  }

  String getSuggestion(var index, var suggestions) {
    return suggestions[index].split('#')[1];
  }

  void clear(var query, var context) {
    if (query.isEmpty) {
      context.close(context, '');
    } else {
      query = '';
      context.showSuggestions(context);
    }
  }

  List<String> suggestions(var query, var snapshot) {
    final suggestions = _data.isEmpty
        ? _data
        : _data.where((String name) {
            final queryText = query.toLowerCase();
            final nameText = name.toLowerCase();

            return nameText.startsWith(queryText);
          }).toList();

    return suggestions;
  }

  bool connection(var snapshot) {
    final connectionState = snapshot.connectionState;
    const waiting = ConnectionState.waiting;

    return connectionState == waiting;
  }

  bool isDataEmpty(var snapshot) {
    _data = snapshot.data;

    return _data.isNotEmpty;
  }
}
