import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:blue_print_pos/blue_print_pos.dart';


class prindapur extends StatefulWidget {
  final String order_no;

  const prindapur({super.key, required this.order_no});


  @override
  State<prindapur> createState() => _prindapur();
}

class _prindapur extends State<prindapur> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? pesanan;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice? selectedPrinter;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPesanan();
    initPrinter();
  }

  Future<void> fetchPesanan() async {
    try {
      final response = await supabase
          .from('history_kasir')
          .select('order_no, nama_pelanggan, items, nomor_meja, created_at')
          .eq('order_no', widget.order_no)
          .maybeSingle();

      setState(() {
        pesanan = response;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  Future<void> initPrinter() async {
    try {
      final devices = await bluetooth.getBondedDevices();
      if (devices.isNotEmpty) {
        setState(() {
          selectedPrinter = devices.first;
        });
      }
    } catch (e) {
      debugPrint("Printer error: $e");
    }
  }

  Future<void> printStruk() async {
    try {
      if (!(await bluetooth.isConnected ?? false)) {
        if (selectedPrinter != null) {
          await bluetooth.connect(selectedPrinter!);
          await Future.delayed(const Duration(seconds: 2));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada printer yang dipilih')),
          );
          return;
        }
      }

      final isConnected = await bluetooth.isConnected;
      debugPrint("Status koneksi printer: $isConnected");

      if (isConnected ?? false) {
        bluetooth.printNewLine();
        bluetooth.printCustom("== STRUK PESANAN ==", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("Order No: ${pesanan!['order_no']}", 1, 0);
        bluetooth.printCustom("Tanggal: ${pesanan!['created_at']}", 1, 0);
        bluetooth.printCustom("Meja: ${pesanan!['nomor_meja']}", 1, 0);
        bluetooth.printCustom("Pelanggan: ${pesanan!['nama_pelanggan']}", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("--- ITEMS ---", 1, 0);

        final items = pesanan!['items'] as List<dynamic>;
        for (var item in items) {
          final qty = (item['qty'] as num).toInt();
          final namaMenu = item['nama_menu'];
          bluetooth.printCustom("$qty x $namaMenu", 1, 0);
        }

        bluetooth.printNewLine();
        bluetooth.printCustom("=== Terima Kasih ===", 1, 1);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printer belum terkoneksi')),
        );
      }
    } catch (e) {
      debugPrint("Gagal mencetak: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak struk: $e')),
      );
    }
  }

  Future<void> updateStatusDanCetak() async {
    try {
      await supabase
          .from('history_kasir')
          .update({'status': 'mantab'})
          .eq('order_no', widget.order_no);

      await printStruk();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status diupdate dan struk dicetak')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update atau cetak: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailItems = (pesanan?['items'] is List)
        ? pesanan!['items'] as List<dynamic>
        : null;

    int jumlahItem = 0;
    int subtotal = 0;

    if (detailItems != null) {
      for (var item in detailItems) {
        final quantity = (item['qty'] ?? 0) as num;
        final price = (item['harga'] ?? 0) as num;
        jumlahItem += quantity.toInt();
        subtotal += price.toInt() * quantity.toInt();
      }
    }

    final ppn = (subtotal * 0.10).round();
    final totalPembayaran = subtotal + ppn;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Detail Pesanan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pesanan == null
          ? const Center(child: Text('Data pesanan tidak ditemukan'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Informasi Pemesanan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Nomor Order: ${pesanan!['order_no'] ?? '-'}'),
            const SizedBox(height: 16),
            const Text('Daftar Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(flex: 4, child: Text('Nama Menu', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Harga', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text('Total', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            if (detailItems != null)
              ...detailItems.map((item) {
                final itemName = item['nama_menu'] ?? '-';
                final quantity = (item['qty'] ?? 0) as num;
                final price = (item['harga'] ?? 0) as num;
                final total = price.toInt() * quantity.toInt();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 4, child: Text(itemName)),
                      Expanded(flex: 2, child: Text(quantity.toInt().toString())),
                      Expanded(flex: 2, child: Text('Rp${price.toInt()}', textAlign: TextAlign.end)),
                      Expanded(flex: 3, child: Text('Rp$total', textAlign: TextAlign.end)),
                    ],
                  ),
                );
              }).toList()
            else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tidak ada data menu.'),
              ),
            const SizedBox(height: 16),
            const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jumlah Item :'),
                Text('$jumlahItem'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal :'),
                Text('Rp$subtotal'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PPN 10% :'),
                Text('Rp$ppn'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran :', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Rp$totalPembayaran', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: updateStatusDanCetak,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
//
// class prindapur extends StatefulWidget {
//   final String order_no;
//
//   const prindapur({super.key, required this.order_no});
//
//   @override
//   State<prindapur> createState() => _prindapur();
// }
//
// class _prindapur extends State<prindapur> {
//   final supabase = Supabase.instance.client;
//   Map<String, dynamic>? pesanan;
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   BluetoothDevice? selectedPrinter;
//
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPesanan();
//     ambilData();
//     initPrinter();
//   }
//   Future<void> initPrinter() async {
//     try {
//       final devices = await bluetooth.getBondedDevices();
//       if (devices.isNotEmpty) {
//         setState(() {
//           selectedPrinter = devices.first;
//         });
//       }
//     } catch (e) {
//       debugPrint("Printer error: $e");
//     }
//   }
//
//   Future<void> ambilData() async {
//     final data = await supabase
//         .from('history_kasir')
//         .select('order_no, nama_pelanggan, items, nomor_meja, created_at')
//         .eq('order_no', widget.order_no)
//         .single();
//
//     setState(() {
//       pesanan = data;
//     });
//   }
//
//   Future<void> fetchPesanan() async {
//     try {
//       final response = await supabase
//           .from('history_kasir')
//           .select('order_no, nama_pelanggan, items')
//           .eq('order_no', widget.order_no)
//           .maybeSingle(); // KUNCI: hanya ambil 1 objek Map, bukan List
//
//       setState(() {
//         pesanan = response;
//         loading = false;
//       });
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal memuat data: $e')),
//       );
//     }
//   }
//   Future<void> printStruk() async {
//     try {
//       // Jika belum terhubung, lakukan koneksi
//       if (!(await bluetooth.isConnected ?? false)) {
//         if (selectedPrinter != null) {
//           await bluetooth.connect(selectedPrinter!);
//           await Future.delayed(const Duration(seconds: 2));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Tidak ada printer yang dipilih')),
//           );
//           return;
//         }
//       }
//
//       final isConnected = await bluetooth.isConnected;
//       debugPrint("Status koneksi printer: $isConnected");
//
//       if (isConnected ?? false) {
//         bluetooth.printNewLine();
//         bluetooth.printCustom("== STRUK PESANAN ==", 2, 1);
//         bluetooth.printNewLine();
//         bluetooth.printCustom("Order No: ${pesanan!['order_no']}", 1, 0);
//         bluetooth.printCustom("Tanggal: ${pesanan!['created_at']}", 1, 0);
//         bluetooth.printCustom("Meja: ${pesanan!['nomor_meja']}", 1, 0);
//         bluetooth.printCustom("Pelanggan: ${pesanan!['nama_pelanggan']}", 1, 0);
//         bluetooth.printNewLine();
//         bluetooth.printCustom("--- ITEMS ---", 1, 0);
//
//         final items = pesanan!['items'] as List<dynamic>;
//         for (var item in items) {
//           final qty = (item['qty'] as num).toInt();
//           final namaMenu = item['nama_menu'];
//           bluetooth.printCustom("$qty x $namaMenu", 1, 0);
//         }
//
//         bluetooth.printNewLine();
//         bluetooth.printCustom("=== Terima Kasih ===", 1, 1);
//         bluetooth.printNewLine();
//         bluetooth.paperCut();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Printer belum terkoneksi')),
//         );
//       }
//     } catch (e) {
//       debugPrint("Gagal mencetak: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal mencetak struk: $e')),
//       );
//     }
//   }
//
//   Future<void> updateStatusDanCetak() async {
//     try {
//       await supabase
//           .from('history_kasir')
//           .update({'status': 'mantab'})
//           .eq('order_no', widget.order_no);
//
//       await printStruk();
//
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Status diupdate dan struk dicetak')),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal update atau cetak: $e')),
//       );
//     }
//   }
//
//   // Future<void> fetchPesanan() async {
//   //   try {
//   //     final data = await supabase
//   //         .from('history_kasir')
//   //         .select('order_no, nama_pelanggan, items')
//   //         .eq('order_no', widget.order_no)
//   //         ;
//   //
//   //
//   //     setState(() {
//   //       // pesanan = data;
//   //       loading = false;
//   //     });
//   //   } catch (e) {
//   //     setState(() => loading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Gagal memuat data: $e')),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final detailItems = (pesanan?['items'] is List)
//         ? pesanan!['items'] as List<dynamic>
//         : null;
//
//     int jumlahItem = 0;
//     int subtotal = 0;
//
//     if (detailItems != null) {
//       for (var item in detailItems) {
//         final quantity = (item['qty'] ?? 0) as int;
//         final price = (item['harga'] ?? 0) as int;
//         jumlahItem += quantity;
//         subtotal += price * quantity;
//       }
//     }
//
//     final ppn = (subtotal * 0.10).round();
//     final totalPembayaran = subtotal + ppn;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text('Detail Pesanan', style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : pesanan == null
//           ? const Center(child: Text('Data pesanan tidak ditemukan'))
//           : Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             const Text('Informasi Pemesanan', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text('Nomor Order: ${pesanan!['order_no'] ?? '-'}'),
//             const SizedBox(height: 16),
//             const Text('Daftar Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//               color: Colors.grey[300],
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Expanded(flex: 4, child: Text('Nama Menu', style: TextStyle(fontWeight: FontWeight.bold))),
//                   Expanded(flex: 2, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
//                   Expanded(flex: 2, child: Text('Harga', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
//                   Expanded(flex: 3, child: Text('Total', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//               ),
//             ),
//             const Divider(height: 1, thickness: 1),
//             if (detailItems != null)
//               ...detailItems.map((item) {
//                 final itemName = item['nama_menu'] ?? '-';
//                 final quantity = item['qty'] ?? 0;
//                 final price = item['harga'] ?? 0;
//                 final total = price * quantity;
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(flex: 4, child: Text(itemName)),
//                       Expanded(flex: 2, child: Text(quantity.toString())),
//                       Expanded(flex: 2, child: Text('Rp$price', textAlign: TextAlign.end)),
//                       Expanded(flex: 3, child: Text('Rp$total', textAlign: TextAlign.end)),
//                     ],
//                   ),
//                 );
//               }).toList()
//             else
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('Tidak ada data menu.'),
//               ),
//             const SizedBox(height: 16),
//             const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Jumlah Item :'),
//                 Text('$jumlahItem'),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Subtotal :'),
//                 Text('Rp$subtotal'),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('PPN 10% :'),
//                 Text('Rp$ppn'),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Total Pembayaran :', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text('Rp$totalPembayaran', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton(
//                 onPressed: updateStatusDanCetak,
//                 style:
//                 ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 child: const Text(
//                   'OK',
//                   style: TextStyle(color: Colors.white),
//                 ),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }