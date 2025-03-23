import 'package:flutter/material.dart';

class FeaturesPage extends StatelessWidget {
  final List<Map<String, String>> features = [
    {
      'emoji': '🌪️',
      'title': 'Real-time Cyclone Forecast',
      'description':
          'Get accurate and real-time cyclone forecasts tailored for your region.',
    },
    {
      'emoji': '📊',
      'title': 'Risk Analysis Charts',
      'description':
          'Visualize cyclone risks with interactive charts and percentages.',
    },
    {
      'emoji': '🌎',
      'title': 'Regional Insights',
      'description':
          'Detailed cyclone analysis for Arabian Sea, Bay of Bengal, and more.',
    },
    {
      'emoji': '🔔',
      'title': 'Instant Alerts',
      'description':
          'Receive instant alerts and notifications about upcoming cyclone threats.',
    },
    {
      'emoji': '📅',
      'title': 'Seasonal Forecasting',
      'description':
          'Breakdown of cyclone risks by seasons for better preparedness.',
    },
    {
      'emoji': '📍',
      'title': 'Location-Based Data',
      'description':
          'Cyclone predictions and analysis customized to your city.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(title: Text('App Features'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(feature['emoji']!, style: TextStyle(fontSize: 32)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade900,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            feature['description']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
