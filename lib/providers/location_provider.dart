import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationState{
	final String city;

	LocationState({required this.city});

	LocationState copyWith({String? city}) {
		return LocationState(
			city: city ?? this.city,
		);
	}
}

class LocationNotifier extends StateNotifier<LocationState> {
	LocationNotifier() : super(LocationState(city: 'Kuala Lumpur')) {
		_loadSavedCity();
	}

	void _loadSavedCity() async {
		final prefs = await SharedPreferences.getInstance();
		final savedCity = prefs.getString('city');
		if (savedCity != null && savedCity.isNotEmpty) {
      state = LocationState(city: savedCity);
    }
	}

	void _saveCity() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString('city', state.city);
	}
	
	void updateCity(String newCity) {
		state = state.copyWith(city: newCity);
		_saveCity();
	}
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
	(ref) => LocationNotifier()
);