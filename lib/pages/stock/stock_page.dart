import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock_provider.dart';
import 'package:admin_bicopi/pages/stock/stock_tab_page.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  // State<StockPage> createState() => _StockPageState();
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stock Page"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Food"),
              Tab(text: "Drink"),
              Tab(text: "Snack"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StockTabPage(category: 'Food'),
            StockTabPage(category: 'Drink'),
            StockTabPage(category: 'Snack'),
          ],
        ),
      ),
    );
  }
}

// class StockPage extends StatefulWidget {
//   const StockPage({super.key});
//
//   @override
//   State<StockPage> createState() => _StockPageState();
// }
//
// class _StockPageState extends State<StockPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<StockProvider>(context, listen: false).loadStocks();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   Widget buildList(List<StokDetailWithMenu> stocks) {
//     return ListView.builder(
//       itemCount: stocks.length,
//       itemBuilder: (context, index) {
//         final stock = stocks[index];
//         return ListTile(
//           title: Text(stock.namaMenu),
//           subtitle: Text('${stock.namaItem} • Total: ${stock.totalItem}'),
//           onTap: () {
//             showDialog(
//               context: context,
//               builder: (_) => AlertDialog(
//                 title: Text(stock.namaItem),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('Menu: ${stock.namaMenu}'),
//                     Text('Kategori: ${stock.kategori}'),
//                     Text('Jumlah: ${stock.totalItem}'),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final stockProvider = Provider.of<StockProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stok Bahan Makanan'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Food'),
//             Tab(text: 'Drink'),
//             Tab(text: 'Snack'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           buildList(stockProvider.foodStocks),
//           buildList(stockProvider.drinkStocks),
//           buildList(stockProvider.snackStocks),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Panggil form tambah stok
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
