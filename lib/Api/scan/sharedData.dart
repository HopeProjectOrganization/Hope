class ScanDataService {
  static final ScanDataService _instance = ScanDataService._internal();

  factory ScanDataService() => _instance;

  ScanDataService._internal();

  Map<String, dynamic> scannedProduct = {};
  List<Map<String, dynamic>> highRiskIngredients = [];
}
