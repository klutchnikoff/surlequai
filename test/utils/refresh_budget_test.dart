import 'package:flutter_test/flutter_test.dart';
import 'package:surlequai/utils/refresh_budget.dart';

void main() {
  DateTime at(int hour, [int minute = 0]) =>
      DateTime(2026, 9, 10, hour, minute);

  group('nextRefresh', () {
    test('sleeps until the service resumes during the night', () {
      expect(RefreshBudget.nextRefresh(at(2)), at(5));
      expect(RefreshBudget.nextRefresh(at(23, 30)), DateTime(2026, 9, 11, 5));
    });

    test('keeps the idle pace when no departure is known', () {
      expect(RefreshBudget.nextRefresh(at(10)), at(10, 30));
    });

    test('aims at the precision window when it comes before the ceiling', () {
      // Départ dans 40 min : l'entrée dans la fenêtre est à 25 min, sous le
      // plafond, donc c'est elle qui est visée.
      expect(
        RefreshBudget.nextRefresh(at(10), nextDeparture: at(10, 40)),
        at(10, 25),
      );
      // Départ dans 50 min : viser la fenêtre demanderait 35 min, au-delà du
      // plafond ; le réveil intermédiaire resserrera le calcul.
      expect(
        RefreshBudget.nextRefresh(at(10), nextDeparture: at(10, 50)),
        at(10, 30),
      );
      expect(
        RefreshBudget.nextRefresh(at(10), nextDeparture: at(18)),
        at(10, 30),
      );
    });

    test('tightens the pace inside the precision window', () {
      expect(
        RefreshBudget.nextRefresh(at(10), nextDeparture: at(10, 12)),
        at(10, 10),
      );
      // Départ imminent : on ne dépasse pas l'heure de départ.
      expect(
        RefreshBudget.nextRefresh(at(10), nextDeparture: at(10, 4)),
        at(10, 4),
      );
    });

    test('ignores a departure already gone', () {
      expect(
        RefreshBudget.nextRefresh(at(10), nextDeparture: at(9, 30)),
        at(10, 30),
      );
    });
  });

  group('isStale', () {
    test('never trusts missing data', () {
      expect(RefreshBudget.isStale(now: at(10), fetchedAt: null), isTrue);
    });

    test('data spaced by the idle pace stays valid', () {
      // Vingt minutes sans départ proche : le réveil n'est pas encore dû.
      expect(
        RefreshBudget.isStale(now: at(10, 20), fetchedAt: at(10)),
        isFalse,
      );
    });

    test('a missed wake-up marks the data offline', () {
      // Réveil dû à 10h30, tolérance d'une minute : périmé dès 10h31.
      expect(
        RefreshBudget.isStale(now: at(10, 30), fetchedAt: at(10)),
        isFalse,
      );
      expect(
        RefreshBudget.isStale(now: at(10, 31), fetchedAt: at(10)),
        isTrue,
      );
    });

    test('the window shortens the tolerance near a departure', () {
      // Réveil dû à 10h10 : à 10h12 il est manqué, alors qu'au repos non.
      expect(
        RefreshBudget.isStale(
          now: at(10, 12),
          fetchedAt: at(10),
          nextDeparture: at(10, 12),
        ),
        isTrue,
      );
      expect(
        RefreshBudget.isStale(now: at(10, 12), fetchedAt: at(10)),
        isFalse,
      );
    });
  });
}
