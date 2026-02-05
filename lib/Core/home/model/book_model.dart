class BookModel {
  String? id;
  String? name;
  String? description;
  String? authorname;
  String? isbn;
  String? publisher;
  int? publicationYear;
  String? language;
  String? category;
  String? subject;
  int? rate;
  int? rating;
  String? year;
  int? semester;
  int? pages;
  String? pdfUrl;
  String? coverImageUrl;
  String? collegeId;
  int? downloadCount;
  bool? isActive;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  Creator? creator;
  College? college;
  String? pdfAccessUrl;
  int? purchased;
  String? questionPaperUrl;

  BookModel({
    this.id,
    this.name,
    this.description,
    this.authorname,
    this.isbn,
    this.publisher,
    this.publicationYear,
    this.language,
    this.category,
    this.subject,
    this.rate,
    this.rating,
    this.year,
    this.semester,
    this.pages,
    this.pdfUrl,
    this.coverImageUrl,
    this.collegeId,
    this.downloadCount,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.creator,
    this.college,
    this.pdfAccessUrl,
    this.purchased,
    this.questionPaperUrl,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    authorname = json['authorname'];
    isbn = json['isbn'];
    publisher = json['publisher'];
    publicationYear = json['publication_year'];
    language = json['language'];
    category = json['category'];
    subject = json['subject'];
    rate = json['rate'];
    rating = json['rating'];
    year = json['year'];
    semester = json['semester'];
    pages = json['pages'];
    pdfUrl = json['pdf_access_url'];
    coverImageUrl = json['cover_image_access_url'];
    collegeId = json['college_id'];
    downloadCount = json['download_count'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    creator = json['creator'] != null
        ? new Creator.fromJson(json['creator'])
        : null;
    college = json['college'] != null
        ? new College.fromJson(json['college'])
        : null;
    pdfAccessUrl = json['pdf_access_url'];
    purchased = json['purchased'];
    questionPaperUrl = json['question_paper_access_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['authorname'] = this.authorname;
    data['isbn'] = this.isbn;
    data['publisher'] = this.publisher;
    data['publication_year'] = this.publicationYear;
    data['language'] = this.language;
    data['category'] = this.category;
    data['subject'] = this.subject;
    data['rate'] = this.rate;
    data['year'] = this.year;
    data['semester'] = this.semester;
    data['pages'] = this.pages;
    data['pdf_url'] = this.pdfUrl;
    data['cover_image_access_url'] = this.coverImageUrl;
    data['college_id'] = this.collegeId;
    data['download_count'] = this.downloadCount;
    data['is_active'] = this.isActive;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.college != null) {
      data['college'] = this.college!.toJson();
    }
    data['pdf_access_url'] = this.pdfAccessUrl;
    data['question_paper_access_url'] = this.questionPaperUrl;
    return data;
  }
}

class Creator {
  String? id;
  String? fullName;
  String? email;

  Creator({this.id, this.fullName, this.email});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    return data;
  }
}

class College {
  String? id;
  String? name;
  String? code;

  College({this.id, this.name, this.code});

  College.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}
