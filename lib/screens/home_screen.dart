import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sidlcorporation/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIDL CORPORATION'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Action pour les notifications
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'SIDL CORPORATION',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Votre slogan ici',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // À propos
              const Text(
                'À propos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                'Notre mission',
                'Description de la mission de SIDL CORPORATION...',
                Icons.lightbulb_outline,
              ),
              const SizedBox(height: 16),

              // Services
              const Text(
                'Nos services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                'Service 1',
                'Description du service 1...',
                Icons.business_center_outlined,
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                context,
                'Service 2',
                'Description du service 2...',
                Icons.assessment_outlined,
              ),
              const SizedBox(height: 24),

              // Contact
              const Text(
                'Contact',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                'Coordonnées',
                'Email: contact@sidl-corporation.fr\nTéléphone: +33 X XX XX XX XX',
                Icons.contact_mail_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour créer un card d'information (remplace CompanyInfoCard)
  Widget _buildInfoCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}