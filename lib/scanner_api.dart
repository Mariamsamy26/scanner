import 'dart:async';

import 'package:dio/dio.dart';
import 'package:scanner/product_by_barcode.dart';

class ScannerApi {
  Future<ProductByBarcode?> getProductByBarcode(String barcode) async {
    String url =
        "http://157.180.26.238:10000/get_product_details_by_barcode/$barcode";
    print("mm $url");
    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        ProductByBarcode productByBarcode = ProductByBarcode.fromJson(
          response.data,
        );
        return productByBarcode;
      } else {
        return null;
      }
    } catch (e) {
      throw "ProductByBarcode error $e";
    }
  }
}
