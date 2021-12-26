class CoinData {
  final DateTime? time;
  final String base;
  final String quote;
  final double rate;

  CoinData.fromJson(Map<String, dynamic> json)
      : time = DateTime.parse(json['time'] ?? DateTime.now().toString()),
        base = json['asset_id_base'] ?? '',
        quote = json['asset_id_quote'] ?? '',
        rate = json['rate'] ?? 0;
}
