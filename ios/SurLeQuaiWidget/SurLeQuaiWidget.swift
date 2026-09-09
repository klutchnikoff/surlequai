import AppIntents
import SwiftUI
import WidgetKit

struct DirectionData: Decodable {
    let title: String
    let time: String
    let platform: String
    let status: String
    let color: String

    var statusColor: Color {
        switch color {
        case "onTime": return .green
        case "delayed": return .orange
        case "cancelled": return .red
        case "offline": return .blue
        default: return .secondary
        }
    }
}

struct WidgetFrame: Decodable {
    let date: Double
    let direction1: DirectionData
    let direction2: DirectionData
}

struct TripSnapshot: Decodable {
    let id: String
    let name: String
    let updatedAt: Double?
    /// Échéance du prochain réveil, décidée par Flutter (millisecondes epoch).
    let nextRefreshDue: Double?
    let frames: [WidgetFrame]
}

struct WidgetSnapshot: Decodable {
    let trips: [TripSnapshot]

    static func load() -> [TripSnapshot] {
        guard let text = UserDefaults(suiteName: "group.com.surlequai.app")?.string(forKey: "widget_snapshot"),
              let data = text.data(using: .utf8),
              let snapshot = try? JSONDecoder().decode(WidgetSnapshot.self, from: data) else { return [] }
        return snapshot.trips
    }
}

struct TripEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Trajet"
    static var defaultQuery = TripQuery()
    let id: String
    let name: String
    var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "\(name)") }
}

struct TripQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [TripEntity] {
        WidgetSnapshot.load().filter { identifiers.contains($0.id) }.map { TripEntity(id: $0.id, name: $0.name) }
    }
    func suggestedEntities() async throws -> [TripEntity] {
        WidgetSnapshot.load().map { TripEntity(id: $0.id, name: $0.name) }
    }
    func defaultResult() async -> TripEntity? {
        WidgetSnapshot.load().first.map { TripEntity(id: $0.id, name: $0.name) }
    }
}

struct TripConfiguration: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Choisir un trajet"
    static var description = IntentDescription("Affiche les prochains départs d’un trajet favori.")
    @Parameter(title: "Trajet") var trip: TripEntity?
}

struct TrainEntry: TimelineEntry {
    let date: Date
    let trip: TripSnapshot?
    let frame: WidgetFrame?
}

/// Cadence des rechargements de timeline.
///
/// Le quota de l'API amont est partagé par tous les utilisateurs : une timeline
/// est redemandée souvent à l'approche d'un départ, rarement le reste du temps,
/// et pas du tout la nuit. Les entrées déjà connues continuent de s'afficher
/// entre-temps, sans appel réseau.
enum RefreshBudget {
    // Fenêtre courte : sur une ligne desservie toutes les demi-heures, une
    // fenêtre large maintiendrait la cadence fine en permanence.
    static let preciseWindow: TimeInterval = 15 * 60
    static let preciseInterval: TimeInterval = 10 * 60
    static let idleInterval: TimeInterval = 30 * 60
    static let activeFromHour = 5
    static let activeUntilHour = 23

    static func nextRefresh(after now: Date, nextDeparture: Date?, calendar: Calendar = .current) -> Date {
        if let resume = resumeDate(after: now, calendar: calendar) { return resume }
        guard let nextDeparture, nextDeparture > now else {
            return now.addingTimeInterval(idleInterval)
        }
        let untilDeparture = nextDeparture.timeIntervalSince(now)
        if untilDeparture <= preciseWindow {
            return now.addingTimeInterval(min(preciseInterval, untilDeparture))
        }
        return now.addingTimeInterval(min(idleInterval, untilDeparture - preciseWindow))
    }

    /// Début de la prochaine plage active, ou nil si elle est déjà ouverte.
    static func resumeDate(after now: Date, calendar: Calendar = .current) -> Date? {
        let hour = calendar.component(.hour, from: now)
        if hour >= activeFromHour && hour < activeUntilHour { return nil }
        let day = hour >= activeUntilHour
            ? calendar.date(byAdding: .day, value: 1, to: now) ?? now
            : now
        return calendar.date(bySettingHour: activeFromHour, minute: 0, second: 0, of: day)
    }
}

struct TrainProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TrainEntry {
        TrainEntry(date: .now, trip: nil, frame: nil)
    }
    func snapshot(for configuration: TripConfiguration, in context: Context) async -> TrainEntry {
        entries(configuration).first ?? placeholder(in: context)
    }
    func timeline(for configuration: TripConfiguration, in context: Context) async -> Timeline<TrainEntry> {
        let items = entries(configuration)
        let now = Date()
        // L'échéance publiée par Flutter fait foi : la cadence est décidée à un
        // seul endroit. La règle locale ne sert que si elle manque, par exemple
        // avant le tout premier rafraîchissement.
        let published = items.first?.trip?.nextRefreshDue
            .map { Date(timeIntervalSince1970: $0 / 1000) }
        // La première entrée décrit l'instant présent ; la suivante correspond au
        // prochain changement d'affichage, donc au prochain départ connu.
        let fallback = RefreshBudget.nextRefresh(
            after: now,
            nextDeparture: items.dropFirst().first?.date
        )
        // WidgetKit ignore une date déjà passée : on garde une minute de plancher.
        let next = max(published ?? fallback, now.addingTimeInterval(60))
        return Timeline(entries: items, policy: .after(next))
    }
    private func entries(_ configuration: TripConfiguration) -> [TrainEntry] {
        let now = Date()
        let trips = WidgetSnapshot.load()
        let trip = configuration.trip.map { selected in trips.first { $0.id == selected.id } } ?? trips.first
        guard let trip else { return [TrainEntry(date: now, trip: nil, frame: nil)] }
        let frames = trip.frames.sorted { $0.date < $1.date }
        let milliseconds = now.timeIntervalSince1970 * 1000
        let current = frames.last { $0.date <= milliseconds }
        var entries = [TrainEntry(date: now, trip: trip, frame: current)]
        entries += frames.filter { $0.date > milliseconds }.map {
            TrainEntry(date: Date(timeIntervalSince1970: $0.date / 1000), trip: trip, frame: $0)
        }
        return entries
    }
}

struct TrainWidgetView: View {
    let entry: TrainEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let trip = entry.trip, let frame = entry.frame {
                Text(trip.name).font(.caption.bold()).lineLimit(1)
                HStack(alignment: .top, spacing: 12) {
                    direction(frame.direction1)
                    if family != .systemSmall { Divider(); direction(frame.direction2) }
                }
                if let updated = trip.updatedAt {
                    HStack(spacing: 3) {
                        Text("Données :")
                        Text(Date(timeIntervalSince1970: updated / 1000), style: .relative)
                    }.font(.caption2).foregroundStyle(.secondary)
                } else {
                    Text("Aucune donnée récente").font(.caption2).foregroundStyle(.secondary)
                }
            } else {
                Text("SurLeQuai").font(.headline)
                Text("Ajoutez ou sélectionnez un trajet dans l’application.").font(.caption)
            }
        }
        .widgetURL(widgetURL)
        .containerBackground(.background, for: .widget)
    }

    private var widgetURL: URL? {
        var url = URLComponents()
        url.scheme = "surlequai"
        url.host = "trip"
        url.queryItems = [URLQueryItem(name: "homeWidget", value: "true")]
        if let trip = entry.trip { url.queryItems?.append(URLQueryItem(name: "tripId", value: trip.id)) }
        return url.url
    }

    private func direction(_ data: DirectionData) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(data.title).font(.caption).lineLimit(1)
            Text(data.time).font(.title.bold()).minimumScaleFactor(0.6).lineLimit(1)
            if !data.platform.isEmpty { Text(data.platform).font(.caption) }
            Text(data.status).font(.caption2).foregroundStyle(data.statusColor).lineLimit(3)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SurLeQuaiWidget: Widget {
    let kind = "SurLeQuaiWidget"
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: TripConfiguration.self, provider: TrainProvider()) { entry in
            TrainWidgetView(entry: entry)
        }
        .configurationDisplayName("SurLeQuai")
        .description("Les prochains départs de votre trajet favori.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
