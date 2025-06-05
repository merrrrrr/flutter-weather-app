import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
	final int forecastHours;
	final String unit;
	final Map<String, bool> additionalInfo;

	SettingsState({
		this.forecastHours = 6,
		this.unit = 'metric',
		this.additionalInfo = const {
			'humidity': true,
			'pressure': true,
			'windSpeed': true,
			'windDirection': true,
			'visibility': true,
			'uvIndex': true,
			'airQualityIndex': true,
		},
});

	SettingsState copyWith({
		int? forecastHours,
		String? unit,
		Map<String, bool>? additionalInfo,
	}) {
		return SettingsState(
			forecastHours: forecastHours ?? this.forecastHours,
			unit: unit ?? this.unit,
			additionalInfo: additionalInfo ?? this.additionalInfo,
		);
	}
}

class SettingsProvider extends StateNotifier<SettingsState> {
	SettingsProvider() : super(SettingsState());

	void updateForecastHours(int hours) {
		state = state.copyWith(forecastHours: hours);
	}

	void updateUnit(String unit) {
		state = state.copyWith(unit: unit);
	}

	void updateAdditionalInfo(String key, bool value) {
		final updatedInfo = Map<String, bool>.from(state.additionalInfo);
		updatedInfo[key] = value;
		state = state.copyWith(additionalInfo: updatedInfo);
	}
}

final settingsProvider = StateNotifierProvider<SettingsProvider, SettingsState>(
		(ref) => SettingsProvider(),
);