/// Version d'une grille horaire théorique
///
/// Représente les métadonnées d'une grille horaire SNCF/TER
/// Permet de détecter les mises à jour et gérer le cache local
class TimetableVersion {
  final String version;
  final String region;
  final DateTime validFrom;
  final DateTime validUntil;
  final DateTime? downloadedAt;
  final int? sizeBytes;

  const TimetableVersion({
    required this.version,
    required this.region,
    required this.validFrom,
    required this.validUntil,
    this.downloadedAt,
    this.sizeBytes,
  });

  /// Vérifie si la grille horaire est valide pour une date donnée
  bool isValidFor(DateTime date) {
    return date.isAfter(validFrom) &&
        (date.isBefore(validUntil) || date.isAtSameMomentAs(validUntil));
  }

  /// Vérifie si cette version est plus récente qu'une autre
  bool isNewerThan(TimetableVersion? other) {
    if (other == null) return true;
    return validFrom.isAfter(other.validFrom);
  }

  factory TimetableVersion.fromJson(Map<String, dynamic> json) {
    return TimetableVersion(
      version: json['version'] as String,
      region: json['region'] as String,
      validFrom: DateTime.parse(json['valid_from'] as String),
      validUntil: DateTime.parse(json['valid_until'] as String),
      downloadedAt: json['downloaded_at'] != null
          ? DateTime.parse(json['downloaded_at'] as String)
          : null,
      sizeBytes: json['size_bytes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'region': region,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'downloaded_at': downloadedAt?.toIso8601String(),
      'size_bytes': sizeBytes,
    };
  }

  TimetableVersion copyWith({
    String? version,
    String? region,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime? downloadedAt,
    int? sizeBytes,
  }) {
    return TimetableVersion(
      version: version ?? this.version,
      region: region ?? this.region,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }

  @override
  String toString() =>
      'TimetableVersion(version: $version, region: $region, validFrom: $validFrom, validUntil: $validUntil)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimetableVersion &&
        other.version == version &&
        other.region == region;
  }

  @override
  int get hashCode => version.hashCode ^ region.hashCode;
}
