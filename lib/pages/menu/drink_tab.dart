import 'package:flutter/material.dart';
import 'food_tab.dart';

class DrinkTab extends StatelessWidget {
  const DrinkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: List.generate(4, (index) => MenuCard(index: index, category: 'Drink')),
      ),
    );
  }
}