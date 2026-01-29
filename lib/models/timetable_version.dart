import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_version.freezed.dart';
part 'timetable_version.g.dart';

@freezed
class TimetableVersion with _$TimetableVersion {
  const factory TimetableVersion({
    required String version,
    required String region,
    required DateTime validFrom,
    required DateTime validUntil,
    required DateTime downloadedAt,
    int? sizeBytes,
  }) = _TimetableVersion;

  factory TimetableVersion.fromJson(Map<String, dynamic> json) =>
      _$TimetableVersionFromJson(json);
}