import 'package:flutter/material.dart';

class SearchProgressIndicator extends StatelessWidget {
  const SearchProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
