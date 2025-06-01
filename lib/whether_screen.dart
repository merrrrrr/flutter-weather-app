import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:whether_app/forcast_card.dart';
import 'package:whether_app/additional_info_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
	bool isLoading = true;
	String city = '';
	double temp = 0;
	String weather = '';
	String icon = '';
	int humidity = 0;
	double windSpeed = 0;
	int pressure = 0;
	int currentHour = DateTime.now().hour;

	@override
	void initState() {
		super.initState();
		getCurrentWeather();
	}

	Future<Map<String, dynamic>> getCurrentWeather() async {

		try {
			String cityName = 'Penang';
			String apiKey = 'efb25f9d77654438800175305250106';
			final currentRes = await http.get(
				Uri.parse(
					'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=2'
				),
			);

			final currentData = jsonDecode(currentRes.body);

			if (currentRes.statusCode != 200) {
				throw Exception('Unexpected error: ${currentRes.statusCode}');
			}

			return currentData;
			

		} catch (e) {
			debugPrint('Error: $e');
			throw Exception('Failed to fetch weather data');
		}
	}
	

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppBar(
				title: Text(
					style: TextStyle(
						fontWeight: FontWeight.bold,
					),
					'Whether App'
				),
				centerTitle: true,
				actions: [
					IconButton(
						icon: Icon(Icons.refresh),
						onPressed: () {
							setState(() {
							  
							});
						},
					)
				],
			),

			body: FutureBuilder(
				future: getCurrentWeather(),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return Align(
							alignment: Alignment.center,
							child: CircularProgressIndicator.adaptive(),
						);
					} else if (snapshot.hasError) {
						return Center(
							child: Text('Error: ${snapshot.error}'),
						);
					} else {
						final data = snapshot.data!;
						city = ('${data['location']['name']}');
						temp = data['forecast']['forecastday'][0]['hour'][currentHour]['temp_c'];
						weather = ('${data['current']['condition']['text']}');
						icon = ('${data['current']['condition']['icon']}');
						humidity = data['current']['humidity'].toInt();
						windSpeed = data['current']['wind_kph'].toDouble();
						pressure = data['current']['pressure_mb'].toInt();

						return Padding(
							padding: const EdgeInsets.all(8.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										style: TextStyle(
											fontSize: 32.0,
											fontWeight: FontWeight.bold,
										),
										city,
									),

									Text(
										style: TextStyle(
											fontSize: 16.0,
										),
										'Last updated: ${data['current']['last_updated']}',
									),
									
									SizedBox(
										width: double.infinity,
										child: Card(
											elevation: 10.0,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(16.0),
											),
											child: ClipRRect(
												borderRadius: BorderRadius.circular(16.0),
												child: BackdropFilter(
													filter: ImageFilter.blur(
														sigmaX: 10.0,
														sigmaY: 10.0,
													),
														child: Padding(
															padding: const EdgeInsets.all(16.0),
															child: Column(
																children: [
																	Text(
																		style: TextStyle(
																			fontSize: 32.0,
																			fontWeight: FontWeight.bold,
																		),
																		'$temp°C',
																	),

																	Image.network(
																		'http:$icon',
																		width: 120.0,
																		height: 120.0,
																	),

																	Text(
																		weather,
																		style: TextStyle(
																			fontSize: 20.0,
																		),
																	),
																],
															),
														),
													),
											),
										),
									),

									SizedBox(
										height: 20.0,
									),

									Text(
										style: TextStyle(
											fontSize: 24.0,
											fontWeight: FontWeight.bold,
										),
										'Whether Forecast',
									),
									

									SizedBox(
										height: 130,
										child: ListView.builder(
											scrollDirection: Axis.horizontal,
											itemCount: 5,	
											itemBuilder: (context, index) {
												if (currentHour + index > 23) {
													return ForecastCard(
														time: data['forecast']['forecastday'][1]['hour'][currentHour +	index + 1 - 24]['time'].substring(11, 16),
														icon: data['forecast']['forecastday'][1]['hour'][currentHour + 	index + 1 - 24]['condition']['icon'],
														temp: data['forecast']['forecastday'][1]['hour'][currentHour + 	index + 1 - 24]['temp_c'].toDouble(),
													);
												} else {

													return ForecastCard(
														time: data['forecast']['forecastday'][0]['hour'][currentHour + 	index + 1]['time'].substring(11, 16),
														icon: data['forecast']['forecastday'][0]['hour'][currentHour + 	index + 1]['condition']['icon'],
														temp: data['forecast']['forecastday'][0]['hour'][currentHour + 	index + 1]['temp_c'].toDouble(),
													);
												}
											},
										),
									),

									SizedBox(
										height: 20.0,
									),

									Text(
										style: TextStyle(
											fontSize: 24.0,
											fontWeight: FontWeight.bold,
										),
										'Additional Information',
									),

									SizedBox(
										width: double.infinity,
										child: Card(
											child: Padding(
												padding: const EdgeInsets.all(16.0),
												child: Row(
													mainAxisAlignment: MainAxisAlignment.spaceAround,
													children: [
														AdditionalInfoCard(
															icon: Icons.water_drop,
															title: 'Humidity',
															value: '$humidity%',
														),

														AdditionalInfoCard(
															icon: Icons.air,
															title: 'Wind Speed',
															value: '$windSpeed km/h',
														),

														AdditionalInfoCard(
															icon: Icons.speed,
															title: 'Pressure',
															value: '$pressure hPa',
														),					

													],
												),
											),
										),
									)

								],
							),
						);
					}
				},
			)

		);
  }
}

