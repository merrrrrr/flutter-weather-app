import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
	final IconData icon;
	final String title;
	final String value;
  const AdditionalInfoCard({
		required this.icon,
		required this.title,
		required this.value,
		super.key
	});

  @override
  Widget build(BuildContext context) {
    return Column(
    	mainAxisAlignment: MainAxisAlignment.center,
    	spacing: 8.0,
    	children: [
    		Icon(
    			icon,
    			size: 40.0,
    		),

    		Text(
    			style: TextStyle(
    				fontSize: 14.0,
    			),
    			title),

    		Text(
    			style: TextStyle(
    				fontSize: 14.0,
    				fontWeight: FontWeight.bold,
    			),
    			value
    		),
    	],
    );
  }
}