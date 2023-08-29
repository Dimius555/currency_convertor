class CurrencyModel {
  final String aplpha3;
  final String name;

  CurrencyModel({required this.aplpha3, required this.name});

  static CurrencyModel fromJson(Map<String, dynamic> json) {
    return CurrencyModel(aplpha3: json['aplpha3'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "aplpha3": aplpha3};
  }
}
