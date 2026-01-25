package com.example.surlequai

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.graphics.Color

class SurLeQuaiWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)

        // Nettoyer la configuration des widgets supprimés
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val editor = prefs.edit()

        for (appWidgetId in appWidgetIds) {
            editor.remove("widget_${appWidgetId}_trip_id")
        }

        editor.apply()
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        // Écoute les mises à jour depuis Flutter
        if (intent.action == "es.antonborri.home_widget.action.UPDATE_WIDGET") {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(
                android.content.ComponentName(context, SurLeQuaiWidgetProvider::class.java)
            )
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }

    fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // Récupère les données depuis SharedPreferences (écrites par Flutter via home_widget)
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

        // Récupérer l'ID du trajet configuré pour ce widget spécifique
        val tripId = prefs.getString("widget_${appWidgetId}_trip_id", null)

        if (tripId == null) {
            // Widget pas encore configuré (ne devrait pas arriver car config obligatoire)
            // ou trajet supprimé
            views.setTextViewText(R.id.widget_trip_name, "SurLeQuai")
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
            views.setTextViewText(R.id.widget_last_update, "Non configuré")

            appWidgetManager.updateAppWidget(appWidgetId, views)
            return
        }

        // Charger les données de ce trajet spécifique
        // Format de la clé : "trip_{tripId}_..."
        val tripName = prefs.getString("trip_${tripId}_name", "SurLeQuai") ?: "SurLeQuai"
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
        views.setTextColor(R.id.widget_direction2_status, getStatusColor(dir2StatusColor))

        // Dernière mise à jour
        val lastUpdate = prefs.getString("trip_${tripId}_last_update", "—") ?: "—"
        views.setTextViewText(R.id.widget_last_update, "Mis à jour: $lastUpdate")

        // Configure le tap pour ouvrir l'app ET basculer vers ce trajet
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            // Passer le tripId dans l'Intent
            putExtra("widget_trip_id", tripId)
        }

        // Utiliser appWidgetId comme requestCode pour différencier les PendingIntents
        val pendingIntent = android.app.PendingIntent.getActivity(
            context,
            appWidgetId,
            intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

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
            "onTime" -> Color.parseColor("#22C55E")    // Vert
            "delayed" -> Color.parseColor("#F59E0B")   // Orange
            "cancelled" -> Color.parseColor("#EF4444") // Rouge
            "offline" -> Color.parseColor("#60A5FA")   // Bleu
            else -> Color.parseColor("#9CA3AF")        // Gris
        }
    }
}
