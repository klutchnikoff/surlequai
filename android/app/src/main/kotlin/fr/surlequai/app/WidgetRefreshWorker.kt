package fr.surlequai.app

import android.content.Context
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class WidgetRefreshWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    override fun doWork(): Result {
        Log.d("SurLeQuai", "WidgetRefreshWorker: doWork() started")

        val manager = AppWidgetManager.getInstance(applicationContext)
        val component = ComponentName(applicationContext, SurLeQuaiWidgetProvider::class.java)
        for (id in manager.getAppWidgetIds(component)) {
            SurLeQuaiWidgetProvider.updateAppWidget(applicationContext, manager, id)
        }

        // Le réveil périodique de secours ne doit pas interroger l'API la nuit :
        // personne ne consulte ses horaires, et le quota est partagé.
        if (!RefreshBudget.isActive(System.currentTimeMillis())) {
            Log.d("SurLeQuai", "WidgetRefreshWorker: hors plage active, aucun appel")
            return Result.success()
        }

        return try {
            // Déclencher le callback Dart via le plugin home_widget
            // HomeWidgetBackgroundIntent retourne un PendingIntent
            val pendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
                applicationContext,
                null  // uri peut être null
            )

            // Envoyer le PendingIntent pour déclencher le callback Dart
            pendingIntent.send()

            Log.d("SurLeQuai", "WidgetRefreshWorker: background callback triggered successfully")
            Result.success()
        } catch (e: Exception) {
            Log.e("SurLeQuai", "WidgetRefreshWorker: failed to trigger background callback", e)
            Result.failure()
        }
    }
}
