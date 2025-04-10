class CompanyInfo {
  final String name;
  final String description;
  final String logo;
  final String foundedYear;
  final String location;
  final String phone;
  final String email;
  final String website;
  final List<String> services;
  final String? siret;
  final String? apeCode;
  final String? vatNumber;
  final String? dunsNumber;

  CompanyInfo({
    required this.name,
    required this.description,
    required this.logo,
    required this.foundedYear,
    required this.location,
    required this.phone,
    required this.email,
    required this.website,
    required this.services,
    this.siret,
    this.apeCode,
    this.vatNumber,
    this.dunsNumber,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      foundedYear: json['founded_year'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      siret: json['siret'],
      apeCode: json['ape_code'],
      vatNumber: json['vat_number'],
      dunsNumber: json['duns_number'],
    );
  }
}