import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/stock_model.dart';
import '../../providers/stock_provider.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemQtyController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();

  String _selectedCategory = 'Food';
  String? _selectedItemName;
  List<String> _namaItemList = [];
  bool _isOther = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<StockProvider>(context);
    final allItems = provider.stocks.expand((stock) => stock.menuStok).toList();
    final itemsByCategory = allItems
        .where((item) {
      final parent = provider.stocks.firstWhere((s) =>
          s.menuStok.contains(item));
      return parent.category == _selectedCategory;
    })
        .map((item) => item.namaItem)
        .toSet()
        .toList();
    setState(() {
      _namaItemList = itemsByCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Stok")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Food', 'Drink', 'Snack']
                    .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                    _selectedItemName = null;
                    _isOther = false;
                    final provider = Provider.of<StockProvider>(
                        context, listen: false);
                    final allItems = provider.stocks.expand((stock) =>
                    stock.menuStok).toList();
                    final itemsByCategory = allItems
                        .where((item) {
                      final parent = provider.stocks.firstWhere((s) =>
                          s.menuStok.contains(item));
                      return parent.category == _selectedCategory;
                    })
                        .map((item) => item.namaItem)
                        .toSet()
                        .toList();
                    _namaItemList = itemsByCategory;
                  });
                },
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedItemName,
                decoration: const InputDecoration(labelText: "Nama Bahan"),
                items: [
                  ..._namaItemList.map((name) =>
                      DropdownMenuItem(value: name, child: Text(name))),
                  const DropdownMenuItem(
                      value: 'other', child: Text('Lainnya...')),
                ],
                onChanged: (val) {
                  setState(() {
                    if (val == 'other') {
                      _isOther = true;
                      _selectedItemName = null;
                    } else {
                      _isOther = false;
                      _selectedItemName = val;
                    }
                  });
                },
                validator: (val) {
                  if (!_isOther && (val == null || val.isEmpty)) {
                    return 'Wajib pilih nama bahan';
                  }
                  return null;
                },
              ),
              if (_isOther)
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                      labelText: "Nama Bahan (baru)"),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Wajib diisi' : null,
                ),
              TextFormField(
                controller: _itemQtyController,
                decoration: const InputDecoration(labelText: "Jumlah Stok"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final namaItem = _isOther
                        ? _itemNameController.text
                        : _selectedItemName!;
                    final newQty = int.tryParse(_itemQtyController.text) ?? 0;
                    final provider =
                    Provider.of<StockProvider>(context, listen: false);
                    final existing = provider.findStockItemByName(namaItem);

                    if (existing != null) {
                      await provider.updateStockItem(
                        idStok: existing.idStok,
                        totalItem: existing.totalItem + newQty,
                      );
                    } else {
                      await provider.addStockItem(
                        namaItem: namaItem,
                        totalItem: newQty,
                        kategori: _selectedCategory,
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Stok berhasil disimpan")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}