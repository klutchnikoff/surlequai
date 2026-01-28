import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

/// Écran "À propos" avec mentions légales et informations sur l'app
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? AppColors.bgDark : AppColors.bgLight;
    final textColor = isDarkMode ? AppColors.textDark : AppColors.textLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('À propos'),
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/Nom de l'app
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.train,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SurLeQuai',
                    style: AppTextStyles.large.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version $_version',
                    style: AppTextStyles.small.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section Éditeur
            _buildSectionTitle('Éditeur', textColor),
            _buildParagraph(
              'SurLeQuai est développée et maintenue par Nicolas Klutchnikoff.\n\n'
              'Contact : nicolas.klutchnikoff@gmail.com',
              textColor,
            ),
            const SizedBox(height: 24),

            // Section Logiciel libre
            _buildSectionTitle('Logiciel libre', textColor),
            _buildParagraph(
              'Cette application est un logiciel libre distribué sous licence MIT. '
              'Le code source est disponible publiquement et chacun est libre de l\'utiliser, '
              'le modifier et le redistribuer selon les termes de cette licence.',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildLinkButton(
              'Voir le code source sur GitHub',
              'https://github.com/klutchnikoff/surlequai',
            ),
            const SizedBox(height: 24),

            // Section Vie privée
            _buildSectionTitle('Respect de votre vie privée', textColor),
            _buildParagraph(
              '• Aucun compte utilisateur requis\n'
              '• Aucune publicité\n'
              '• Aucun tracker ou collecte de données personnelles\n'
              '• Toutes vos données restent sur votre appareil',
              textColor,
            ),
            const SizedBox(height: 24),

            // Section Données SNCF
            _buildSectionTitle('Données ferroviaires', textColor),
            _buildParagraph(
              'Les horaires de trains sont fournis par l\'API SNCF (Navitia.io), '
              'utilisant les données ouvertes de la SNCF sous licence ouverte Etalab 2.0.\n\n'
              'Ces données sont fournies à titre informatif et peuvent comporter des erreurs ou retards.',
              textColor,
            ),
            const SizedBox(height: 24),

            // Section Accès API
            _buildSectionTitle('Accès à l\'API SNCF', textColor),
            _buildParagraph(
              'Par défaut, SurLeQuai utilise un proxy anonyme pour accéder à l\'API SNCF. '
              'Ce proxy ne conserve aucun log et masque votre adresse IP à la SNCF.\n\n'
              'Si vous préférez faire confiance directement à la SNCF, vous pouvez utiliser '
              'votre propre clé API (BYOK - Bring Your Own Key) dans les paramètres.',
              textColor,
            ),
            const SizedBox(height: 24),

            // Section Limitation de responsabilité
            _buildSectionTitle('Limitation de responsabilité', textColor),
            _buildParagraph(
              'Cette application est fournie "telle quelle", sans garantie d\'aucune sorte, '
              'expresse ou implicite. L\'éditeur ne saurait être tenu responsable de tout dommage '
              'découlant de l\'utilisation de cette application, y compris mais sans s\'y limiter : '
              'trains manqués, informations erronées ou indisponibilité du service.\n\n'
              'Vérifiez toujours les horaires officiels avant votre départ.',
              textColor,
            ),
            const SizedBox(height: 24),

            // Section Licence MIT (texte complet)
            _buildSectionTitle('Licence MIT (texte complet)', textColor),
            _buildParagraph(
              'Copyright (c) 2026 Nicolas Klutchnikoff\n\n'
              'Permission is hereby granted, free of charge, to any person obtaining a copy '
              'of this software and associated documentation files (the "Software"), to deal '
              'in the Software without restriction, including without limitation the rights '
              'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
              'copies of the Software, and to permit persons to whom the Software is '
              'furnished to do so, subject to the following conditions:\n\n'
              'The above copyright notice and this permission notice shall be included in all '
              'copies or substantial portions of the Software.\n\n'
              'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
              'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
              'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE '
              'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER '
              'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, '
              'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE '
              'SOFTWARE.',
              textColor,
              small: true,
            ),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                'Fait avec ❤️ pour les voyageurs TER',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.medium.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, Color textColor, {bool small = false}) {
    return Text(
      text,
      style: (small ? AppTextStyles.tiny : AppTextStyles.small).copyWith(
        color: textColor,
        height: 1.5,
      ),
    );
  }

  Widget _buildLinkButton(String text, String url) {
    return TextButton.icon(
      onPressed: () => _launchUrl(url),
      icon: const Icon(Icons.open_in_new, size: 16),
      label: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
