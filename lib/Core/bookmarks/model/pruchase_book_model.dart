class PurchasedBookDataModel {
  bool? success;
  Data? data;

  PurchasedBookDataModel({this.success, this.data});

  PurchasedBookDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class Data {
  List<Purchase>? purchases;
  Pagination? pagination;

  Data({this.purchases, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['purchases'] != null) {
      purchases = <Purchase>[];
      json['purchases'].forEach((v) {
        purchases!.add(Purchase.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (purchases != null) {
      map['purchases'] = purchases!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class Purchase {
  String? id;
  Book? book;
  String? amount;
  String? currency;
  String? status;
  String? paymentMethod;
  String? purchasedAt;
  String? razorpayOrderId;
  String? razorpayPaymentId;

  Purchase({
    this.id,
    this.book,
    this.amount,
    this.currency,
    this.status,
    this.paymentMethod,
    this.purchasedAt,
    this.razorpayOrderId,
    this.razorpayPaymentId,
  });

  Purchase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    book = json['book'] != null ? Book.fromJson(json['book']) : null;
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    purchasedAt = json['purchased_at'];
    razorpayOrderId = json['razorpay_order_id'];
    razorpayPaymentId = json['razorpay_payment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    if (book != null) {
      map['book'] = book!.toJson();
    }
    map['amount'] = amount;
    map['currency'] = currency;
    map['status'] = status;
    map['payment_method'] = paymentMethod;
    map['purchased_at'] = purchasedAt;
    map['razorpay_order_id'] = razorpayOrderId;
    map['razorpay_payment_id'] = razorpayPaymentId;
    return map;
  }
}

class Book {
  String? id;
  String? name;
  String? authorname;
  String? description;
  String? category;
  String? subject;
  String? language;
  String? year;
  int? semester;
  int? pages;
  int? rating;
  String? coverImageUrl;
  String? pdfAccessUrl;
  int? purchased;
  // Convenience getters for UI
  String get title => name ?? 'Unknown Title';
  String get author => authorname ?? 'Unknown Author';
  String get pdfFileUrl => pdfAccessUrl ?? '';

  Book({
    this.id,
    this.name,
    this.authorname,
    this.description,
    this.category,
    this.subject,
    this.language,
    this.year,
    this.semester,
    this.pages,
    this.rating,
    this.coverImageUrl,
    this.pdfAccessUrl,
    this.purchased,
  });

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    authorname = json['authorname'];
    description = json['description'];
    category = json['category'];
    subject = json['subject'];
    language = json['language'];
    year = json['year'];
    semester = json['semester'];
    pages = json['pages'];
    rating = json['rating'];
    coverImageUrl = json['cover_image_access_url'];
    pdfAccessUrl = json['pdf_access_url'];
    purchased = json['purchased'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['authorname'] = authorname;
    map['description'] = description;
    map['category'] = category;
    map['subject'] = subject;
    map['language'] = language;
    map['year'] = year;
    map['semester'] = semester;
    map['pages'] = pages;
    map['rating'] = rating;
    map['cover_image_access_url'] = coverImageUrl;
    map['pdf_access_url'] = pdfAccessUrl;
    map['purchased'] = purchased;
    return map;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    return map;
  }
}
