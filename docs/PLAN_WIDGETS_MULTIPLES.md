# Plan d'implémentation : Widgets multiples + Rafraîchissement intelligent

**Date** : 25 janvier 2026
**Objectif** : Widget multiples configurables avec stratégie de rafraîchissement intelligente
**Estimation** : 6-8 heures total

---

## 🎯 Objectifs

### 1. Widgets multiples configurables
- Permettre à l'utilisateur d'ajouter plusieurs widgets
- Chaque widget affiche un trajet différent
- **Cas d'usage** : Correspondances (ex: Bruz → Rennes + Rennes → Betton)

### 2. Rafraîchissement intelligent
- Économie batterie maximale
- Infos fraîches quand nécessaire
- Adaptation dynamique aux retards

---

## 📋 Phase 1 : Widgets multiples (3-4h)

### 1.1 Configuration Activity Android (2h)

**Fichier à créer** : `android/app/src/main/kotlin/com/example/surlequai/SurLeQuaiWidgetConfigureActivity.kt`

```kotlin
package com.example.surlequai

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import org.json.JSONArray

class SurLeQuaiWidgetConfigureActivity : Activity() {

    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Configuration obligatoire : retour CANCELED par défaut
        setResult(RESULT_CANCELED)

        // Récupérer l'ID du widget
        appWidgetId = intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        setContentView(R.layout.widget_configure)
        setupTripsList()
    }

    private fun setupTripsList() {
        val prefs = getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val tripsJson = prefs.getString("trips", null)

        if (tripsJson == null) {
            // Pas de trajets disponibles
            finish()
            return
        }

        // Parser les trajets
        val tripsArray = JSONArray(tripsJson)
        val tripsList = mutableListOf<Trip>()

        for (i in 0 until tripsArray.length()) {
            val tripObj = tripsArray.getJSONObject(i)
            tripsList.add(Trip(
                id = tripObj.getString("id"),
                name = "${tripObj.getJSONObject("stationA").getString("name")} ⟷ " +
                       "${tripObj.getJSONObject("stationB").getString("name")}"
            ))
        }

        // Afficher la liste
        val listView = findViewById<ListView>(R.id.trips_list)
        val adapter = ArrayAdapter(
            this,
            android.R.layout.simple_list_item_1,
            tripsList.map { it.name }
        )
        listView.adapter = adapter

        // Clic sur un trajet
        listView.setOnItemClickListener { _, _, position, _ ->
            val selectedTrip = tripsList[position]
            saveTripIdForWidget(selectedTrip.id)

            // Mettre à jour le widget
            val appWidgetManager = AppWidgetManager.getInstance(this)
            SurLeQuaiWidgetProvider.updateAppWidget(
                this,
                appWidgetManager,
                appWidgetId
            )

            // Retourner OK
            val resultValue = Intent().apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            setResult(RESULT_OK, resultValue)
            finish()
        }
    }

    private fun saveTripIdForWidget(tripId: String) {
        val prefs = getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        prefs.edit().putString("widget_${appWidgetId}_trip_id", tripId).apply()
    }

    data class Trip(val id: String, val name: String)
}
```

**Fichier layout à créer** : `android/app/src/main/res/layout/widget_configure.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Choisir un trajet"
        android:textSize="20sp"
        android:textStyle="bold"
        android:layout_marginBottom="16dp" />

    <ListView
        android:id="@+id/trips_list"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />

</LinearLayout>
```

### 1.2 Modifier widget_info.xml (5min)

**Fichier** : `android/app/src/main/res/xml/widget_info.xml`

Ajouter l'attribut de configuration :

```xml
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="250dp"
    android:minHeight="110dp"
    android:updatePeriodMillis="0"
    android:initialLayout="@layout/widget_layout"
    android:configure="com.example.surlequai.SurLeQuaiWidgetConfigureActivity"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen"
    android:description="@string/widget_description"
    android:previewImage="@mipmap/ic_launcher" />
```

**Note** : `updatePeriodMillis="0"` car on va utiliser WorkManager pour le rafraîchissement intelligent.

### 1.3 Modifier SurLeQuaiWidgetProvider.kt (30min)

**Fichier** : `android/app/src/main/kotlin/com/example/surlequai/SurLeQuaiWidgetProvider.kt`

```kotlin
private fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.widget_layout)
    val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

    // Récupérer l'ID du trajet configuré pour ce widget
    val tripId = prefs.getString("widget_${appWidgetId}_trip_id", null)

    if (tripId == null) {
        // Widget pas encore configuré ou trajet supprimé
        views.setTextViewText(R.id.widget_trip_name, "SurLeQuai")
        views.setTextViewText(R.id.widget_direction1_title, "—")
        views.setTextViewText(R.id.widget_direction1_time, "__:__")
        appWidgetManager.updateAppWidget(appWidgetId, views)
        return
    }

    // Charger les données de ce trajet spécifique
    val tripDataKey = "trip_${tripId}_data"
    val tripDataJson = prefs.getString(tripDataKey, null)

    if (tripDataJson != null) {
        // Parser et afficher les données
        val tripData = JSONObject(tripDataJson)
        // ... (reste du code existant, mais avec les données du trajet spécifique)
    }

    // Reste du code...
}
```

### 1.4 Côté Flutter : Sauvegarder données par trajet (1h)

**Fichier** : `lib/services/widget_service.dart`

Ajouter une méthode pour sauvegarder les données de TOUS les trajets (pas seulement l'actif) :

```dart
Future<void> updateAllTripsData() async {
  // Pour chaque trajet, sauvegarder ses données
  for (final trip in allTrips) {
    final departuresGo = await _getDeparturesForTrip(trip, direction: 'go');
    final departuresReturn = await _getDeparturesForTrip(trip, direction: 'return');

    await HomeWidget.saveWidgetData(
      'trip_${trip.id}_data',
      jsonEncode({
        'tripName': '${trip.stationA.name} ⟷ ${trip.stationB.name}',
        'direction1_title': '${trip.stationA.name} → ${trip.stationB.name}',
        'direction1_time': _formatTime(departuresGo.firstOrNull),
        // ... etc
      })
    );
  }

  // Mettre à jour TOUS les widgets
  await HomeWidget.updateWidget(
    androidName: 'SurLeQuaiWidgetProvider',
  );
}
```

### 1.5 Déclarer l'Activity dans AndroidManifest.xml (5min)

**Fichier** : `android/app/src/main/AndroidManifest.xml`

```xml
<activity
    android:name=".SurLeQuaiWidgetConfigureActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_CONFIGURE" />
    </intent-filter>
</activity>
```

---

## 📋 Phase 2 : Rafraîchissement intelligent (3-4h)

### 2.1 Créer le WidgetRefreshManager (2h)

**Fichier à créer** : `android/app/src/main/kotlin/com/example/surlequai/WidgetRefreshManager.kt`

```kotlin
package com.example.surlequai

import android.content.Context
import androidx.work.*
import java.time.Duration
import java.time.LocalTime
import java.util.concurrent.TimeUnit

object WidgetRefreshManager {

    private const val WORK_TAG = "widget_refresh"

    /**
     * Calcule le prochain moment de rafraîchissement selon la stratégie intelligente
     */
    fun scheduleNextRefresh(context: Context, nextTrainTime: LocalTime?, delay: Int = 0) {
        val workManager = WorkManager.getInstance(context)

        // Annuler les anciens work
        workManager.cancelAllWorkByTag(WORK_TAG)

        if (nextTrainTime == null) {
            // Pas de train, on vérifie demain matin à 5h
            val delayUntilTomorrow = calculateDelayUntil(LocalTime.of(5, 0))
            scheduleRefresh(context, delayUntilTomorrow)
            return
        }

        val now = LocalTime.now()
        val minutesUntilTrain = Duration.between(now, nextTrainTime).toMinutes()

        val nextRefreshDelay = when {
            minutesUntilTrain <= 0 -> {
                // Train parti, attendre H-20 du prochain
                // (Cette info devrait venir de Flutter)
                60L // Par défaut 1h, sera affiné par Flutter
            }
            minutesUntilTrain <= 5 -> {
                // H-5 à H : rafraîchir toutes les 1 minute
                1L
            }
            minutesUntilTrain <= 10 -> {
                // H-10 à H-5 : rafraîchir dans 5 min
                5L
            }
            minutesUntilTrain <= 15 -> {
                // H-15 à H-10 : rafraîchir dans 5 min
                5L
            }
            minutesUntilTrain <= 20 -> {
                // H-20 à H-15 : rafraîchir dans 5 min
                5L
            }
            else -> {
                // Plus de 20 min : rafraîchir à H-20
                minutesUntilTrain - 20
            }
        }

        scheduleRefresh(context, nextRefreshDelay + delay)
    }

    private fun scheduleRefresh(context: Context, delayMinutes: Long) {
        val refreshWork = OneTimeWorkRequestBuilder<WidgetRefreshWorker>()
            .setInitialDelay(delayMinutes, TimeUnit.MINUTES)
            .addTag(WORK_TAG)
            .build()

        WorkManager.getInstance(context).enqueue(refreshWork)
    }

    private fun calculateDelayUntil(targetTime: LocalTime): Long {
        val now = LocalTime.now()
        var delay = Duration.between(now, targetTime).toMinutes()
        if (delay < 0) {
            delay += 24 * 60 // Ajouter 24h
        }
        return delay
    }
}

/**
 * Worker qui effectue le rafraîchissement du widget
 */
class WidgetRefreshWorker(
    context: Context,
    params: WorkerParameters
) : Worker(context, params) {

    override fun doWork(): Result {
        // Déclencher la mise à jour Flutter
        // Flutter mettra à jour les données et reprogrammera le prochain refresh
        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            action = "com.surlequai.REFRESH_WIDGET"
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        applicationContext.startActivity(intent)

        return Result.success()
    }
}
```

### 2.2 Ajouter WorkManager dans build.gradle (5min)

**Fichier** : `android/app/build.gradle`

```gradle
dependencies {
    // ... existantes
    implementation "androidx.work:work-runtime-ktx:2.9.0"
}
```

### 2.3 Modifier Flutter pour gérer la stratégie (1-2h)

**Fichier** : `lib/services/widget_service.dart`

```dart
import 'package:flutter/services.dart';

class WidgetService {
  static const platform = MethodChannel('com.surlequai.widget/refresh');

  /// Met à jour le widget et programme le prochain rafraîchissement
  Future<void> updateWidgetWithRefreshStrategy({
    required Trip trip,
    required List<Departure> departures,
  }) async {
    // 1. Trouver le prochain train
    final now = DateTime.now();
    final nextDeparture = departures.firstWhere(
      (d) => d.scheduledTime.isAfter(now),
      orElse: () => null,
    );

    // 2. Calculer H (avec ajustement retard)
    DateTime? effectiveDepartureTime;
    if (nextDeparture != null) {
      effectiveDepartureTime = nextDeparture.scheduledTime;
      if (nextDeparture.status == DepartureStatus.delayed) {
        effectiveDepartureTime = effectiveDepartureTime.add(
          Duration(minutes: nextDeparture.delayMinutes)
        );
      }
    }

    // 3. Mettre à jour les données du widget
    await updateWidget(/* ... */);

    // 4. Programmer le prochain rafraîchissement (appel Android natif)
    if (effectiveDepartureTime != null) {
      try {
        await platform.invokeMethod('scheduleNextRefresh', {
          'nextTrainHour': effectiveDepartureTime.hour,
          'nextTrainMinute': effectiveDepartureTime.minute,
        });
      } catch (e) {
        debugPrint('Erreur programmation refresh: $e');
      }
    }
  }
}
```

### 2.4 Créer le MethodChannel Android (30min)

**Fichier** : `android/app/src/main/kotlin/com/example/surlequai/MainActivity.kt`

```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.time.LocalTime

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.surlequai.widget/refresh"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleNextRefresh" -> {
                        val hour = call.argument<Int>("nextTrainHour") ?: 0
                        val minute = call.argument<Int>("nextTrainMinute") ?: 0
                        val nextTrainTime = LocalTime.of(hour, minute)

                        WidgetRefreshManager.scheduleNextRefresh(
                            applicationContext,
                            nextTrainTime
                        )
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
```

---

## ✅ Checklist d'implémentation

### Phase 1 : Widgets multiples
- [ ] Créer `SurLeQuaiWidgetConfigureActivity.kt`
- [ ] Créer layout `widget_configure.xml`
- [ ] Modifier `widget_info.xml` (ajouter android:configure)
- [ ] Modifier `SurLeQuaiWidgetProvider.kt` (lecture tripId par widget)
- [ ] Modifier `widget_service.dart` (sauvegarder tous les trajets)
- [ ] Déclarer Activity dans `AndroidManifest.xml`
- [ ] Tester : ajouter plusieurs widgets

### Phase 2 : Rafraîchissement intelligent
- [ ] Créer `WidgetRefreshManager.kt`
- [ ] Créer `WidgetRefreshWorker.kt`
- [ ] Ajouter WorkManager dans `build.gradle`
- [ ] Modifier `widget_service.dart` (stratégie refresh)
- [ ] Créer MethodChannel dans `MainActivity.kt`
- [ ] Tester : vérifier les rafraîchissements aux bons moments
- [ ] Tester : gestion des retards (H dynamique)
- [ ] Tester : pas de refresh après départ

---

## 🧪 Plan de test

### Test 1 : Widgets multiples
1. Ajouter un premier widget → Choisir "Rennes ⟷ Nantes"
2. Ajouter un deuxième widget → Choisir "Paris ⟷ Lyon"
3. Vérifier que chaque widget affiche le bon trajet
4. Supprimer un trajet dans l'app → Vérifier que le widget affiche "—"

### Test 2 : Rafraîchissement intelligent
1. Créer un mock de train dans 25 minutes
2. Vérifier qu'il n'y a pas de refresh immédiat
3. Avancer le temps à H-20 → Vérifier refresh
4. Avancer à H-10 → Vérifier refresh
5. Ajouter un retard de +5min → Vérifier que H s'adapte
6. Attendre le départ → Vérifier pause jusqu'à H-20 du prochain

### Test 3 : Économie batterie
1. Activer le mode développeur Android
2. Monitorer les wake locks et battery usage
3. Comparer avec un refresh constant toutes les 5 minutes
4. Vérifier : pas de wake lock inutiles entre les rafraîchissements

---

## 📝 Notes d'implémentation

### Contraintes Android
- WorkManager minimum delay : 15 minutes (Android impose)
- Workaround : Utiliser AlarmManager pour délais < 15min
- Permissions : Aucune permission spéciale nécessaire

### Alternatives si WorkManager ne suffit pas
- `AlarmManager.setExactAndAllowWhileIdle()` pour délais courts
- `AlarmManager.setAlarmClock()` pour affichage dans le tiroir
- Combiner WorkManager (délais longs) + AlarmManager (délais courts)

### Gestion des cas limites
- Widget ajouté mais aucun trajet : Afficher message "Ajouter un trajet"
- Trajet supprimé : Nettoyer la config du widget
- Pas de réseau : Continuer à rafraîchir selon horaires théoriques
- Nuit (0h-5h) : Pas de rafraîchissement

---

**Estimation totale** : 6-8 heures
**Priorité** : MUST-HAVE
**Dépendances** : Aucune (fonctionne avec mocks)
