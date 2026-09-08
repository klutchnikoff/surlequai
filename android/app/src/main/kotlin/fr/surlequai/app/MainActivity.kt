package fr.surlequai.app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.surlequai.app/widget"
    private var methodChannel: MethodChannel? = null
    private var pendingTripId: String? = null
    private var dartReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Créer le MethodChannel pour communiquer avec Flutter
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "takeInitialTrip") {
                dartReady = true
                result.success(pendingTripId)
                pendingTripId = null
            } else {
                result.notImplemented()
            }
        }

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
            if (dartReady) methodChannel?.invokeMethod("switchToTrip", tripId)
            else pendingTripId = tripId
        }
    }
}
