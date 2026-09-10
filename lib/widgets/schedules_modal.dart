import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/utils/service_day.dart';
import 'package:surlequai/theme/app_theme.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/formatters.dart';

class SchedulesModal extends StatefulWidget {
  final String title;
  final String fromStationId;
  final String toStationId;

  const SchedulesModal({
    super.key,
    required this.title,
    required this.fromStationId,
    required this.toStationId,
  });

  @override
  State<SchedulesModal> createState() => _SchedulesModalState();
}

class _SchedulesModalState extends State<SchedulesModal> {
  bool _hasScrolled = false;
  bool _isLoading = true;
  String? _todayError;
  String? _tomorrowError;
  int _pendingDays = 2;
  List<Departure> _todayDepartures = [];
  List<Departure> _tomorrowDepartures = [];

  @override
  void initState() {
    super.initState();
    _loadDepartures();
  }

  Future<void> _loadDepartures() async {
    final apiService = context.read<ApiService>();
    final now = DateTime.now();

    final settings = context.read<SettingsProvider>();
    final hour = settings.serviceDayStartTime;
    final transport = settings.transport;
    final todayServiceStart = ServiceDay.start(now, hour);
    final tomorrowServiceStart = ServiceDay.next(todayServiceStart);

    Future<void> loadDay(DateTime start, {required bool tomorrow}) async {
      List<Departure> departures = [];
      String? error;
      try {
        final result = await apiService.getTheoreticalSchedule(
          fromStationId: widget.fromStationId,
          toStationId: widget.toStationId,
          datetime: start,
          count: AppConstants.maxTrainsPerDay,
          serviceDayStartHour: hour,
          transport: transport,
        );
        final end = ServiceDay.next(start);
        departures = result
            .where(
              (d) =>
                  !d.scheduledTime.isBefore(start) &&
                  d.scheduledTime.isBefore(end),
            )
            .toList();
      } catch (_) {
        error = tomorrow
            ? 'Horaires de demain indisponibles.'
            : 'Horaires d’aujourd’hui indisponibles.';
      }
      if (!mounted) return;
      setState(() {
        if (tomorrow) {
          _tomorrowDepartures = departures;
          _tomorrowError = error;
        } else {
          _todayDepartures = departures;
          _todayError = error;
        }
        _pendingDays--;
        _isLoading = false;
      });
    }

    // Chaque journée peut s’afficher même si l’autre échoue ou reste en attente.
    await Future.wait([
      loadDay(todayServiceStart, tomorrow: false),
      loadDay(tomorrowServiceStart, tomorrow: true),
    ]);
  }

  void _scrollToNextDeparture(
    ScrollController controller,
    int nextDepartureIndex,
  ) {
    // Ne scroller qu'une seule fois
    if (_hasScrolled || nextDepartureIndex == -1) return;

    _hasScrolled = true;

    // Attendre que le widget soit construit avant de scroller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;

      // Hauteur approximative d'un ListTile dense
      const itemHeight = 56.0;

      // Calculer la position à scroller
      // On scroll pour que le prochain train soit visible avec une ligne au-dessus
      // pour donner du contexte (sauf si c'est le premier train)
      final targetIndex = nextDepartureIndex > 0 ? nextDepartureIndex - 1 : 0;
      final offset = targetIndex * itemHeight;

      // Scroller avec animation douce
      controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildDeparturesList(ScrollController controller) {
    final now = DateTime.now();
    final nextDepartureIndex = _todayDepartures.indexWhere(
      (d) => d.scheduledTime.isAfter(now),
    );

    // Scroller vers le prochain train
    if (nextDepartureIndex != -1) {
      _scrollToNextDeparture(controller, nextDepartureIndex);
    }

    // Construire la liste combinée
    final items = <Widget>[if (_todayError != null) Text(_todayError!)];

    // Trains d'aujourd'hui
    for (int i = 0; i < _todayDepartures.length; i++) {
      final departure = _todayDepartures[i];
      final isNext = i == nextDepartureIndex;
      final isPast = departure.scheduledTime.isBefore(now);
      items.add(_buildDepartureItem(departure, isNext, isPast, false));
    }

    // Séparateur
    if (_tomorrowDepartures.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Demain',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
      );

      // Trains de demain
      for (final departure in _tomorrowDepartures) {
        items.add(_buildDepartureItem(departure, false, false, true));
      }
    }

    if (_tomorrowError != null) items.add(Text(_tomorrowError!));
    if (_pendingDays > 0) {
      items.add(const Text('Chargement des autres horaires...'));
    }
    return ListView(controller: controller, children: items);
  }

  Widget _buildDepartureItem(
    Departure departure,
    bool isNext,
    bool isPast,
    bool isTomorrow,
  ) {
    // Déterminer la couleur selon le statut
    Color statusColor;
    switch (departure.status) {
      case DepartureStatus.onTime:
        statusColor = AppColors.onTime;
        break;
      case DepartureStatus.delayed:
        statusColor = AppColors.delayed;
        break;
      case DepartureStatus.cancelled:
        statusColor = AppColors.cancelled;
        break;
      case DepartureStatus.offline:
        statusColor = AppColors.offline;
        break;
    }

    // Style selon le contexte
    TextStyle timeStyle;
    TextStyle platformStyle;

    if (isTomorrow) {
      // Trains de demain : grisé
      timeStyle = AppTextStyles.medium.copyWith(
        color: AppColors.secondary.withValues(alpha: 0.6),
      );
      platformStyle = AppTextStyles.medium.copyWith(
        color: AppColors.secondary.withValues(alpha: 0.6),
      );
    } else if (isNext) {
      // Prochain train : couleur selon statut + gras
      timeStyle = AppTextStyles.medium.copyWith(
        color: statusColor,
        fontWeight: FontWeight.bold,
        decoration: departure.status == DepartureStatus.cancelled
            ? TextDecoration.lineThrough
            : null,
      );
      platformStyle = AppTextStyles.medium.copyWith(
        color: statusColor,
        fontWeight: FontWeight.bold,
        decoration: departure.status == DepartureStatus.cancelled
            ? TextDecoration.lineThrough
            : null,
      );
    } else if (isPast) {
      // Trains passés : gris + barré
      timeStyle = AppTextStyles.medium.copyWith(
        color: AppColors.secondary,
        decoration: TextDecoration.lineThrough,
      );
      platformStyle = AppTextStyles.medium.copyWith(
        color: AppColors.secondary,
        decoration: TextDecoration.lineThrough,
      );
    } else {
      // Trains futurs : style normal
      timeStyle = AppTextStyles.medium;
      platformStyle = AppTextStyles.medium;
    }

    // Afficher le statut textuel pour certains cas
    String? statusText;
    if (!isTomorrow) {
      if (departure.status == DepartureStatus.delayed) {
        statusText = '+${departure.delayMinutes} min';
      } else if (departure.status == DepartureStatus.cancelled) {
        statusText = 'Supprimé';
      } else if (departure.status == DepartureStatus.offline) {
        statusText = 'Hors ligne';
      }
    }

    return ListTile(
      dense: true,
      leading: isNext
          ? Icon(Icons.arrow_forward_ios, color: statusColor, size: 16)
          : const SizedBox(width: 24),
      title: Row(
        children: [
          Text(
            '${departure.transportPrefix.isNotEmpty ? '${departure.transportPrefix} · ' : ''}${TimeFormatter.formatTime(departure.scheduledTime)}',
            style: timeStyle,
          ),
          if (statusText != null) ...[
            const SizedBox(width: 8),
            Text(
              statusText,
              style: AppTextStyles.small.copyWith(
                color: statusColor,
                fontWeight: isNext ? FontWeight.bold : null,
                decoration: departure.status == DepartureStatus.cancelled
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ],
        ],
      ),
      trailing: Text(
        departure.platform == '?' ? '' : 'Voie ${departure.platform}',
        style: platformStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.getTertiaryColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              const Text('Fiche horaire', style: AppTextStyles.large),
              Text(
                widget.title,
                style: AppTextStyles.small.copyWith(
                  color: AppTheme.getSecondaryTextColor(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Horaires théoriques',
                style: AppTextStyles.tiny.copyWith(
                  color: AppTheme.getSecondaryTextColor(context),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Chargement des horaires...',
                              style: AppTextStyles.small,
                            ),
                          ],
                        ),
                      )
                    : _buildDeparturesList(controller),
              ),
            ],
          ),
        );
      },
    );
  }
}
