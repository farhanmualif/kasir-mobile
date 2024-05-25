import 'package:flutter/material.dart';

showSnackbar(bool response, BuildContext context,
    {String message = 'Terjadi kesalahan'}) {
  if (!response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Berhasil update'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
