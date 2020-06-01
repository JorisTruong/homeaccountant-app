class Subcategory {
  final int subcategoryId;
  final int categoryId;
  final String subcategoryName;
  final int subcategoryIconId;

  Subcategory({this.subcategoryId, this.categoryId, this.subcategoryName, this.subcategoryIconId});

  Map<String, dynamic> toMap() {
    return {
      'subcategory_id': subcategoryId,
      'category_id': categoryId,
      'subcategory_name': subcategoryName,
      'subcategory_icon_id': subcategoryIconId
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'category_id': categoryId,
      'subcategory_name': subcategoryName,
      'subcategory_icon_id': subcategoryIconId
    };
  }

  @override
  String toString() {
    return 'Subategory{subcategory_id: $subcategoryId, category_id: $categoryId, subcategory_name: $subcategoryName, subcategory_icon_id: $subcategoryIconId}';
  }
}