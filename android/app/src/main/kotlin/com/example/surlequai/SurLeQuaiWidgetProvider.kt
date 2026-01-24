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
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // Charge les données depuis SharedPreferences
        val tripName = prefs.getString("trip_name", "SurLeQuai") ?: "SurLeQuai"

        // Direction 1
        val direction1Title = prefs.getString("direction1_title", "") ?: ""
        val direction1Time = prefs.getString("direction1_time", "__:__") ?: "__:__"
        val direction1Platform = prefs.getString("direction1_platform", "") ?: ""
        val direction1Status = prefs.getString("direction1_status", "") ?: ""
        val direction1StatusColor = prefs.getString("direction1_status_color", "secondary") ?: "secondary"

        // Direction 2
        val direction2Title = prefs.getString("direction2_title", "") ?: ""
        val direction2Time = prefs.getString("direction2_time", "__:__") ?: "__:__"
        val direction2Platform = prefs.getString("direction2_platform", "") ?: ""
        val direction2Status = prefs.getString("direction2_status", "") ?: ""
        val direction2StatusColor = prefs.getString("direction2_status_color", "secondary") ?: "secondary"

        val lastUpdate = prefs.getString("last_update", "") ?: ""

        // Met à jour les vues
        views.setTextViewText(R.id.widget_trip_name, tripName)

        // Direction 1
        views.setTextViewText(R.id.widget_direction1_title, direction1Title)
        views.setTextViewText(R.id.widget_direction1_time, direction1Time)
        views.setTextViewText(R.id.widget_direction1_platform, direction1Platform)
        views.setTextViewText(R.id.widget_direction1_status, direction1Status)
        views.setTextViewText(R.id.widget_direction1_emoji, getStatusEmoji(direction1StatusColor))
        views.setTextColor(R.id.widget_direction1_status, getStatusColor(direction1StatusColor))

        // Direction 2
        views.setTextViewText(R.id.widget_direction2_title, direction2Title)
        views.setTextViewText(R.id.widget_direction2_time, direction2Time)
        views.setTextViewText(R.id.widget_direction2_platform, direction2Platform)
        views.setTextViewText(R.id.widget_direction2_status, direction2Status)
        views.setTextViewText(R.id.widget_direction2_emoji, getStatusEmoji(direction2StatusColor))
        views.setTextColor(R.id.widget_direction2_status, getStatusColor(direction2StatusColor))

        // Dernière mise à jour
        views.setTextViewText(R.id.widget_last_update, "Mis à jour: $lastUpdate")

        // Configure le tap pour ouvrir l'app
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = android.app.PendingIntent.getActivity(
            context, 0, intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_trip_name, pendingIntent)

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
