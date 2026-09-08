package fr.surlequai.app

import java.util.Calendar
import java.util.concurrent.TimeUnit

/**
 * Cadence des réveils du widget.
 *
 * Le quota de l'API amont est partagé par tous les utilisateurs : un réveil
 * inutile consomme un budget commun. Le widget interroge donc fréquemment
 * à l'approche d'un départ, rarement le reste du temps, et pas la nuit.
 */
object RefreshBudget {

    /**
     * Fenêtre avant un départ où la précision prime sur l'économie. Elle reste
     * courte : sur une ligne desservie toutes les demi-heures, une fenêtre large
     * maintiendrait la cadence fine en permanence.
     */
    val PRECISE_WINDOW: Long = TimeUnit.MINUTES.toMillis(15)

    /** Cadence dans cette fenêtre : un retard n'évolue pas de minute en minute. */
    val PRECISE_INTERVAL: Long = TimeUnit.MINUTES.toMillis(10)

    /** Cadence hors de cette fenêtre, et quand aucun départ n'est connu. */
    val IDLE_INTERVAL: Long = TimeUnit.MINUTES.toMillis(30)

    /** WorkManager ignore les délais trop courts ; on garde une marge. */
    private const val MINIMUM_DELAY = 5_000L

    const val ACTIVE_FROM_HOUR = 5
    const val ACTIVE_UNTIL_HOUR = 23

    /** Vrai lorsque des trains sont susceptibles d'intéresser l'utilisateur. */
    fun isActive(now: Long): Boolean = millisUntilActiveWindow(now) == 0L

    /** Délai avant la reprise du service, ou 0 si la plage est déjà ouverte. */
    fun millisUntilActiveWindow(now: Long): Long {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = now
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        if (hour >= ACTIVE_FROM_HOUR && hour < ACTIVE_UNTIL_HOUR) return 0L
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        if (hour >= ACTIVE_UNTIL_HOUR) calendar.add(Calendar.DAY_OF_YEAR, 1)
        calendar.set(Calendar.HOUR_OF_DAY, ACTIVE_FROM_HOUR)
        return maxOf(0L, calendar.timeInMillis - now)
    }

    /**
     * Délai avant le prochain réveil. Hors plage active on dort jusqu'à la
     * reprise ; loin d'un départ on se contente d'un réveil espacé, quitte à
     * viser l'entrée dans la fenêtre de précision.
     */
    fun nextDelay(now: Long, nextDeparture: Long?): Long {
        val asleep = millisUntilActiveWindow(now)
        if (asleep > 0L) return asleep
        if (nextDeparture == null || nextDeparture <= now) return IDLE_INTERVAL
        val untilDeparture = nextDeparture - now
        return if (untilDeparture <= PRECISE_WINDOW) {
            maxOf(MINIMUM_DELAY, minOf(PRECISE_INTERVAL, untilDeparture))
        } else {
            minOf(IDLE_INTERVAL, untilDeparture - PRECISE_WINDOW)
        }
    }
}
