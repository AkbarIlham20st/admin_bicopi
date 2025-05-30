import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../services/stock_service.dart';

class StockProvider with ChangeNotifier {
  final StockService _service = StockService();
  List<StockModel> _stocks = [];

  List<StockModel> get stocks => _stocks;

  List<StockModel> getItemsByCategory(String category) {
    return _stocks.where((item) => item.category == category).toList();
  }

  Future<void> fetchStocks() async {
    try {
      print('[DEBUG] Fetching stok...');
      final results = await StockService().fetchStocks();
      _stocks = results; // ✅ BUKAN satu object
      notifyListeners();
    } catch (e) {
      print('[ERROR] fetchStocks: $e');
    }
  }
}