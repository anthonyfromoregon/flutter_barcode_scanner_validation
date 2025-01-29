import 'dart:async';
import 'package:flutter/services.dart';

enum ScanMode { BARCODE, QR }

class FlutterBarcodeScanner {
  static const MethodChannel _channel =
      const MethodChannel('flutter_barcode_scanner');

  static Future<String> scanBarcode(
    String lineColor,
    String cancelButtonText,
    bool isShowFlashIcon,
    ScanMode scanMode, {
    String? validationPattern,
  }) async {
    if (lineColor.length != 7 || !lineColor.startsWith("#")) {
      throw new FormatException(
          "Invalid lineColor format. It should be a valid hex color of the form #RRGGBB.");
    }

    final String barcodeScanRes = await _channel.invokeMethod('scanBarcode', {
      "lineColor": lineColor,
      "cancelButtonText": cancelButtonText,
      "isShowFlashIcon": isShowFlashIcon,
      "scanMode": scanMode.index,
      "validationPattern": validationPattern,
    });

    return barcodeScanRes;
  }

  static Future<void> getBarcodeStreamReceiver(
      void Function(String) updateListener) async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'updateBarcodeScannerValue') {
        updateListener(call.arguments);
      }
    });
  }
}