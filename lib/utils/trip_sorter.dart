import 'package:surlequai/models/trip.dart';

/// Utilitaire pour déterminer l'ordre d'affichage des trajets (Matin/Soir)
class TripSorter {
  /// Détermine si l'ordre d'affichage doit être inversé (B->A au lieu de A->B)
  ///
  /// [currentHour] : L'heure actuelle (0-23)
  /// [morningEveningSplitHour] : Heure de bascule Matin/Soir (ex: 13 pour 13h00)
  /// [serviceDayStartHour] : Heure de début de service (ex: 4 pour 04h00)
  /// [morningDirection] : La direction préférée le matin (A->B ou B->A)
  ///
  /// Retourne true si on doit inverser l'ordre par défaut (donc afficher B->A en premier si A->B est le matin)
  static bool shouldSwapOrder({
    required int currentHour,
    required int morningEveningSplitHour,
    required int serviceDayStartHour,
    required MorningDirection morningDirection,
  }) {
    // Considère comme "soirée/après-midi" :
    // - Entre l'heure de bascule (13h) et minuit
    // - OU entre minuit et le début de service (4h) car on est encore dans la "soirée" de la veille pour les fêtards
    final isEvening = (currentHour >= morningEveningSplitHour) || 
                      (currentHour >= 0 && currentHour < serviceDayStartHour);

    // Si c'est le soir et que la direction du matin est A->B
    // Alors le soir on veut B->A, donc on inverse (swap)
    if (isEvening && morningDirection == MorningDirection.aToB) {
      return true;
    }

    // Si ce n'est PAS le soir (donc matin) et que la direction du matin est B->A
    // Alors le matin on veut B->A, or l'ordre par défaut est A->B
    // Donc on doit inverser pour avoir B->A en premier
    if (!isEvening && morningDirection == MorningDirection.bToA) {
      return true;
    }

    // Sinon, l'ordre par défaut (A->B) convient
    // - Soit c'est le matin et on veut A->B
    // - Soit c'est le soir et on veut A->B (cas rare où morningDirection serait B->A... attend, logique inverse)
    
    // Reprenons :
    // morningDirection = A->B (cas standard)
    // - Matin : On veut A->B. Default (A->B). Swap = false. OK.
    // - Soir : On veut B->A. Default (A->B). Swap = true. OK.
    
    // morningDirection = B->A (cas atypique, ex: travail de nuit)
    // - Matin : On veut B->A. Default (A->B). Swap = true. OK.
    // - Soir : On veut A->B. Default (A->B). Swap = false. OK.

    return false;
  }
}
