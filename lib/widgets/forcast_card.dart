import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/settings_provider.dart';

class ForecastCard extends ConsumerStatefulWidget {
	final String time;
	final String icon;
	final double temp;
  const ForecastCard({super.key, required this.time, required this.icon, required this.temp});

  @override
  ConsumerState<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends ConsumerState<ForecastCard> {
  @override
  Widget build(BuildContext context) {
		String unit = ref.watch(settingsProvider).unit;

    return SizedBox(
			width: 100.0,
			child: Card(
				elevation: 8.0,
				child: Padding(
					padding: EdgeInsets.all(8.0),
					child: Column(
						spacing: 8.0,
						children: [
							Text(
								style: TextStyle(
									fontWeight: FontWeight.bold
								),
								widget.time,
							),
																						
							Image.network(
								'http:${widget.icon}',
								width: 50.0,
								height: 50.0,
							),
																						
							Text(
								style: TextStyle(
									fontWeight: FontWeight.bold,
								),
								unit == 'metric' ? '${widget.temp}°C' : '${widget.temp}°F',
							),
						],
					),
				),
			),
		);
  }
}