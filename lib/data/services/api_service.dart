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
      // Essayer d'abord l'URL complète
      final response = await http.get(Uri.parse(AppConstants.apiBaseUrl));

      // Vérifier le code de statut
      if (response.statusCode == 200) {
        try {
          // Essayer de parser le JSON
          final jsonData = json.decode(response.body);
          return CompanyInfo.fromJson(jsonData);
        } catch (parseError) {
          print('Erreur de parsing JSON: $parseError');
          // Si le JSON ne peut pas être parsé, retourner des données factices
          return _getMockCompanyInfo();
        }
      } else {
        print('Erreur API: Statut ${response.statusCode}');
        throw Exception('Échec de chargement des informations de l\'entreprise');
      }
    } catch (e) {
      // Gérer différents types d'erreurs réseau
      print('Erreur réseau: $e');

      // Si la première URL échoue, essayer une URL alternative
      try {
        final alternativeUrl = '${AppConstants.apiBaseUrlError}';
        final response = await http.get(Uri.parse(alternativeUrl));

        if (response.statusCode == 200) {
          return CompanyInfo.fromJson(json.decode(response.body));
        }
      } catch (alternativeError) {
        print('Erreur avec URL alternative: $alternativeError');
      }

      // En cas d'échec complet, retourner des données factices
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