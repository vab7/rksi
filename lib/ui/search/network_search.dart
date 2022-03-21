import 'package:flutter/material.dart';
import 'package:rksi_schedule/data/model/schedule/search_model.dart';
import 'package:rksi_schedule/ui/search/progress_indicator.dart';

class SearchSchedule extends SearchDelegate<String> {
  final model = SearchModel();

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => model.clear(query, context),
          icon: const Icon(Icons.clear),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: model.groupsName,
      builder: (context, snapshot) {
        if (model.connection(snapshot)) {
          return const SearchProgressIndicator();
        } else {
          if (model.isDataEmpty(snapshot)) {
            final suggestions = model.suggestions(query, snapshot);

            return buildSuggestionsSuccess(suggestions);
          } else {
            return buildNoSuggestions();
          }
        }
      },
    );
  }

  Widget buildNoSuggestions() {
    return const Center(
      child: Text('нет подключения к интернету'),
    );
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        model.getSuggestions(suggestions, index, query);

        return ListTile(
          onTap: () {
            final suggestion = model.getSuggestion(index, suggestions);

            close(context, suggestion);
          },
          title: RichText(
            text: TextSpan(
              text: model.queryText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: model.remainingText,
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
}
