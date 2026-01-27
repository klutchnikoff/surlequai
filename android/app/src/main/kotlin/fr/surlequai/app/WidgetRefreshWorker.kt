package fr.surlequai.app

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class WidgetRefreshWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    override fun doWork(): Result {
        Log.d("SurLeQuai", "WidgetRefreshWorker: doWork() started")

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
