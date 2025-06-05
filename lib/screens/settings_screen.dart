import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whether_app/providers/settings_provider.dart';

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
							settingsNotifier.updateUnit(value as String);
						},
					),

					RadioListTile(
						title: Text('Imperial (The one not logical)'),
						value: 'imperial',
						groupValue: settings.unit,
						onChanged: (value) {
							settingsNotifier.updateUnit(value as String);
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
						value: settings.additionalInfo['humidity'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('humidity', value!);
						},
						title: Text('Humidity')
					),

					CheckboxListTile(
						value: settings.additionalInfo['pressure'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('pressure', value!);
						},
						title: Text('Pressure')
					),

					CheckboxListTile(
						value: settings.additionalInfo['windSpeed'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('windSpeed', value!);
						},
						title: Text('Wind Speed')
					),

					CheckboxListTile(
						value: settings.additionalInfo['windDirection'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('windDirection', value!);
						},
						title: Text('Wind Direction')
					),

					CheckboxListTile(
						value: settings.additionalInfo['visibility'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('visibility', value!);
						},
						title: Text('Visibility')
					),

					CheckboxListTile(
						value: settings.additionalInfo['uvIndex'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('uvIndex', value!);
						},
						title: Text('UV Index')
					),

					CheckboxListTile(
						value: settings.additionalInfo['airQualityIndex'] ?? true,
						onChanged: (value) {
							settingsNotifier.updateAdditionalInfo('Air Quality Index', value!);
						},
						title: Text('Air Quality Index')
					),
				],
			),
		);
  }
}