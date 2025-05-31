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
  final TextEditingController _menuNameController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQtyController = TextEditingController();
  String _selectedCategory = 'Food';

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
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: "Nama Bahan"),
                validator: (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _itemQtyController,
                decoration: const InputDecoration(labelText: "Jumlah Stok"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newItem = StockModel(
                      idMenu: UniqueKey().toString(),
                      name: _menuNameController.text,
                      category: _selectedCategory,
                      menuStok: [
                        StockItem(
                          idStok: UniqueKey().toString(),
                          namaItem: _itemNameController.text,
                          totalItem: int.parse(_itemQtyController.text),
                        )
                      ],
                    );

                    Provider.of<StockProvider>(context, listen: false).addStock(newItem);
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
