import 'package:flutter/material.dart';
import 'package:surlequai/models/station.dart';
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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredStations = StationsData.searchStations(query);
    });
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

          // Nombre de résultats
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
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
            child: _filteredStations.isEmpty
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
                          'Essayez une autre recherche',
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
