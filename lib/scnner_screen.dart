import 'dart:async';

import 'package:barcode_input_listener/barcode_input_listener.dart';
import 'package:flutter/material.dart';
import 'package:scanner/helpers/application_dimentions.dart';
import 'package:scanner/product_by_barcode.dart';
import 'package:scanner/scanner_api.dart';

class ScnnerScreen extends StatefulWidget {
  const ScnnerScreen({super.key});

  @override
  State<ScnnerScreen> createState() => _ScnnerScreenState();
}

class _ScnnerScreenState extends State<ScnnerScreen> {
  String _scannedBarcode = "";
  late ProductByBarcode productByBarcode;
  bool scannDone = false;
  Timer? _barcodeTimer;
  String _barcodeBuffer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Input Listener')),
      body: BarcodeInputListener(
        useKeyDownEvent: true,
        onBarcodeScanned: (barcode) {
          _barcodeBuffer = barcode;

          _barcodeTimer?.cancel();

          _barcodeTimer = Timer(Duration(milliseconds: 300), () {
            final cleaned = _barcodeBuffer.trim();

            setState(() {
              _scannedBarcode = cleaned;
            });

          });
        },

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scanned Barcode: $_scannedBarcode',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

    if (_scannedBarcode.isNotEmpty)
      FutureBuilder<ProductByBarcode?>(
        future: ScannerApi().getProductByBarcode(_scannedBarcode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
            print("Error: ${snapshot.error}");
          }

          final product = snapshot.data;

          if (product == null) {
            return const Text("pleass try leter");
          }

          if (product.status == 0) {
            return const Text("Sorry, product not found" ,style: TextStyle(color: Colors.pink,fontSize: 20),);
          } else if (product.status == 1) {
            final name = product.data!.isNotEmpty
                ? product.data![0].name ?? "Unnamed product"
                : "No product data";
            return Text("Product found: $name");
          } else {
            return const Text("Unknown product status");
          }
        },
      ),
  ],
          ),
        ),
      ),
    );
  }


}
