import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pedidos_csc_app/services/api_service.dart';

class PaymentsProvider with ChangeNotifier {
  bool loadingHistory = true;
  List<dynamic> paymentsHistory = [];
  Future<List<int>> availableOrders() async {
    final resp = await UchipAPIService.get('payments/orders');
    if (resp != null && resp['status'] == "success") {
      return resp['orders'].map<int>((order) => order['id'] as int).toList();
    }
    return [];
  }

  Future<dynamic> send(Map<String, dynamic> paymentData) async {
    final resp =
        await UchipAPIService.postWithFiles(paymentData, 'payments/notify');
    if (resp != null && resp['status'] == "success") {
      return true;
    }
    return resp != null && resp!['error']
        ? resp!['error']
        : 'Error desconocido';
  }

  Future<void> history() async {
    loadingHistory = true;
    //notifyListeners();
    final resp = await UchipAPIService.get('payments/list');
    if (resp != null && resp['status'] == "success") {
      paymentsHistory = resp['payments']
          .cast<Map<dynamic, dynamic>>()
          .map((item) => Map<dynamic, dynamic>.from(item))
          .toList();
    }
    loadingHistory = false;
    notifyListeners();
  }
}
