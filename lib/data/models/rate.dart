class Rate {
  final String currency;
  final double rate;

  Rate({required this.currency, required this.rate});

  static Rate fromJson(Map<String, dynamic> json) {
    return Rate(currency: json['currency'], rate: json['rate']);
  }

  Map<String, dynamic> toJson() {
    return {"currency": currency, "rate": rate};
  }
}
