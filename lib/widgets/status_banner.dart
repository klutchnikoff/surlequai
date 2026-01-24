import 'package:flutter/material.dart';
import 'package:surlequai/models/connection_status.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';
import 'package:surlequai/utils/constants.dart';

/// Bandeau d'état affiché en haut de l'écran principal
///
/// Affiche un message contextuel selon l'état de connexion :
/// - Offline : Bleu, "Mode hors connexion"
/// - Syncing : Gris, "Mise à jour en cours..."
/// - Error : Rouge, "Impossible de récupérer les données"
/// - Online : Caché
class StatusBanner extends StatelessWidget {
  final ConnectionStatus status;

  const StatusBanner({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Ne rien afficher si online
    if (status == ConnectionStatus.online) {
      return const SizedBox.shrink();
    }

    // Déterminer la couleur et le message selon le statut
    Color backgroundColor;
    IconData icon;
    String message;

    switch (status) {
      case ConnectionStatus.offline:
        backgroundColor = AppColors.offline;
        icon = Icons.cloud_off;
        message = 'Mode hors connexion - Horaires théoriques affichés';
        break;
      case ConnectionStatus.syncing:
        backgroundColor = AppColors.secondary;
        icon = Icons.sync;
        message = 'Mise à jour en cours...';
        break;
      case ConnectionStatus.error:
        backgroundColor = AppColors.cancelled;
        icon = Icons.error_outline;
        message = 'Impossible de récupérer les données';
        break;
      case ConnectionStatus.online:
        // Déjà géré au-dessus, mais nécessaire pour le switch exhaustif
        backgroundColor = Colors.transparent;
        icon = Icons.check;
        message = '';
        break;
    }

    return AnimatedContainer(
      duration: AppConstants.normalAnimationDuration,
      curve: Curves.easeInOut,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.small.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (status == ConnectionStatus.syncing)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
