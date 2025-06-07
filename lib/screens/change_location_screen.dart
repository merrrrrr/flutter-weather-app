import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/location_provider.dart';

class ChangeLocationScreen extends ConsumerWidget {
  const ChangeLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
		final List<String> domesticCity = [
		// 'Alor Setar',
		// 'Batu Pahat',
		// 'Bukit Mertajam',
		// 'Butterworth',
		// 'Ipoh',
		// 'Johor Bahru',
		// 'Kangar',
		// 'Klang',
		// 'Kluang'
		// 'Kota Bharu',
		// 'Kota Kinabalu',
		// 'Kuala Lumpur',
		// 'Kuala Selangor',
		// 'Kuala Terengganu',
		// 'Kuantan',
		// 'Kuching',
		// 'Labuan',
		// 'Malacca',
		// 'Pahang',
		// 'Petaling Jaya',
		// 'Penang',
		// 'Putrajaya',
		// 'Seremban',
		// 'Sibu',
		// 'Sungai Petani',
		// 'Taiping',
	];

	final List<String> internationalCity = [
    'Abu Dhabi',
    'Bangkok',
    'Beijing',
    'Berlin',
    'Dubai',
    'Jakarta',
		'Kuala Lumpur',
    'London',
    'Los Angeles',
    'Moscow',
    'New York',
    'Paris',
    'Seoul',
    'Shanghai',
    'Singapore',
    'Tokyo',
	];

	final city = ref.read(locationProvider.notifier);

    return Scaffold(
			appBar: AppBar(
				title: const Text(
					'Change Location',
					style: TextStyle(
						fontWeight: FontWeight.bold,
					),
				),
			),

			body: ListView.builder(
				itemCount: (domesticCity.length + internationalCity.length),
				itemBuilder: (context, index) {
					return ListTile(
						title: Text(
							index < domesticCity.length
								? domesticCity[index]
								: internationalCity[index - domesticCity.length],
						),
						onTap: () {
							final selectedLocation = index < domesticCity.length
								? domesticCity[index]
								: internationalCity[index - domesticCity.length];
							city.updateCity(selectedLocation);
							Navigator.pop(context);
						},
					);
				},
			),
		);
  }
}