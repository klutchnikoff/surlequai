package fr.surlequai.app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.surlequai.app/widget"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Créer le MethodChannel pour communiquer avec Flutter
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        // Vérifier s'il y a un tripId dans l'Intent de démarrage
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Gérer les nouveaux Intents (quand l'app est déjà ouverte)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        val tripId = intent?.getStringExtra("widget_trip_id")

        if (tripId != null) {
            // Envoyer le tripId à Flutter pour basculer vers ce trajet
            methodChannel?.invokeMethod("switchToTrip", tripId)
        }
    }
}
