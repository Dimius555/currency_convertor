class CurrencyModel {
  final String alpha3;
  final String name;

  CurrencyModel({required this.alpha3, required this.name});

  static CurrencyModel fromJson(Map<String, dynamic> json) {
    return CurrencyModel(alpha3: json['aplpha3'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "aplpha3": alpha3};
  }
}
