import 'dart:developer';
import 'package:academixstore/Core/bookmarks/model/pruchase_book_model.dart';
import 'package:academixstore/Core/network/api_service.dart';
import 'package:flutter/material.dart';

class PurchaseBookApiService with ChangeNotifier {
  final ApiService _apiService = ApiService();

  PurchasedBookDataModel? _purchasedBookData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  PurchasedBookDataModel? get purchasedBookData => _purchasedBookData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPurchasedBooks({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        'orders/my-purchases?page=$page&limit=$limit&status=paid',
      );

      if (response.statusCode == 200) {
        log("Purchased books fetched successfully: ${response.data}");
        _purchasedBookData = PurchasedBookDataModel.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
      } else {
        log("Failed to fetch purchased books: ${response.message}");
        _errorMessage = response.message ?? "Failed to load books";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("Error getting purchased books: $e");
      _errorMessage = "Error loading books: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  // Optional: Reset state
  void reset() {
    _purchasedBookData = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
