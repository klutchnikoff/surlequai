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

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // Récupère les données depuis SharedPreferences (écrites par Flutter via home_widget)
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

        // Nom du trajet
        val tripName = prefs.getString("trip_name", "SurLeQuai") ?: "SurLeQuai"
        views.setTextViewText(R.id.widget_trip_name, tripName)

        // Direction 1
        val dir1Title = prefs.getString("direction1_title", "Direction 1") ?: "Direction 1"
        val dir1Time = prefs.getString("direction1_time", "__:__") ?: "__:__"
        val dir1Platform = prefs.getString("direction1_platform", "") ?: ""
        val dir1Status = prefs.getString("direction1_status", "") ?: ""
        val dir1StatusColor = prefs.getString("direction1_status_color", "secondary") ?: "secondary"

        views.setTextViewText(R.id.widget_direction1_title, dir1Title)
        views.setTextViewText(R.id.widget_direction1_time, dir1Time)
        views.setTextViewText(R.id.widget_direction1_platform, dir1Platform)
        views.setTextViewText(R.id.widget_direction1_status, dir1Status)
        views.setTextViewText(R.id.widget_direction1_emoji, getStatusEmoji(dir1StatusColor))
        views.setTextColor(R.id.widget_direction1_status, getStatusColor(dir1StatusColor))

        // Direction 2
        val dir2Title = prefs.getString("direction2_title", "Direction 2") ?: "Direction 2"
        val dir2Time = prefs.getString("direction2_time", "__:__") ?: "__:__"
        val dir2Platform = prefs.getString("direction2_platform", "") ?: ""
        val dir2Status = prefs.getString("direction2_status", "") ?: ""
        val dir2StatusColor = prefs.getString("direction2_status_color", "secondary") ?: "secondary"

        views.setTextViewText(R.id.widget_direction2_title, dir2Title)
        views.setTextViewText(R.id.widget_direction2_time, dir2Time)
        views.setTextViewText(R.id.widget_direction2_platform, dir2Platform)
        views.setTextViewText(R.id.widget_direction2_status, dir2Status)
        views.setTextViewText(R.id.widget_direction2_emoji, getStatusEmoji(dir2StatusColor))
        views.setTextColor(R.id.widget_direction2_status, getStatusColor(dir2StatusColor))

        // Dernière mise à jour
        val lastUpdate = prefs.getString("last_update", "—") ?: "—"
        views.setTextViewText(R.id.widget_last_update, "Mis à jour: $lastUpdate")

        // Configure le tap pour ouvrir l'app
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = android.app.PendingIntent.getActivity(
            context, 0, intent,
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
