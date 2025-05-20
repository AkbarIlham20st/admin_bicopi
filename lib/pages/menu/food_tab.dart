import 'package:flutter/material.dart';

class FoodTab extends StatelessWidget {
  const FoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: List.generate(6, (index) => MenuCard(index: index, category: 'Food')),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final int index;
  final String category;
  const MenuCard({required this.index, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Image.network(
            'https://via.placeholder.com/80',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$category Menu $index', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Deskripsi singkat menu...'),
                Text('Harga: Rp15.000'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}