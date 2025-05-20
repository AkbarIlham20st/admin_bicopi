import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/menu_provider.dart';

class MenuTabPage extends StatefulWidget {
  final String category;
  const MenuTabPage({super.key, required this.category});

  @override
  State<MenuTabPage> createState() => _MenuTabPageState();
}

class _MenuTabPageState extends State<MenuTabPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MenuProvider>(context, listen: false)
          .fetchMenus(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);

    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: () =>
          Provider.of<MenuProvider>(context, listen: false)
              .fetchMenus(widget.category),
      child: provider.menus.isEmpty
          ? const Center(child: Text("No data"))
          : ListView.builder(
        itemCount: provider.menus.length,
        itemBuilder: (context, index) {
          final menu = provider.menus[index];
          return ListTile(
            leading: Image.network(menu.imageUrl, width: 60),
            title: Text(menu.title),
            subtitle: Text(menu.description),
            trailing: Text('Rp${menu.price.toStringAsFixed(0)}'),
          );
        },
      ),
    );
  }
}
