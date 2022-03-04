import 'package:flutter/material.dart';
import 'package:rksi_schedule/screen_main/api/groups_and_teachers_api.dart';

class NetworkSearchGroups extends SearchDelegate<String> {
  final _groupsName = GroupsAndTeachersApi.searchName();

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
          icon: const Icon(Icons.clear),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, ''),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(query),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _groupsName,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.data!.isNotEmpty) {
              final data = snapshot.data!;
              final suggestions = data.isEmpty
                  ? data
                  : data.where((name) {
                      final queryText = query.toLowerCase();
                      final nameText = name.toLowerCase();

                      return nameText.startsWith(queryText);
                    }).toList();
              return buildSuggestionsSuccess(suggestions);
            } else {
              return buildNoSuggestions();
            }
        }
      },
    );
  }

  Widget buildNoSuggestions() => const Center(
        child: Text('нет подключения к интернету'),
      );

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final groupName = suggestion.split('#');
          final queryText = groupName[0].substring(0, query.length);
          final remainingText = groupName[0].substring(query.length);

          return ListTile(
            onTap: () {
              close(context, suggestion);
            },
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
