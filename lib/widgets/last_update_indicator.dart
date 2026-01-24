import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surlequai/theme/app_theme.dart';
import 'package:surlequai/utils/formatters.dart';

/// Widget affichant "Mis à jour il y a X"
///
/// Se met à jour automatiquement chaque seconde pour afficher
/// le temps écoulé depuis la dernière mise à jour.
class LastUpdateIndicator extends StatefulWidget {
  final DateTime? lastUpdate;

  const LastUpdateIndicator({
    super.key,
    required this.lastUpdate,
  });

  @override
  State<LastUpdateIndicator> createState() => _LastUpdateIndicatorState();
}

class _LastUpdateIndicatorState extends State<LastUpdateIndicator> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Démarre un timer qui se déclenche toutes les secondes
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          // Force le rebuild pour mettre à jour le temps relatif
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lastUpdate == null) {
      return Text(
        'Chargement...',
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.getSecondaryTextColor(context),
        ),
      );
    }

    final now = DateTime.now();
    final difference = now.difference(widget.lastUpdate!);

    // Calcul de l'opacité basée sur l'ancienneté
    // Plus les données sont anciennes, plus le texte est grisé
    double opacity = 1.0;
    if (difference.inMinutes > 5) {
      opacity = 0.7; // Légèrement grisé après 5 min
    }
    if (difference.inMinutes > 15) {
      opacity = 0.5; // Plus grisé après 15 min
    }

    return Text(
      'Mis à jour : ${TimeFormatter.formatRelativeTime(widget.lastUpdate!)}',
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context)
            .textTheme
            .bodySmall
            ?.color
            ?.withValues(alpha: opacity),
      ),
    );
  }
}
