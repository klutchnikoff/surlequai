package fr.surlequai.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.work.*
import java.util.Calendar
import java.util.concurrent.TimeUnit

class SurLeQuaiWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
            scheduleNextUpdate(context, appWidgetId)
        }
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)

        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val editor = prefs.edit()

        for (appWidgetId in appWidgetIds) {
            editor.remove("widget_${appWidgetId}_trip_id")
            // Annuler la tâche de fond planifiée pour ce widget
            WorkManager.getInstance(context).cancelUniqueWork("widget_refresh_$appWidgetId")
        }

        editor.apply()
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            "es.antonborri.home_widget.action.UPDATE_WIDGET" -> {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = android.content.ComponentName(context, SurLeQuaiWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                onUpdate(context, appWidgetManager, appWidgetIds)
            }
            ACTION_REFRESH_WIDGET -> {
                // Déclencher le rafraîchissement manuel via le backgroundCallback
                val appWidgetId = intent.getIntExtra(
                    AppWidgetManager.EXTRA_APPWIDGET_ID,
                    AppWidgetManager.INVALID_APPWIDGET_ID
                )

                // Appeler le HomeWidgetBackgroundIntent pour déclencher le Dart callback
                es.antonborri.home_widget.HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homewidget://refresh")
                ).send()

                // Forcer la mise à jour du widget après un court délai pour laisser
                // le temps au callback Dart de sauvegarder les nouvelles données
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    val appWidgetManager = AppWidgetManager.getInstance(context)
                    if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                        // Mettre à jour uniquement ce widget
                        updateAppWidget(context, appWidgetManager, appWidgetId)
                    } else {
                        // Mettre à jour tous les widgets
                        val componentName = android.content.ComponentName(context, SurLeQuaiWidgetProvider::class.java)
                        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                        onUpdate(context, appWidgetManager, appWidgetIds)
                    }
                }, 2000) // 2 secondes pour laisser le temps au callback Dart
            }
        }
    }

    companion object {
        private const val ACTION_REFRESH_WIDGET = "fr.surlequai.app.REFRESH_WIDGET"

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val tripId = prefs.getString("widget_${appWidgetId}_trip_id", null)

            // Vérifier si le trajet existe encore
            val tripName = if (tripId != null) {
                prefs.getString("trip_${tripId}_name", null)
            } else {
                null
            }

            // Si pas de tripId ou trajet supprimé, afficher état "non configuré"
            if (tripId == null || tripName == null) {
                setupNonConfiguredWidget(context, views, appWidgetId, appWidgetManager)
                return
            }

            views.setTextViewText(R.id.widget_trip_name, tripName)

            // Direction 1
            val dir1Title = prefs.getString("trip_${tripId}_direction1_title", "Direction 1") ?: "Direction 1"
            val dir1Time = prefs.getString("trip_${tripId}_direction1_time", "__:__") ?: "__:__"
            val dir1Platform = prefs.getString("trip_${tripId}_direction1_platform", "") ?: ""
            val dir1Status = prefs.getString("trip_${tripId}_direction1_status", "") ?: ""
            val dir1StatusColor = prefs.getString("trip_${tripId}_direction1_status_color", "secondary") ?: "secondary"

            views.setTextViewText(R.id.widget_direction1_title, dir1Title)
            views.setTextViewText(R.id.widget_direction1_time, dir1Time)
            views.setTextViewText(R.id.widget_direction1_platform, dir1Platform)
            views.setTextViewText(R.id.widget_direction1_status, dir1Status)
            views.setTextViewText(R.id.widget_direction1_emoji, getStatusEmoji(dir1StatusColor))
            views.setTextColor(R.id.widget_direction1_status, getStatusColor(dir1StatusColor))

            // Direction 2
            val dir2Title = prefs.getString("trip_${tripId}_direction2_title", "Direction 2") ?: "Direction 2"
            val dir2Time = prefs.getString("trip_${tripId}_direction2_time", "__:__") ?: "__:__"
            val dir2Platform = prefs.getString("trip_${tripId}_direction2_platform", "") ?: ""
            val dir2Status = prefs.getString("trip_${tripId}_direction2_status", "") ?: ""
            val dir2StatusColor = prefs.getString("trip_${tripId}_direction2_status_color", "secondary") ?: "secondary"

            views.setTextViewText(R.id.widget_direction2_title, dir2Title)
            views.setTextViewText(R.id.widget_direction2_time, dir2Time)
            views.setTextViewText(R.id.widget_direction2_platform, dir2Platform)
            views.setTextViewText(R.id.widget_direction2_status, dir2Status)
            views.setTextViewText(R.id.widget_direction2_emoji, getStatusEmoji(dir2StatusColor))
            views.setTextColor(R.id.widget_direction2_status, getStatusColorSecondary(dir2StatusColor))

            val lastUpdate = prefs.getString("trip_${tripId}_last_update", "—") ?: "—"
            views.setTextViewText(R.id.widget_last_update, "Mis à jour: $lastUpdate")

            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("widget_trip_id", tripId)
            }

            val pendingIntent = PendingIntent.getActivity(
                context,
                appWidgetId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            // Bouton de rafraîchissement manuel (visible uniquement si configuré)
            views.setViewVisibility(R.id.widget_refresh_button, View.VISIBLE)
            val refreshIntent = Intent(context, SurLeQuaiWidgetProvider::class.java).apply {
                action = ACTION_REFRESH_WIDGET
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId + 1000, // Offset pour éviter collision avec pendingIntent ci-dessus
                refreshIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_refresh_button, refreshPendingIntent)

            // Clic sur le nom du trajet pour changer de trajet
            val switchTripIntent = Intent(context, SurLeQuaiWidgetSwitchTripActivity::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val switchTripPendingIntent = PendingIntent.getActivity(
                context,
                appWidgetId + 2000, // Offset différent
                switchTripIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_trip_name, switchTripPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        /**
         * Configure le widget en état "non configuré" ou "trajet supprimé"
         */
        private fun setupNonConfiguredWidget(
            context: Context,
            views: RemoteViews,
            appWidgetId: Int,
            appWidgetManager: AppWidgetManager
        ) {
            views.setTextViewText(R.id.widget_trip_name, "Trajet supprimé")
            views.setTextViewText(R.id.widget_direction1_title, "—")
            views.setTextViewText(R.id.widget_direction1_time, "__:__")
            views.setTextViewText(R.id.widget_direction1_platform, "")
            views.setTextViewText(R.id.widget_direction1_status, "")
            views.setTextViewText(R.id.widget_direction1_emoji, "")
            views.setTextViewText(R.id.widget_direction2_title, "—")
            views.setTextViewText(R.id.widget_direction2_time, "__:__")
            views.setTextViewText(R.id.widget_direction2_platform, "")
            views.setTextViewText(R.id.widget_direction2_status, "")
            views.setTextViewText(R.id.widget_direction2_emoji, "")
            views.setTextViewText(R.id.widget_last_update, "Toucher pour choisir un trajet")

            // Clic n'importe où sur le widget ouvre le sélecteur de trajet
            val switchTripIntent = Intent(context, SurLeQuaiWidgetSwitchTripActivity::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val switchTripPendingIntent = PendingIntent.getActivity(
                context,
                appWidgetId + 2000,
                switchTripIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, switchTripPendingIntent)

            // Masquer le bouton de refresh quand non configuré
            views.setViewVisibility(R.id.widget_refresh_button, View.GONE)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun getStatusEmoji(statusCode: String): String {
            return when (statusCode) {
                "onTime" -> "🟢"
                "delayed" -> "🟠"
                "cancelled" -> "🔴"
                "offline" -> "🔵"
                else -> ""
            }
        }

        private fun getStatusColor(statusCode: String): Int {
            return when (statusCode) {
                "onTime" -> Color.parseColor("#22C55E")
                "delayed" -> Color.parseColor("#F59E0B")
                "cancelled" -> Color.parseColor("#EF4444")
                "offline" -> Color.parseColor("#60A5FA")
                else -> Color.parseColor("#9CA3AF")
            }
        }

        /**
         * Retourne une couleur atténuée pour la direction secondaire (moins prioritaire)
         * Utilise un gris uniforme pour ne pas trop attirer l'attention
         */
        private fun getStatusColorSecondary(statusCode: String): Int {
            return Color.parseColor("#9CA3AF")
        }

        fun scheduleNextUpdate(context: Context, appWidgetId: Int) {
            Log.d("SurLeQuai", "scheduleNextUpdate called for widget $appWidgetId")
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val tripId = prefs.getString("widget_${appWidgetId}_trip_id", null)
            if (tripId == null) {
                Log.d("SurLeQuai", "Widget $appWidgetId: no tripId configured, skipping schedule")
                return
            }

            // Récupérer les données pour calculer le prochain réveil
            val dir1Time = prefs.getString("trip_${tripId}_direction1_time", null)
            val dir2Time = prefs.getString("trip_${tripId}_direction2_time", null)
            val dir1Status = prefs.getString("trip_${tripId}_direction1_status", "") ?: ""
            val dir2Status = prefs.getString("trip_${tripId}_direction2_status", "") ?: ""

            Log.d("SurLeQuai", "Widget $appWidgetId: dir1Time=$dir1Time, dir2Time=$dir2Time")

            // Extraction simplifiée du retard (ex: "+5 min" -> 5)
            val dir1Delay = if (dir1Status.startsWith("+")) dir1Status.split(" ")[0].drop(1).toIntOrNull() ?: 0 else 0
            val dir2Delay = if (dir2Status.startsWith("+")) dir2Status.split(" ")[0].drop(1).toIntOrNull() ?: 0 else 0

            // Trouver le prochain départ pertinent
            val nextDeparture = getNextDepartureCalendar(dir1Time, dir1Delay, dir2Time, dir2Delay) ?: return

            val now = Calendar.getInstance()
            val intervals = listOf(20, 15, 10, 5, 0) // L'Échelle de temps
            var nextUpdate: Calendar? = null

            // Trouver le prochain barreau de l'échelle (du plus éloigné au plus proche)
            for (interval in intervals) { // 20, 15, 10, 5, 0
                val updateTime = (nextDeparture.clone() as Calendar).apply {
                    add(Calendar.MINUTE, -interval)
                }
                // Ajouter une petite marge de 5 secondes pour éviter les boucles infinies si exécution trop rapide
                if (updateTime.timeInMillis > now.timeInMillis + 5000) {
                    // Premier barreau dans le futur = le plus proche
                    nextUpdate = updateTime
                    break
                }
            }

            // Si plus de mise à jour pertinente pour ce train, on arrête
            if (nextUpdate == null) {
                Log.d("SurLeQuai", "Widget $appWidgetId: no upcoming trains, canceling updates")
                WorkManager.getInstance(context).cancelUniqueWork("widget_refresh_$appWidgetId")
                return
            }

            val delay = nextUpdate.timeInMillis - now.timeInMillis
            val delayMinutes = delay / 60000

            Log.d("SurLeQuai", "Widget $appWidgetId: next update in $delayMinutes min (${nextUpdate.get(Calendar.HOUR_OF_DAY)}:${String.format("%02d", nextUpdate.get(Calendar.MINUTE))})")

            // Planifier le Worker
            try {
                val workRequest = OneTimeWorkRequestBuilder<WidgetRefreshWorker>()
                    .setInitialDelay(delay, TimeUnit.MILLISECONDS)
                    .build()

                WorkManager.getInstance(context).enqueueUniqueWork(
                    "widget_refresh_$appWidgetId",
                    ExistingWorkPolicy.REPLACE, // Remplace toute planification précédente pour ce widget
                    workRequest
                )
                Log.d("SurLeQuai", "Widget $appWidgetId: WorkManager scheduled successfully")
            } catch (e: Exception) {
                Log.e("SurLeQuai", "Widget $appWidgetId: Failed to schedule WorkManager", e)
            }
        }

        private fun getNextDepartureCalendar(time1: String?, delay1: Int, time2: String?, delay2: Int): Calendar? {
            val now = Calendar.getInstance()
            val cal1 = timeStringToCalendar(time1, delay1)
            val cal2 = timeStringToCalendar(time2, delay2)

            val futureDepartures = listOfNotNull(cal1, cal2).filter { it.after(now) }
            return futureDepartures.minByOrNull { it.timeInMillis }
        }

        private fun timeStringToCalendar(time: String?, delay: Int): Calendar? {
            if (time == null || !time.contains(":")) return null
            return try {
                val parts = time.split(":")
                val now = Calendar.getInstance()
                Calendar.getInstance().apply {
                    set(Calendar.HOUR_OF_DAY, parts[0].toInt())
                    set(Calendar.MINUTE, parts[1].toInt())
                    set(Calendar.SECOND, 0)
                    add(Calendar.MINUTE, delay) // Appliquer le retard

                    // Si l'heure calculée est dans le passé, c'est pour demain
                    if (this.before(now)) {
                        add(Calendar.DAY_OF_YEAR, 1)
                    }
                }
            } catch (e: Exception) {
                null
            }
        }
    }
}
