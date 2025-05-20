import 'package:flutter/material.dart';
import 'food_tab.dart';

class SnackTab extends StatelessWidget {
  const SnackTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: List.generate(5, (index) => MenuCard(index: index, category: 'Snack')),
      ),
    );
  }
}
