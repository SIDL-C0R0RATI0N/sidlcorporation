import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidlcorporation/data/models/company_info.dart';
import 'package:sidlcorporation/ui/widgets/app_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyInfoWidget extends StatelessWidget {
  final CompanyInfo companyInfo;

  const CompanyInfoWidget({
    Key? key,
    required this.companyInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de section style App Store
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            'À PROPOS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Coordonnées de l'entreprise style App Store
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Logo ou icône
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: CupertinoTheme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'SIDL',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Nom et titre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyInfo.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fondée en ${companyInfo.foundedYear}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                companyInfo.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Coordonnées avec style App Store - rendus cliquables
              _buildInfoRow(
                context,
                icon: CupertinoIcons.location_solid,
                title: 'Adresse',
                value: companyInfo.location,
                onTap: () => _openMaps(companyInfo.location),
              ),
              _buildInfoRow(
                context,
                icon: CupertinoIcons.phone_fill,
                title: 'Téléphone',
                value: companyInfo.phone,
                onTap: () => _callPhone(companyInfo.phone),
              ),
              _buildInfoRow(
                context,
                icon: CupertinoIcons.mail_solid,
                title: 'Email',
                value: companyInfo.email,
                onTap: () => _sendEmail(companyInfo.email),
              ),
              _buildInfoRow(
                context,
                icon: CupertinoIcons.globe,
                title: 'Site Web',
                value: companyInfo.website,
                onTap: () => _openUrl(companyInfo.website),
              ),
            ],
          ),
        ),

        // Informations légales
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12, top: 24),
          child: Text(
            'INFORMATIONS LÉGALES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Carte des informations légales
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                icon: CupertinoIcons.number,
                title: 'Numéro SIRET',
                value: companyInfo.siret ?? 'Non disponible',
                onTap: companyInfo.siret != null ? () => _copyToClipboard(context, companyInfo.siret!) : null,
              ),
              _buildInfoRow(
                context,
                icon: CupertinoIcons.chart_bar_alt_fill,
                title: 'Code APE/NAF',
                value: companyInfo.apeCode ?? 'Non disponible',
                onTap: companyInfo.apeCode != null ? () => _copyToClipboard(context, companyInfo.apeCode!) : null,
              ),
              _buildInfoRow(
                context,
                icon: CupertinoIcons.bag_fill,
                title: 'N° TVA',
                value: companyInfo.vatNumber ?? 'Non disponible',
                onTap: companyInfo.vatNumber != null ? () => _copyToClipboard(context, companyInfo.vatNumber!) : null,
              ),
              _buildInfoRow(
                context,
                icon: CupertinoIcons.building_2_fill,
                title: 'N° DUNS',
                value: companyInfo.dunsNumber ?? 'Non disponible',
                onTap: companyInfo.dunsNumber != null ? () => _copyToClipboard(context, companyInfo.dunsNumber!) : null,
                isLast: true,
              ),
            ],
          ),
        ),

        // Titre de section pour les services
        if (companyInfo.services.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12, top: 24),
            child: Text(
              'NOS SERVICES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: CupertinoTheme.of(context).primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Liste des services style App Store
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: companyInfo.services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                final isLast = index == companyInfo.services.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: CupertinoTheme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast) const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        VoidCallback? onTap,
        bool isLast = false,
      }) {
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: CupertinoTheme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: onTap != null ? CupertinoTheme.of(context).primaryColor : null,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 18,
            ),
        ],
      ),
    );

    final Widget rowWidget = Column(
      children: [
        onTap != null
            ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: content,
        )
            : content,
        if (!isLast) const Divider(height: 1),
      ],
    );

    return rowWidget;
  }

  // Méthodes pour les actions
  void _openMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = Uri.parse('https://maps.apple.com/?q=$encodedAddress');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Impossible d\'ouvrir Maps: $url');
    }
  }

  void _callPhone(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Impossible d\'appeler: $url');
    }
  }

  void _sendEmail(String email) async {
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Impossible d\'envoyer un email: $url');
    }
  }

  void _openUrl(String websiteUrl) async {
    final url = Uri.parse(websiteUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print('Impossible d\'ouvrir l\'URL: $url');
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    // Afficher un toast ou une notification
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Copié'),
        content: Text('$text a été copié dans le presse-papiers.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}