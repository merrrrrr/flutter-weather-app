import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationProvider{
	final String city;

	LocationProvider({required this.city});

	copyWith({String? city}) {
		return LocationProvider(
			city: city ?? this.city,
		);
	}
}

class LocationNotifierProvider extends StateNotifier<LocationProvider> {
	LocationNotifierProvider() : super(LocationProvider(city: 'Kuala Lumpur'));
	
	void updateCity(String newCity) {
		state = state.copyWith(city: newCity);
	}
}

final locationNotifier = StateNotifierProvider<LocationNotifierProvider, LocationProvider>(
	(ref) => LocationNotifierProvider(),
);