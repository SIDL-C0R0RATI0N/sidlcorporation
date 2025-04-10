import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidlcorporation/config/constants.dart';
import 'package:sidlcorporation/data/models/company_info.dart';

class ApiService {
  final bool useMock;

  ApiService({this.useMock = true});

  Future<CompanyInfo> getCompanyInfo() async {
    if (useMock) {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 800));
      return _getMockCompanyInfo();
    }

    try {
      final response = await http.get(Uri.parse(AppConstants.apiBaseUrl));

      if (response.statusCode == 200) {
        return CompanyInfo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de chargement des informations de l\'entreprise');
      }
    } catch (e) {
      // En cas d'erreur, retourner des données par défaut
      return _getMockCompanyInfo();
    }
  }

  CompanyInfo _getMockCompanyInfo() {
    // Données fictives pour les tests
    return CompanyInfo(
      name: 'N/A',
      description: 'N/A',
      logo: '',
      foundedYear: 'N/A',
      location: 'N/A',
      phone: 'N/A',
      email: 'N/A',
      website: 'N/A',
      services: [
        'N/A',
        'N/A',
        'N/A',
        'N/A',
        'N/A',
        'N/A'
      ],
    );
  }
}