import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/theme/text_styles.dart';
import 'package:surlequai/utils/stations_data.dart';

class StationPickerScreen extends StatefulWidget {
  final String title;

  const StationPickerScreen({
    super.key,
    required this.title,
  });

  @override
  State<StationPickerScreen> createState() => _StationPickerScreenState();
}

class _StationPickerScreenState extends State<StationPickerScreen> {
  String _searchQuery = '';
  List<Station> _filteredStations = StationsData.mainStations;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _errorMessage = null;
    });

    // Annuler le timer précédent
    _debounce?.cancel();

    // Si la recherche est vide, afficher les gares principales
    if (query.isEmpty) {
      setState(() {
        _filteredStations = StationsData.mainStations;
        _isLoading = false;
      });
      return;
    }

    // Si moins de 2 caractères, ne pas lancer la recherche
    if (query.length < 2) {
      setState(() {
        _filteredStations = [];
        _isLoading = false;
      });
      return;
    }

    // Attendre 500ms avant de lancer la recherche (debouncing)
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });

    // Afficher le loader immédiatement
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> _performSearch(String query) async {
    final apiService = context.read<ApiService>();

    try {
      final results = await apiService.searchStations(query, limit: 50);

      // Vérifier que la recherche correspond toujours à la query actuelle
      if (_searchQuery == query) {
        setState(() {
          _filteredStations = results;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } on SocketException {
      if (_searchQuery == query) {
        setState(() {
          _filteredStations = [];
          _isLoading = false;
          _errorMessage = 'Pas de connexion Internet';
        });
      }
    } on TimeoutException {
      if (_searchQuery == query) {
        setState(() {
          _filteredStations = [];
          _isLoading = false;
          _errorMessage = 'Délai d\'attente dépassé';
        });
      }
    } catch (e) {
      if (_searchQuery == query) {
        setState(() {
          _filteredStations = [];
          _isLoading = false;
          _errorMessage = 'Erreur de recherche';
        });
      }
    }
  }

  void _selectStation(Station station) {
    Navigator.pop(context, station);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Rechercher une gare...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _filteredStations = StationsData.mainStations;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Nombre de résultats ou message d'erreur
          if (_searchQuery.isNotEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _errorMessage != null
                    ? Row(
                        children: [
                          const Icon(Icons.error_outline, size: 16, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            _errorMessage!,
                            style: AppTextStyles.tiny.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '${_filteredStations.length} résultat${_filteredStations.length > 1 ? 's' : ''}',
                        style: AppTextStyles.tiny.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
              ),
            ),

          const SizedBox(height: 8),

          // Liste des gares
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Recherche en cours...',
                          style: AppTextStyles.small,
                        ),
                      ],
                    ),
                  )
                : _filteredStations.isEmpty && _searchQuery.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucune gare trouvée',
                              style: AppTextStyles.medium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage ?? 'Essayez une autre recherche',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = _filteredStations[index];
                          return ListTile(
                            leading: const Icon(Icons.train),
                            title: Text(station.name),
                            onTap: () => _selectStation(station),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
