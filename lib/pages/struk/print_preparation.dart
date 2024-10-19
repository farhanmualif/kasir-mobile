import 'dart:async';

import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/invoice_interface.dart';
import 'package:kasir_mobile/provider/get_invoice_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintPreparation extends StatefulWidget {
  const PrintPreparation({super.key, required this.noTransaction});

  final String noTransaction;

  @override
  State<PrintPreparation> createState() => _PrintPreparationState();
}

class _PrintPreparationState extends State<PrintPreparation> {
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDevices();
    _checkBluetoothStatus();
  }

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }

  Future<void> _checkBluetoothStatus() async {
    bool? isOn = await printer.isOn;
    if (isOn == false) {
      showSnackbar("Bluetooth tidak aktif. Mohon aktifkan Bluetooth.",
          isError: true);
    }
  }

  Future<void> _getDevices() async {
    try {
      if (await _requestLocationPermission(context)) {
        _devices = await printer.getBondedDevices();
        setState(() {});
      } else {
        showSnackbar(
            "Izin lokasi diperlukan untuk memindai perangkat Bluetooth.",
            isError: true);
      }
    } on PlatformException catch (e) {
      if (e.code == 'no_permissions') {
        showSnackbar(
            "Izin lokasi diperlukan untuk memindai perangkat Bluetooth.",
            isError: true);
      } else {
        showSnackbar("Gagal mendapatkan daftar perangkat: ${e.message}",
            isError: true);
      }
    } catch (e) {
      showSnackbar("Gagal mendapatkan daftar perangkat: $e", isError: true);
    }
  }

  Future<ApiResponse<Invoice>> _getInvoice(String noTransaction) async {
    try {
      return await GetInvoiceProvider.getInvoice(noTransaction);
    } catch (e) {
      throw Exception('Gagal mendapatkan invoice: $e');
    }
  }

  static const int maxLineLength = 32;

  String rightAlignText(String label, dynamic value,
      {int width = maxLineLength}) {
    String valueString = value.toString();
    int totalLength = label.length + valueString.length;
    if (totalLength < width) {
      return label + ' ' * (width - totalLength) + valueString;
    } else {
      return label + valueString;
    }
  }

  Future<void> _printReceipt(
      BlueThermalPrinter printer, ApiResponse<Invoice> invoiceData) async {
    try {
      final data = invoiceData.data!;

      await printer.printCustom("Toko Nay", 3, 1);
      await printer.printCustom("Jl. Muncang Raya No. 123", 1, 1);
      await printer.printCustom("Telp: 081234567890", 1, 1);
      await printer.printNewLine();

      await printer.printCustom("No: ${data.noTransaction}", 1, 0);
      await printer.printCustom("Tanggal: ${data.date} ${data.time}", 1, 0);
      await printer.printNewLine();
      await printer.printCustom("Item          Qty  Harga  Total", 1, 0);
      await printer.printCustom("--------------------------------", 1, 0);

      for (var item in data.items) {
        String itemName = item.name.length > 12
            ? item.name.substring(0, 12)
            : item.name.padRight(12);
        String quantity = item.quantity.toString().padLeft(3);
        String itemPrice = item.itemPrice.toString().padLeft(6);
        String totalPrice = item.totalPrice.toString().padLeft(6);
        await printer.printCustom(
            "$itemName $quantity $itemPrice $totalPrice", 1, 0);

        if (item.name.length > 12) {
          await printer.printCustom(item.name.substring(12), 1, 0);
        }
      }

      await printer.printNewLine();
      await printer.printCustom(
          rightAlignText("Sub Total:", data.totalPayment), 1, 0);
      await printer.printCustom(
          rightAlignText("Grand Total:", data.totalPayment), 1, 0);
      await printer.printCustom(rightAlignText("BAYAR:", data.cash), 1, 0);
      await printer.printCustom(
          rightAlignText("KEMBALI:", data.cash - data.totalPayment), 1, 0);
      await printer.printNewLine();
      await printer.printNewLine();
      await printer.printCustom("** Terima kasih atas kunjungan anda **", 1, 1);
      await printer.printNewLine();
      await printer.paperCut();
    } catch (e) {
      throw Exception('Gagal mencetak struk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cetak Struk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _buildPrepare(),
    );
  }

  Widget _buildPrepare() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdownDevicePrinterMenu(),
          const SizedBox(height: 20),
          _printButton(),
          const SizedBox(height: 20),
          if (_selectedDevice != null)
            Text("Device Printer Berhasil Terhubung: ${_selectedDevice!.name}"),
        ],
      ),
    );
  }

  Widget _buildDropdownDevicePrinterMenu() {
    return DropdownButton<BluetoothDevice>(
      hint: const Text('Pilih Perangkat Printer'),
      value: _selectedDevice,
      items: _devices
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name!)))
          .toList(),
      onChanged: (value) => _onDeviceSelected(value),
    );
  }

  Widget _printButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: AppColors.primary,
          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width * 0.5)),
      onPressed: _selectedDevice == null ? null : _printInvoice,
      child: const Text(
        "Cetak Struk",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _onDeviceSelected(BluetoothDevice? value) async {
    if (value == null) return;

    setState(() => _isLoading = true);

    try {
      if (!await _requestLocationPermission(context)) {
        throw Exception(
            "Izin lokasi diperlukan untuk menghubungkan ke printer Bluetooth.");
      }

      bool? isOn = await printer.isOn;
      if (isOn == false) {
        throw Exception("Bluetooth tidak aktif. Mohon aktifkan Bluetooth.");
      }

      bool? isAvailable = await printer.isAvailable;
      if (isAvailable == false) {
        throw Exception("Perangkat printer tidak tersedia");
      }

      if (await printer.isConnected == true) {
        await printer.disconnect();
      }

      bool? connected =
          await printer.connect(value).timeout(const Duration(seconds: 10));
      if (connected == true) {
        setState(() => _selectedDevice = value);
        showSnackbar('Terhubung ke ${value.name}');
      } else {
        throw Exception(
            'Gagal terhubung ke printer. Pastikan printer menyala dan dalam jangkauan.');
      }
    } on TimeoutException {
      throw Exception('Gagal terhubung ke printer. Waktu habis.');
    } on PlatformException catch (e) {
      if (e.code == 'no_permissions') {
        throw Exception(
            'Izin lokasi diperlukan untuk menghubungkan ke printer Bluetooth.');
      } else if (e.code == 'connect_error' ||
          e.message?.contains('read failed, socket might closed or timeout') ==
              true) {
        throw Exception(
            'Gagal terhubung ke printer. Pastikan printer menyala dan dalam jangkauan.');
      } else {
        throw Exception('Terjadi kesalahan: ${e.message}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _printInvoice() async {
    setState(() => _isLoading = true);

    try {
      bool? isOn = await printer.isOn;
      if (isOn != true) {
        throw Exception('Bluetooth tidak aktif. Mohon aktifkan Bluetooth.');
      }

      bool? isAvailable = await printer.isAvailable;
      if (isAvailable != true) {
        throw Exception('Perangkat printer tidak tersedia.');
      }

      bool? isConnected = await printer.isConnected;
      if (isConnected != true) {
        throw Exception(
            'Perangkat Printer tidak terhubung. Silakan hubungkan terlebih dahulu.');
      }

      final invoice = await _getInvoice(widget.noTransaction);
      if (invoice.data == null) {
        throw Exception('Data invoice tidak ditemukan.');
      }

      await _printReceipt(printer, invoice);
      showSnackbar('Struk berhasil dicetak');
    } on PlatformException catch (e) {
      if (e.code == 'print_error') {
        showSnackbar('Gagal mencetak: ${e.message}', isError: true);
      } else {
        showSnackbar('Terjadi kesalahan platform: ${e.message}', isError: true);
      }
    } on TimeoutException {
      showSnackbar('Waktu habis saat mencetak. Coba lagi.', isError: true);
    } on Exception catch (e) {
      showSnackbar(e.toString(), isError: true);
    } catch (e) {
      showSnackbar('Terjadi kesalahan tidak terduga: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (status.isPermanentlyDenied) {
        // Jika pengguna menolak izin secara permanen, buka pengaturan aplikasi
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Izin Lokasi Diperlukan'),
              content: const Text(
                  'Izin lokasi diperlukan untuk memindai perangkat Bluetooth. Buka pengaturan untuk mengaktifkan izin?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Buka Pengaturan'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                ),
              ],
            ),
          );
          return false;
        }
      }
    }
    return status.isGranted;
  }
}
