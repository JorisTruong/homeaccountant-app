class Category {
  final int categoryId;
  final String categoryName;
  final int categoryIconId;

  Category({this.categoryId, this.categoryName, this.categoryIconId});

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'category_icon_id': categoryIconId
    };
  }

  @override
  String toString() {
    return 'Category{category_id: $categoryId, category_name: $categoryName, category_icon_id: $categoryIconId}';
  }
}