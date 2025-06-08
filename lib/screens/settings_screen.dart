import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

	@override
	ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
		final settings = ref.watch(settingsProvider);
		final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
			appBar: AppBar(
				title: Text(
					'Settings',
					style: TextStyle(
						fontWeight: FontWeight.bold,
					),
				),
			),

			body: Column(
				children: [
					Container(
						alignment: Alignment.centerLeft,
						child: Text(
							'Forecast Hours',
							style: TextStyle(
								fontSize: 16,
							),
						),
					),

					Slider(
						value: settings.forecastHours.toDouble(),
						min: 1,
						max: 24,
						divisions: 23,
						label: '${settings.forecastHours} hours',
						onChanged: (value) {
							settingsNotifier.updateForecastHours(value.toInt());
						},
					),

					Divider(),

					// Unit
					Container(
						alignment: Alignment.centerLeft,
						child: Text(
							'Unit',
						 style: TextStyle(
								fontSize: 16,
							),
						),
					),

					RadioListTile(
						title: Text('Metric'),
						value: 'metric',
						groupValue: settings.unit, 
						onChanged: (value) {
							if (value != null) {
								settingsNotifier.updateUnit(value);
							}
						},
					),

					RadioListTile(
						title: Text('Imperial'),
						value: 'imperial',
						groupValue: settings.unit,
						onChanged: (value) {
							if (value != null) {
								settingsNotifier.updateUnit(value);
							}
						},
					),

					Divider(),
					

					// Additional Information
					Container(
						alignment: Alignment.centerLeft,
						child: Text(
							'Additional Information',
							style: TextStyle(
								fontSize: 16,
							),
						),
					),

					CheckboxListTile(
						value: settings.additionalInfo['humidity'],
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('humidity', value!);
						},
						title: Text('Humidity')
					),

					CheckboxListTile(
						value: settings.additionalInfo['pressure'],
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('pressure', value!);
						},
						title: Text('Pressure')
					),

					CheckboxListTile(
						value: settings.additionalInfo['windSpeed'],
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('windSpeed', value!);
						},
						title: Text('Wind Speed')
					),

					CheckboxListTile(
						value: settings.additionalInfo['windDirection'],
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('windDirection', value!);
						},
						title: Text('Wind Direction')
					),

					CheckboxListTile(
						value: settings.additionalInfo['visibility'],
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('visibility', value!);
						},
						title: Text('Visibility')
					),

					CheckboxListTile(
						value: settings.additionalInfo['uvIndex'],
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('uvIndex', value!);
						},
						title: Text('UV Index')
					),

				],
			),
		);
  }
}