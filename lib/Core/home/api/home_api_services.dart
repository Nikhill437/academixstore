import 'dart:developer';

import 'package:academixstore/Core/home/model/book_model.dart';
import 'package:academixstore/Core/network/api_service.dart';
import 'package:academixstore/enum.dart';
import 'package:flutter/material.dart';

class HomeApiServices extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State management properties
  List<BookModel> _allBooks = [];
  OperationStatus _booksStatus = OperationStatus.ideal;

  // Getters
  List<BookModel> get allBooks => _allBooks;
  OperationStatus get booksStatus => _booksStatus;

  String? razorpayApiKey;
  String? razorpaySecretKey;
  // Fetch books method with proper state management
  Future<void> getBooks() async {
    try {
      // Set loading state
      _booksStatus = OperationStatus.loading;
      notifyListeners();

      final response = await _apiService.get('books');

      // 🔐 Safety checks
      if (response.data == null || response.data is! Map<String, dynamic>) {
        _booksStatus = OperationStatus.failure;
        _allBooks = [];
        notifyListeners();
        return;
      }

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        _booksStatus = OperationStatus.failure;
        _allBooks = [];
        notifyListeners();
        return;
      }

      final data = responseData['data'];
      if (data == null || data is! Map<String, dynamic>) {
        _booksStatus = OperationStatus.failure;
        _allBooks = [];
        notifyListeners();
        return;
      }

      final books = data['books'];
      if (books == null || books is! List) {
        _booksStatus = OperationStatus.failure;
        _allBooks = [];
        notifyListeners();
        return;
      }

      // Successfully parsed books
      _allBooks = books
          .map((book) => BookModel.fromJson(book as Map<String, dynamic>))
          .toList();
      _booksStatus = OperationStatus.success;
      notifyListeners();
    } catch (e, stackTrace) {
      log("Error fetching books: $e");
      log("StackTrace: $stackTrace");
      _booksStatus = OperationStatus.failure;
      _allBooks = [];
      notifyListeners();
    }
  }

  // Future<void> getCredentials() async {
  //   // Simulate network delay
  //   await Future.delayed(const Duration(milliseconds: 300));

  //   // STATIC APP - Mock credentials (not real)

  //   // COMMENTED FOR STATIC APP
  //   try {
  //     final res = await database.listDocuments(
  //       databaseId: databaseId,
  //       collectionId: '681f70ae003ce59a28d8',
  //     );

  //     for (final doc in res.documents) {
  //       final key = doc.data['key'];
  //       final value = doc.data['value'];

  //       if (key == 'razorpay-api-key') razorpayApiKey = value;
  //       if (key == 'razorpay-secret-key') razorpaySecretKey = value;
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     razorpayApiKey = null;
  //     razorpaySecretKey = null;
  //     notifyListeners();
  //   }

  //   notifyListeners();
  // }

  // Method to reset state if needed
  void resetState() {
    _allBooks = [];
    _booksStatus = OperationStatus.ideal;
    notifyListeners();
  }
}
