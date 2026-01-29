import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:surlequai/models/station.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

enum MorningDirection { aToB, bToA }

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required Station stationA,
    required Station stationB,
    required MorningDirection morningDirection,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}