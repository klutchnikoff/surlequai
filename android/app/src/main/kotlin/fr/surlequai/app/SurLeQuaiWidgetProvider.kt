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
            WorkManager.getInstance(context).cancelUniqueWork("widget_refresh_$appWidgetId")
        }

        editor.apply()
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        WorkManager.getInstance(context).cancelUniqueWork("widget_refresh")
        WorkManager.getInstance(context).cancelUniqueWork("widget_refresh_backup")
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
                // Le callback publie les données et déclenche lui-même le rendu.
                es.antonborri.home_widget.HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homewidget://refresh")
                ).send()
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
            views.setTextColor(R.id.widget_direction2_status, Color.parseColor("#9CA3AF"))

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

        fun scheduleNextUpdate(context: Context, appWidgetId: Int) {
            Log.d("SurLeQuai", "scheduleNextUpdate called for widget $appWidgetId")
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val tripId = prefs.getString("widget_${appWidgetId}_trip_id", null)
            if (tripId == null) {
                Log.d("SurLeQuai", "Widget $appWidgetId: no tripId configured, skipping schedule")
                return
            }

            // Une date complète évite de reporter à demain un départ déjà passé.
            // Un réveil de secours reste programmé même quand aucun train n'est connu.
            val now = System.currentTimeMillis()
            val component = android.content.ComponentName(context, SurLeQuaiWidgetProvider::class.java)
            val widgetIds = AppWidgetManager.getInstance(context).getAppWidgetIds(component)
            val nextDeparture = (widgetIds.toList() + appWidgetId).mapNotNull { id ->
                val selected = prefs.getString("widget_${id}_trip_id", null)
                prefs.getString("trip_${selected}_next_departure", null)?.toLongOrNull()
            }.filter { it > now }.minOrNull()
            val delay = if (nextDeparture != null) {
                minOf(TimeUnit.MINUTES.toMillis(5), maxOf(5000L, nextDeparture - now))
            } else TimeUnit.MINUTES.toMillis(5)

            // Planifier le Worker
            try {
                val manager = WorkManager.getInstance(context)
                // Retirer les tâches par widget des versions précédentes.
                manager.cancelUniqueWork("widget_refresh_$appWidgetId")
                // Relance même si le précédent callback Dart n'a pas pu terminer.
                manager.enqueueUniquePeriodicWork(
                    "widget_refresh_backup",
                    ExistingPeriodicWorkPolicy.KEEP,
                    PeriodicWorkRequestBuilder<WidgetRefreshWorker>(15, TimeUnit.MINUTES)
                        .setInitialDelay(15, TimeUnit.MINUTES).build()
                )
                val workRequest = OneTimeWorkRequestBuilder<WidgetRefreshWorker>()
                    .setInitialDelay(delay, TimeUnit.MILLISECONDS)
                    .build()

                WorkManager.getInstance(context).enqueueUniqueWork(
                    "widget_refresh",
                    ExistingWorkPolicy.REPLACE, // Une tâche partagée pour tous les widgets
                    workRequest
                )
                Log.d("SurLeQuai", "Widget $appWidgetId: WorkManager scheduled successfully")
            } catch (e: Exception) {
                Log.e("SurLeQuai", "Widget $appWidgetId: Failed to schedule WorkManager", e)
            }
        }

    }
}
