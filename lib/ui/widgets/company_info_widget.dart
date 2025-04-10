import 'package:flutter/cupertino.dart';
import 'package:sidlcorporation/data/models/company_info.dart';
import 'package:sidlcorporation/ui/widgets/blur_card.dart';

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
        Text(
          'À propos de nous',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CupertinoTheme.of(context).textTheme.textStyle.color,
          ),
        ),
        const SizedBox(height: 16),

        // Coordonnées de l'entreprise
        BlurCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coordonnées',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoTheme.of(context).textTheme.textStyle.color,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  icon: CupertinoIcons.location_solid,
                  title: 'Adresse',
                  value: companyInfo.location,
                ),
                _buildInfoRow(
                  context,
                  icon: CupertinoIcons.phone_fill,
                  title: 'Téléphone',
                  value: companyInfo.phone,
                ),
                _buildInfoRow(
                  context,
                  icon: CupertinoIcons.mail_solid,
                  title: 'Email',
                  value: companyInfo.email,
                ),
                _buildInfoRow(
                  context,
                  icon: CupertinoIcons.calendar,
                  title: 'Fondée en',
                  value: companyInfo.foundedYear,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Services
        if (companyInfo.services.isNotEmpty) ...[
          Text(
            'Nos services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).textTheme.textStyle.color,
            ),
          ),
          const SizedBox(height: 16),
          BlurCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: companyInfo.services.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: CupertinoTheme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            service,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
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
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: CupertinoTheme.of(context).primaryColor,
            size: 20,
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}