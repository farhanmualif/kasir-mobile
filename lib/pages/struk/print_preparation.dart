import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/invoice_interface.dart';
import 'package:kasir_mobile/provider/get_invoice_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

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
    _devices = await printer.getBondedDevices();
    setState(() {});
  }

  Future<ApiResponse<Invoice>> _getInvoice(String noTransaction) async {
    try {
      return await GetInvoiceProvider.getInvoice(noTransaction);
    } catch (e) {
      throw Exception('Failed to get invoice: $e');
    }
  }

  Future<void> _printReceipt(
      BlueThermalPrinter printer, ApiResponse<Invoice> invoiceData) async {
    final data = invoiceData.data!;

    printer.printCustom("Toko Nay", 3, 1);
    printer.printCustom("Jl. Muncang Raya No. 123", 1, 1);
    printer.printCustom("Telp: 081234567890", 1, 1);
    printer.printNewLine();

    printer.printCustom("No: ${data.noTransaction}", 1, 0);
    printer.printCustom("Tanggal: ${data.date} ${data.time}", 1, 0);
    printer.printNewLine();
    printer.printCustom("Item          Qty  Harga  Total", 1, 0);
    printer.printCustom("--------------------------------", 1, 0);

    for (var item in data.items) {
      String itemName = item.name.length > 12
          ? item.name.substring(0, 12)
          : item.name.padRight(12);
      String quantity = item.quantity.toString().padLeft(3);
      String itemPrice = item.itemPrice.toString().padLeft(6);
      String totalPrice = item.totalPrice.toString().padLeft(6);
      printer.printCustom("$itemName $quantity $itemPrice $totalPrice", 1, 0);

      if (item.name.length > 12) {
        printer.printCustom(item.name.substring(12), 1, 0);
      }
    }

    printer.printNewLine();
    printer.printCustom("Sub Total: ${data.totalPayment}", 1, 0);
    printer.printCustom("Grand Total: ${data.totalPayment}", 1, 0);
    printer.printCustom("BAYAR: ${data.cash}", 1, 0);
    printer.printCustom("KEMBALI: ${data.cash - data.totalPayment}", 1, 0);
    printer.printNewLine();
    printer.printCustom("** Terima kasih atas kunjungan anda **", 1, 1);
    printer.printNewLine();
    await printer.paperCut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cetak Struk'),
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
            Text("Device Printer Selected: ${_selectedDevice!.name}"),
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
      onPressed: _selectedDevice == null ? null : _printInvoice,
      child: const Text("Cetak Struk"),
    );
  }

  Future<void> _onDeviceSelected(BluetoothDevice? value) async {
    if (value == null) return;

    setState(() => _isLoading = true);

    try {
      bool? isOn = await printer.isOn;
      if (isOn == false) {
        showSnackbar("Bluetooth tidak aktif. Mohon aktifkan Bluetooth.",
            isError: true);
        return;
      }

      bool? isAvailable = await printer.isAvailable;
      if (isAvailable == false) {
        showSnackbar("Perangkat printer tidak tersedia", isError: true);
        return;
      }

      // Check if the printer is already connected
      if (await printer.isConnected == true) {
        await printer.disconnect();
      }

      // Try to connect to the printer
      try {
        bool? connected = await printer.connect(value);
        if (connected == true) {
          setState(() => _selectedDevice = value);
          showSnackbar('Terhubung ke ${value.name}');
        } else {
          showSnackbar(
              'Gagal terhubung ke printer. Pastikan printer menyala dan dalam jangkauan.',
              isError: true);
        }
      } on PlatformException catch (e) {
        // Handle specific PlatformException for connect_error
        if (e.code == 'connect_error' ||
            e.message
                    ?.contains('read failed, socket might closed or timeout') ==
                true) {
          showSnackbar(
              'Gagal terhubung ke printer. Pastikan printer menyala dan dalam jangkauan.',
              isError: true);
        } else {
          showSnackbar('Terjadi kesalahan: ${e.message}', isError: true);
        }
      }
    } catch (e) {
      showSnackbar('Gagal terhubung: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _printInvoice() async {
    setState(() => _isLoading = true);

    try {
      if (await printer.isConnected == true) {
        final invoice = await _getInvoice(widget.noTransaction);

        if (invoice.data == null) {
          showSnackbar("File tidak ditemukan", isError: true);
          return;
        }

        await _printReceipt(printer, invoice);
        showSnackbar('Struk berhasil dicetak');
      } else {
        showSnackbar("Perangkat Printer tidak terhubung", isError: true);
      }
    } catch (e) {
      if (e.toString().contains('500')) {
        showSnackbar("File tidak ditemukan", isError: true);
      } else {
        showSnackbar("Terjadi kesalahan: $e", isError: true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
