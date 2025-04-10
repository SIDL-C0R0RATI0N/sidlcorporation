import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidlcorporation/config/constants.dart';
import 'package:sidlcorporation/data/models/company_info.dart';

class ApiService {
  Future<CompanyInfo> getCompanyInfo() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.apiBaseUrl}company-info'));

      if (response.statusCode == 200) {
        return CompanyInfo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de chargement des informations de l\'entreprise');
      }
    } catch (e) {
      // En cas d'erreur, retourner des données par défaut
      return CompanyInfo(
        name: 'SIDL CORPORATION',
        description: 'Une entreprise innovante dans le domaine technologique.',
        logo: '',
        foundedYear: '2020',
        location: 'Paris, France',
        phone: '+33 1 23 45 67 89',
        email: 'contact@sidl-corporation.fr',
        website: 'https://www.sidl-corporation.fr',
        services: [
          'Développement logiciel',
          'Conseil en technologie',
          'Services cloud',
          'Intelligence artificielle'
        ],
      );
    }
  }
}