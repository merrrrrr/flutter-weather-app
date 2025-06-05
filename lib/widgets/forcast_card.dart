import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
	final String time;
	final String icon;
	final double temp;
  const ForecastCard({super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
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
								time,
							),
																						
							Image.network(
								'http:$icon',
								width: 50.0,
								height: 50.0,
							),
																						
							Text(
								style: TextStyle(
									fontWeight: FontWeight.bold,
								),
								'$temp°C',
							),
						],
					),
				),
			),
		);
  }
}