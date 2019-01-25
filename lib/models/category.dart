class Category {
  String name = "";
  String icone = "";
  Category.fromJson(Map<String, dynamic> json)
      : name = json['nom'],
        icone = json['icone'];
}
