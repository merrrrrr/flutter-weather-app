import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
	final int forecastHours;
	final String unit;
	final Map<String, bool> additionalInfo;

	SettingsState({
		required this.forecastHours,
		required this.unit,
		required this.additionalInfo
	});

	SettingsState copyWith({int? forecastHours, String? unit, Map<String, bool>? additionalInfo}) {
		return SettingsState(
			forecastHours: forecastHours ?? this.forecastHours,
			unit: unit ?? this.unit,
			additionalInfo: additionalInfo ?? this.additionalInfo
		);
	}
}

class SettingsNotifier extends StateNotifier<SettingsState> {
	SettingsNotifier() : super(SettingsState(
		forecastHours: 12,
		unit: 'metric',
		additionalInfo: {
			'humidity': true,
			'pressure': true,
			'windSpeed': true,
			'windDirection': false,
			'visibility': false,
			'uvIndex': false,
		}
	)) {
		_loadSavedSettings();
	}

	void _loadSavedSettings() async {
		final prefs = await SharedPreferences.getInstance();
		final savedForecastHours = prefs.getInt('forecastHours'); 
		final savedUnit = prefs.getString('unit');
		final savedAdditionalInfo = prefs.getString('additionalInfo');

		state = SettingsState(
			forecastHours: savedForecastHours ?? 12,
			unit: savedUnit ?? 'metric',
			additionalInfo: savedAdditionalInfo != null ? 
				Map<String, bool>.from(
					(Map<String, dynamic>.from(jsonDecode(savedAdditionalInfo)))
				) : {
					'humidity': true,
					'pressure': true,
					'windSpeed': true,
					'windDirection': false,
					'visibility': false,
					'uvIndex': false,
				}
		);
	}

	void _saveSettings() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setInt('forecastHours', state.forecastHours);
		await prefs.setString('unit', state.unit);
		await prefs.setString('additionalInfo', jsonEncode(state.additionalInfo));
	}

	void updateForecastHours(int newForecastHours) {
		state = state.copyWith(forecastHours: newForecastHours);
		_saveSettings();
	}

	void updateUnit(String newUnit) {
		state = state.copyWith(unit: newUnit);
		_saveSettings();
	}

	void updateAdditionalInfo(String key, bool newValue) {
		final newAdditionalInfo = Map<String, bool>.from(state.additionalInfo);
		newAdditionalInfo[key] = newValue;
		state = state.copyWith(additionalInfo: newAdditionalInfo);
		_saveSettings();
	}
}


final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
	(ref) => SettingsNotifier(),
) ;