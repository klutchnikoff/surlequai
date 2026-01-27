package fr.surlequai.app

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.TextView
import org.json.JSONArray
import org.json.JSONObject

/**
 * Activity de configuration du widget SurLeQuai
 *
 * Permet à l'utilisateur de choisir quel trajet ce widget doit afficher.
 * S'affiche automatiquement lors de l'ajout d'un nouveau widget.
 */
class SurLeQuaiWidgetConfigureActivity : Activity() {

    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Configuration obligatoire : retour CANCELED par défaut
        // Si l'utilisateur annule, le widget ne sera pas ajouté
        setResult(RESULT_CANCELED)

        // Récupérer l'ID du widget en cours de configuration
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

        if (tripsJson == null || tripsJson == "[]") {
            // Pas de trajets disponibles
            showNoTripsMessage()
            return
        }

        try {
            // Parser les trajets depuis JSON
            val tripsArray = JSONArray(tripsJson)
            val tripsList = mutableListOf<TripItem>()

            for (i in 0 until tripsArray.length()) {
                val tripObj = tripsArray.getJSONObject(i)
                val id = tripObj.getString("id")
                val stationA = tripObj.getJSONObject("stationA").getString("name")
                val stationB = tripObj.getJSONObject("stationB").getString("name")

                tripsList.add(TripItem(
                    id = id,
                    name = "$stationA ⟷ $stationB"
                ))
            }

            if (tripsList.isEmpty()) {
                showNoTripsMessage()
                return
            }

            // Afficher la liste des trajets
            val listView = findViewById<ListView>(R.id.trips_list)
            val adapter = TripAdapter(this, tripsList)
            listView.adapter = adapter

            // Gestion du clic sur un trajet
            listView.setOnItemClickListener { _, _, position, _ ->
                val selectedTrip = tripsList[position]
                onTripSelected(selectedTrip)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            showNoTripsMessage()
        }
    }

    private fun showNoTripsMessage() {
        findViewById<ListView>(R.id.trips_list).visibility = View.GONE
        findViewById<TextView>(R.id.no_trips_message).apply {
            visibility = View.VISIBLE
            text = "Aucun trajet disponible.\n\nAjoutez un trajet dans l'application SurLeQuai d'abord."
        }
    }

    private fun onTripSelected(trip: TripItem) {
        // Sauvegarder l'ID du trajet pour ce widget
        saveTripIdForWidget(trip.id)

        // Mettre à jour le widget immédiatement
        val appWidgetManager = AppWidgetManager.getInstance(this)
        SurLeQuaiWidgetProvider.updateAppWidget(this, appWidgetManager, appWidgetId)
        SurLeQuaiWidgetProvider.scheduleNextUpdate(this, appWidgetId)

        // Retourner OK pour confirmer la configuration
        val resultValue = Intent().apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        }
        setResult(RESULT_OK, resultValue)
        finish()
    }

    private fun saveTripIdForWidget(tripId: String) {
        val prefs = getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        prefs.edit().putString("widget_${appWidgetId}_trip_id", tripId).apply()
    }

    /**
     * Représente un trajet dans la liste
     */
    data class TripItem(val id: String, val name: String)

    /**
     * Adapter custom pour afficher les trajets avec un style cohérent
     */
    private class TripAdapter(
        context: Context,
        private val trips: List<TripItem>
    ) : ArrayAdapter<TripItem>(context, 0, trips) {

        override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
            val view = convertView ?: android.view.LayoutInflater.from(context).inflate(
                android.R.layout.simple_list_item_1,
                parent,
                false
            )

            val trip = trips[position]
            val textView = view.findViewById<TextView>(android.R.id.text1)
            textView.text = trip.name
            textView.textSize = 18f
            textView.setPadding(32, 32, 32, 32)

            return view
        }
    }
}
