import 'package:flutter_test/flutter_test.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/utils/trip_sorter.dart';

void main() {
  group('TripSorter - Tri Matin/Soir', () {
    const splitHour = 13; // Bascule à 13h00
    const serviceStart = 4; // Journée commence à 04h00

    test('Matin (8h) - Direction A->B par défaut', () {
      // 8h du matin : C'est le matin.
      // Direction matin voulue : A->B.
      // Ordre par défaut : A->B.
      // Donc swap attendu : false.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 8,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.aToB,
        ),
        false,
      );
    });

    test('Soir (18h) - Direction A->B par défaut', () {
      // 18h : C'est le soir.
      // Direction matin voulue : A->B (donc soir B->A).
      // Ordre par défaut : A->B.
      // On veut B->A.
      // Donc swap attendu : true.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 18,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.aToB,
        ),
        true,
      );
    });

    test('Nuit (2h) - Encore considéré comme soir de la veille', () {
      // 2h du matin : Avant 4h (serviceStart), donc considéré comme "Soirée prolongée".
      // Direction matin voulue : A->B (donc soir B->A).
      // Ordre par défaut : A->B.
      // On veut B->A.
      // Donc swap attendu : true.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 2,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.aToB,
        ),
        true,
      );
    });

    test('Petit Matin (5h) - Nouvelle journée', () {
      // 5h du matin : Après 4h (serviceStart), donc "Matin".
      // Direction matin voulue : A->B.
      // Ordre par défaut : A->B.
      // Donc swap attendu : false.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 5,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.aToB,
        ),
        false,
      );
    });

    test('Heure de bascule exacte (13h) - Considéré comme Soir', () {
      // 13h00 : Pile poil l'heure de split. Doit basculer en mode Soir.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 13,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.aToB,
        ),
        true,
      );
    });

    test('Juste avant bascule (12h) - Toujours Matin', () {
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 12,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.aToB,
        ),
        false,
      );
    });

    // Cas inverses : Si l'utilisateur a configuré "Matin = B->A" (travail de nuit ?)
    
    test('Matin (8h) - Direction B->A configurée', () {
      // Matin. On veut B->A.
      // Ordre par défaut : A->B.
      // Donc swap attendu : true.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 8,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.bToA,
        ),
        true,
      );
    });

    test('Soir (18h) - Direction B->A configurée', () {
      // Soir. On veut l'inverse du matin, donc A->B.
      // Ordre par défaut : A->B.
      // Donc swap attendu : false.
      expect(
        TripSorter.shouldSwapOrder(
          currentHour: 18,
          morningEveningSplitHour: splitHour,
          serviceDayStartHour: serviceStart,
          morningDirection: MorningDirection.bToA,
        ),
        false,
      );
    });
  });
}
