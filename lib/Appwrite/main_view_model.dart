// COMMENTED FOR STATIC APP
// import 'package:academixstore/Appwrite/appwrite_services.dart';
import 'package:academixstore/Core/home/model/book_model.dart';
import 'package:academixstore/Core/home/model/user_book_valid_model.dart';
import 'package:academixstore/Core/home/model/user_profile_model.dart';
import 'package:academixstore/enum.dart';
import 'package:flutter/material.dart';
// import 'package:appwrite/appwrite.dart';

class MainViewModel with ChangeNotifier {
  // COMMENTED FOR STATIC APP
  // final database = AppwriteService.instance.databases;
  // final databaseId = '67cf39320031118f285d';
  // final userProfileCollectionId = '67cf394700328cbf0960';
  // final booksCollectionId = '67cf396a0016a40d59f8';
  // final userBooksCollectionId = '67cf398d0023e70f8f05';

  // final storage = AppwriteService.instance.storage;

  // State variables
  OperationStatus profileStatus = OperationStatus.ideal;
  OperationStatus booksStatus = OperationStatus.ideal;
  OperationStatus userBooksStatus = OperationStatus.ideal;
  OperationStatus purchaseStatus = OperationStatus.ideal;

  List<BookModel> allBooks = [];
  List<BookModel> userBooks = [];

  List<UserBookValidModel> userBookValidateData = [];

  String? razorpayApiKey;
  String? razorpaySecretKey;

  // COMMENTED FOR STATIC APP
  Future<void> createUserProfile(UserProfileModel profile) async {
    profileStatus = OperationStatus.loading;
    notifyListeners();

    // STATIC APP - Simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    profileStatus = OperationStatus.success;

    // COMMENTED FOR STATIC APP
    // try {
    //   final userId = await AppwriteService.instance.getUserId();
    //   if (userId == null) throw Exception("User ID is null");

    //   await database.createDocument(
    //     databaseId: databaseId,
    //     collectionId: userProfileCollectionId,
    //     documentId: userId,
    //     data: {
    //       'name': profile.name,
    //       'phoneNumber': profile.phoneNumber,
    //       'department': profile.department,
    //       'gender': profile.gender,
    //     },
    //   );
    //   profileStatus = OperationStatus.success;
    // } catch (e) {
    //   profileStatus = OperationStatus.failure;
    // }

    notifyListeners();
  }

  // STATIC APP - Using static data instead of API
  Future<void> getAllBooks() async {
    booksStatus = OperationStatus.loading;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // STATIC DATA
    allBooks = [
      //   BookModel(
      //     id: '1',
      //     title: 'Introduction to Algorithms',
      //     author: 'Thomas H. Cormen',
      //     description:
      //         'A comprehensive textbook on computer algorithms. This book provides an in-depth introduction to algorithms and data structures.',
      //     price: 599.0,
      //     coverImageUrl:
      //         'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400',
      //     pdfFileUrl: 'https://example.com/sample.pdf',
      //     categories: ['Computer Science', 'Algorithms'],
      //     publishDate: '2022-01-15',
      //     rating: 5,
      //   ),
      //   BookModel(
      //     id: '2',
      //     title: 'Data Structures and Algorithms',
      //     author: 'Robert Lafore',
      //     description:
      //         'Learn about fundamental data structures and algorithms with practical examples and implementations.',
      //     price: 450.0,
      //     coverImageUrl:
      //         'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400',
      //     pdfFileUrl: 'https://example.com/sample.pdf',
      //     categories: ['Computer Science', 'Programming'],
      //     publishDate: '2021-06-20',
      //     rating: 4,
      //   ),
      //   BookModel(
      //     id: '3',
      //     title: 'Clean Code',
      //     author: 'Robert C. Martin',
      //     description:
      //         'A handbook of agile software craftsmanship. Learn how to write clean, maintainable code.',
      //     price: 399.0,
      //     coverImageUrl:
      //         'https://images.unsplash.com/photo-1589998059171-988d887df646?w=400',
      //     pdfFileUrl: 'https://example.com/sample.pdf',
      //     categories: ['Software Engineering', 'Best Practices'],
      //     publishDate: '2020-03-10',
      //     rating: 5,
      //   ),
      //   BookModel(
      //     id: '4',
      //     title: 'Design Patterns',
      //     author: 'Gang of Four',
      //     description:
      //         'Elements of reusable object-oriented software. Essential reading for software developers.',
      //     price: 550.0,
      //     coverImageUrl:
      //         'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
      //     pdfFileUrl: 'https://example.com/sample.pdf',
      //     categories: ['Software Engineering', 'Design'],
      //     publishDate: '2019-11-05',
      //     rating: 5,
      //   ),
      //   BookModel(
      //     id: '5',
      //     title: 'The Pragmatic Programmer',
      //     author: 'Andrew Hunt',
      //     description:
      //         'Your journey to mastery. A practical guide to becoming a better programmer.',
      //     price: 475.0,
      //     coverImageUrl:
      //         'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400',
      //     pdfFileUrl: 'https://example.com/sample.pdf',
      //     categories: ['Programming', 'Career Development'],
      //     publishDate: '2021-08-12',
      //     rating: 4,
      //   ),
    ];

    booksStatus = OperationStatus.success;

    // COMMENTED FOR STATIC APP
    // try {
    //   final res = await database.listDocuments(
    //     databaseId: databaseId,
    //     collectionId: booksCollectionId,
    //   );

    //   allBooks = res.documents.map((doc) {
    //     final data = doc.data;
    //     return BookModel(
    //       id: doc.$id.toString(),
    //       title: data['title']?.toString() ?? '',
    //       author: data['author']?.toString() ?? '',
    //       description: data['description']?.toString() ?? '',
    //       price: (data['price'] is num)
    //           ? (data['price'] as num).toDouble()
    //           : 0.0,
    //       coverImageUrl: data['coverImageUrl']?.toString() ?? '',
    //       pdfFileUrl: data['pdfFileUrl']?.toString() ?? '',
    //       categories: (data['categories'] as List<dynamic>? ?? [])
    //           .map((e) => e.toString())
    //           .toList(),
    //       publishDate: data['publishDate']?.toString() ?? '',
    //       rating: (data['rating'] is num) ? (data['rating'] as num).toInt() : 0,
    //     );
    //   }).toList();

    //   booksStatus = OperationStatus.success;
    // } catch (e) {
    //   booksStatus = OperationStatus.failure;
    // }

    notifyListeners();
  }

  // STATIC APP - Using static purchased books data
  Future<void> getUserBooks() async {
    userBooksStatus = OperationStatus.loading;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // STATIC DATA - Sample purchased books
    userBookValidateData = [
      UserBookValidModel(
        bookId: '1',
        boughtOn: DateTime.now().millisecondsSinceEpoch,
      ),
      UserBookValidModel(
        bookId: '3',
        boughtOn: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    userBooks = [
      // BookModel(
      //   id: '1',
      //   title: 'Introduction to Algorithms',
      //   author: 'Thomas H. Cormen',
      //   description:
      //       'A comprehensive textbook on computer algorithms. This book provides an in-depth introduction to algorithms and data structures.',
      //   price: 599.0,
      //   coverImageUrl:
      //       'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400',
      //   pdfFileUrl: 'https://example.com/sample.pdf',
      //   categories: ['Computer Science', 'Algorithms'],
      //   publishDate: '2022-01-15',
      //   rating: 5,
      // ),
      // BookModel(
      //   id: '3',
      //   title: 'Clean Code',
      //   author: 'Robert C. Martin',
      //   description:
      //       'A handbook of agile software craftsmanship. Learn how to write clean, maintainable code.',
      //   price: 399.0,
      //   coverImageUrl:
      //       'https://images.unsplash.com/photo-1589998059171-988d887df646?w=400',
      //   pdfFileUrl: 'https://example.com/sample.pdf',
      //   categories: ['Software Engineering', 'Best Practices'],
      //   publishDate: '2020-03-10',
      //   rating: 5,
      // ),
    ];

    userBooksStatus = OperationStatus.success;

    // COMMENTED FOR STATIC APP
    // try {
    //   final userId = await AppwriteService.instance.getUserId();
    //   if (userId == null) {
    //     throw Exception("User ID is null");
    //   }

    //   // Fetch user's purchased books
    //   final purchases = await database.listDocuments(
    //     databaseId: databaseId,
    //     collectionId: userBooksCollectionId,
    //     queries: [Query.equal("userId", userId)],
    //   );

    //   final purchasedModels = purchases.documents.map((doc) {
    //     return UserBookValidModel(
    //       bookId: doc.data['bookId'].toString(), // Convert to string
    //       boughtOn: doc.data['purchaseDate'], // Convert to string if needed
    //     );
    //   }).toList();

    //   userBookValidateData = purchasedModels;

    //   // If no books purchased, set empty list and return
    //   if (purchasedModels.isEmpty) {
    //     userBooks = [];
    //     userBooksStatus = OperationStatus.success;
    //     notifyListeners();
    //     return;
    //   }

    //   // Extract book IDs
    //   final bookIds = purchasedModels.map((e) => e.bookId).toList();

    //   // Fetch book details using the book IDs
    //   final res = await database.listDocuments(
    //     databaseId: databaseId,
    //     collectionId: booksCollectionId,
    //     queries: [Query.equal('\$id', bookIds)],
    //   );

    //   // Map the documents to BookModel objects
    //   userBooks = res.documents.map((doc) {
    //     final data = doc.data;
    //     return BookModel(
    //       id: doc.$id,
    //       title: (data['title'] ?? '').toString(),
    //       author: (data['author'] ?? '').toString(),
    //       description: (data['description'] ?? '').toString(),
    //       price: double.tryParse(data['price'].toString()) ?? 0.0,
    //       coverImageUrl: (data['coverImageUrl'] ?? '').toString(),
    //       pdfFileUrl: (data['pdfFileUrl'] ?? '').toString(),
    //       categories:
    //           (data['categories'] as List<dynamic>?)
    //               ?.map((e) => e.toString())
    //               .toList() ??
    //           [],
    //       publishDate: (data['publishDate'] ?? '').toString(),
    //       rating: int.tryParse(data['rating'].toString()) ?? 0,
    //     );
    //   }).toList();

    //   userBooksStatus = OperationStatus.success;
    //   notifyListeners();
    // } catch (e) {
    //   print('Error fetching user books: $e'); // Add logging for debugging
    //   userBooks = []; // Clear the books list on error
    //   userBooksStatus = OperationStatus.failure;
    //   notifyListeners();
    // }

    notifyListeners();
  }

  // STATIC APP - Simulate book purchase
  Future<void> purchaseBook(String bookId) async {
    purchaseStatus = OperationStatus.loading;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // STATIC APP - Just mark as success
    purchaseStatus = OperationStatus.success;
    await getUserBooks(); // Refresh after purchase

    // COMMENTED FOR STATIC APP
    // try {
    //   final userId = await AppwriteService.instance.getUserId();
    //   if (userId == null) throw Exception("User ID is null");

    //   await database.createDocument(
    //     databaseId: databaseId,
    //     collectionId: userBooksCollectionId,
    //     documentId: ID.unique(),
    //     data: {
    //       'userId': userId,
    //       'bookId': bookId,
    //       'purchaseDate': DateTime.now().millisecondsSinceEpoch,
    //     },
    //   );

    //   purchaseStatus = OperationStatus.success;
    //   await getUserBooks(); // Refresh after purchase
    // } catch (e) {
    //   purchaseStatus = OperationStatus.failure;
    // }

    notifyListeners();
  }

  void resetPurchaseStatus() {
    purchaseStatus = OperationStatus.ideal;
    notifyListeners();
  }

  // STATIC APP - Return mock credentials
  Future<void> getCredentials() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // STATIC APP - Mock credentials (not real)
    razorpayApiKey = 'mock_razorpay_key';
    razorpaySecretKey = 'mock_razorpay_secret';

    // COMMENTED FOR STATIC APP
    // try {
    //   final res = await database.listDocuments(
    //     databaseId: databaseId,
    //     collectionId: '681f70ae003ce59a28d8',
    //   );

    //   for (final doc in res.documents) {
    //     final key = doc.data['key'];
    //     final value = doc.data['value'];

    //     if (key == 'razorpay-api-key') razorpayApiKey = value;
    //     if (key == 'razorpay-secret-key') razorpaySecretKey = value;
    //   }

    //   notifyListeners();
    // } catch (e) {
    //   razorpayApiKey = null;
    //   razorpaySecretKey = null;
    //   notifyListeners();
    // }

    notifyListeners();
  }
}
