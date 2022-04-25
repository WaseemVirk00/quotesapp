class MainCategories {
  MainCategories({
    required this.item_names,
    required this.item_index,
    required this.subcategoryItem,
  });

  String item_names;
  int item_index;
  List<SubcategoryItem> subcategoryItem;

  Map<String, dynamic> toMap() {
    return {
      'item_names': this.item_names,
      'subcategoryItem': this.subcategoryItem,
    };
  }

  factory MainCategories.fromMap(Map<String, dynamic> map) {
    return MainCategories(
      item_names: map['item_names'] as String,
      item_index: map['item_index'] as int,
      subcategoryItem: map['subcategoryItem'] as List<SubcategoryItem>,
    );
  }
}

class SubcategoryItem {
  SubcategoryItem({
    required this.sub_item_quote,
    required this.sub_item_author,
    required this.sub_item_index,
  });

  String sub_item_quote;
  String sub_item_author;
  int sub_item_index;
}

class CategoriesList {
  List<MainCategories> items;

  CategoriesList({required this.items});
}
