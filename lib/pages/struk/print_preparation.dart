import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
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
    _getDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cetak Struk'),
      ),
      body: _isLoading
          ? const CircularProgressIndicator(
              color: AppColors.primary,
            )
          : Center(
              child: Column(
                children: [
                  DropdownButton<BluetoothDevice>(
                    hint: const Text('Pilih Perangkat Printer'),
                    value: _selectedDevice,
                    items: _devices
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name!),
                            ))
                        .toList(),
                    onChanged: (BluetoothDevice? value) async {
                      if (value != null) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          bool? isConnected = await printer.isConnected;
                          if (isConnected == true) {
                            // Jika sudah terhubung, coba putuskan koneksi terlebih dahulu
                            await printer.disconnect();
                          }

                          // Sekarang coba hubungkan ke perangkat baru
                          await printer.connect(value);

                          setState(() {
                            _selectedDevice = value;
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Terhubung ke ${value.name}')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text('Gagal terhubung: ${e.toString()}')),
                            );
                          }
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                      
                        if ((await printer.isConnected)!) {
                          final invoice =
                              await getInvoice(widget.noTransaction);

                          // Cetak menggunakan thermal printer
                          await printReceipt(printer, invoice);

                          await printer.paperCut();
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content:
                                    Text("Perangkat Printer tidak terhubung"),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Terjadi kesalahan: $e"),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Cetak Struk"),
                  ),
                  _selectedDevice != null
                      ? const Text("Device Printer Selected")
                      : const Text("")
                ],
              ),
            ),
    );
  }

  void _getDevices() async {
    _devices = await printer.getBondedDevices();
    setState(() {});
  }

  Future<ApiResponse<Invoice>> getInvoice(String noTransaction) async {
    try {
      return await GetInvoiceProvider.getInvoice(noTransaction);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> printReceipt(
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

      // Handle overflow for item name
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
    printer.paperCut(); // Memotong kertas
  }
}
