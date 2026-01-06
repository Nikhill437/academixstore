// EXAMPLE: How to use the API service in your modules

import 'api_service.dart';
import 'api_response.dart';

// Example 1: Simple GET request
class BookService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<dynamic>>> getBooks() async {
    return await _apiService.get(
      '/books',
      queryParameters: {'limit': 10},
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getBookById(String id) async {
    return await _apiService.get('/books/$id');
  }
}

// Example 2: POST request with data
class AuthService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return await _apiService.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _apiService.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }
}

// Example 3: Using with model classes
class Book {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
    );
  }
}

class BookServiceWithModel {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<Book>> getBookById(String id) async {
    return await _apiService.get(
      '/books/$id',
      fromJson: (data) => Book.fromJson(data),
    );
  }

  Future<ApiResponse<List<Book>>> getAllBooks() async {
    return await _apiService.get(
      '/books',
      fromJson: (data) {
        final List<dynamic> bookList = data['books'];
        return bookList.map((json) => Book.fromJson(json)).toList();
      },
    );
  }
}

// Example 4: Using in a ViewModel/Provider
class BookViewModel {
  final BookService _bookService = BookService();
  
  List<dynamic> books = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchBooks() async {
    isLoading = true;
    errorMessage = null;
    
    final response = await _bookService.getBooks();
    
    if (response.isSuccess) {
      books = response.data ?? [];
    } else {
      errorMessage = response.message;
    }
    
    isLoading = false;
  }
}
