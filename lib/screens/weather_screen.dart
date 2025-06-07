import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/widgets/forcast_card.dart';
import 'package:weather_app/widgets/additional_info_card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/providers/location_provider.dart';
import 'package:weather_app/providers/settings_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
	bool isLoading = true;
	String city = '';
	double temp = 0;
	String weather = '';
	String icon = '';
	String humidity = '';
	String windSpeed = '';
	String pressure = '';
	int currentHour = 0;
	List<String> infoList = [];

	@override
	void initState() {
		super.initState();
		getCurrentWeather();
	}

	Future<Map<String, dynamic>> getCurrentWeather() async {
		try {

			String cityName = ref.watch(locationProvider).city;
			String apiKey = dotenv.env['APIKEY'] ?? '';
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
		int forecastHours = ref.watch(settingsProvider).forecastHours;
		String unit = ref.watch(settingsProvider).unit;
		Map<String, bool> additionalInfo = ref.watch(settingsProvider).additionalInfo;

    return Scaffold(
			appBar: AppBar(
				title: Text(
					style: TextStyle(
						fontWeight: FontWeight.bold,
					),
					'Weather App'
				),
				centerTitle: true,
				actions: [
					PopupMenuButton(
						elevation: 12,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(12),
						),
						itemBuilder: (context) {
							return [
								PopupMenuItem(
									value: 'refresh',
									child: Text('Refresh'),
								),
								PopupMenuItem(
									value: 'change location',
									child: Text('Change Location'),
								),
								PopupMenuItem(
									value: 'settings',
									child: Text('Settings'),
								),
							];
						},
						onSelected: (value) {
						  if (value == 'change location') {
								Navigator.pushNamed(context, '/changeLocation');
							} else if (value == 'settings') {
								Navigator.pushNamed(context, '/settings');
							} else if (value == 'refresh') {
								setState(() {});
							}
							
						},
					),
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
						currentHour = int.parse(data['location']['localtime'].substring(11, 13));
						city = ('${data['location']['name']}');
						weather = ('${data['current']['condition']['text']}');
						icon = ('${data['current']['condition']['icon']}');
						temp = data['forecast']['forecastday'][0]['hour'][currentHour][unit == 'metric' ? 'temp_c' : 'temp_f'];

						infoList.clear();
						additionalInfo.forEach((key, value) {
							if (value) {
								infoList.add(key);
							}
						});



						return SingleChildScrollView(
							padding: const EdgeInsets.only(bottom: 48.0),
													child: Padding(
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
																									unit == 'metric' ? '$temp°C' : '$temp°F',
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
																		itemCount: forecastHours,	
																		itemBuilder: (context, index) {
																			if (currentHour + index + 1 > 23) {
																				return ForecastCard(
																					time: data['forecast']['forecastday'][1]['hour'][currentHour +	index + 1 - 24]['time'].substring(11, 16),
																					icon: data['forecast']['forecastday'][1]['hour'][currentHour + 	index + 1 - 24]['condition']['icon'],
																					temp: data['forecast']['forecastday'][1]['hour'][currentHour + 	index + 1 - 24][unit == 'metric' ? 'temp_c' : 'temp_f'],
																				);
																			} else {
													
																				return ForecastCard(
																					time: data['forecast']['forecastday'][0]['hour'][currentHour + 	index + 1]['time'].substring(11, 16),
																					icon: data['forecast']['forecastday'][0]['hour'][currentHour + 	index + 1]['condition']['icon'],
																					temp: data['forecast']['forecastday'][0]['hour'][currentHour + 	index + 1][unit == 'metric' ? 'temp_c' : 'temp_f'],
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
																			child: GridView.builder(
																				
																				physics: NeverScrollableScrollPhysics(),
																				shrinkWrap: true,
																				gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
																					crossAxisCount: 3,
																					crossAxisSpacing: 8.0,
																					mainAxisSpacing: 8.0,
																					childAspectRatio: 0.95,
																				),
																				itemCount: infoList.length,
																				itemBuilder: (context, index) {
																					switch (infoList[index]) {
																						case 'humidity':
																							return AdditionalInfoCard(
																								icon: Icons.water_drop,
																								title: 'Humidity',
																								value: '${data['current']['humidity']}%',
																							);
																						case 'pressure':
																							return AdditionalInfoCard(
																								icon: Icons.speed,
																								title: 'Pressure',
																								value: unit == 'metric' ? '${data['current']['pressure_mb']} hPa' : '${data['current']['pressure_in']} in',
																							);
																						case 'windSpeed':
																							return AdditionalInfoCard(
																								icon: Icons.air,
																								title: 'Wind Speed',
																								value: unit == 'metric' ? '${data['current']['wind_kph']} km/h' : '${data['current']['wind_mph']} mp/h',
																							);
																						case 'windDirection':
																							return AdditionalInfoCard(
																								icon: Icons.navigation,
																								title: 'Wind Direction',
																								value: '${data['current']['wind_dir']}',
																							);
																						case 'visibility':
																							return AdditionalInfoCard(
																								icon: Icons.visibility,
																								title: 'Visibility',
																								value: unit == 'metric' ? '${data['current']['vis_km']} km' : '${data['current']['vis_miles']} miles',
																							);
																						case 'uvIndex':
																							return AdditionalInfoCard(
																								icon: Icons.wb_sunny,
																								title: 'UV Index',
																								value: '${data['current']['uv']}',
																							);

																					}
																				},

																			),
																		),
																	),
																),
																
																
													
															],
														),
													),
												);
					}
				},
			)

		);
  }
}

