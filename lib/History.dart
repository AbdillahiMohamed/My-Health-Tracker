import 'package:flutter/material.dart';
import 'package:health_app/home.dart';
import 'db_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _healthDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
  }

  // Fetch all health data from the database
  Future<void> _fetchHealthData() async {
    _healthDataFuture = DBHelper().queryAllHealthData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _healthDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final healthData = snapshot.data!;

                return ListView.builder(
                  itemCount: healthData.length,
                  itemBuilder: (context, index) {
                    final data = healthData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        title: Text('Weight: ${data['weight']} kg'),
                        subtitle: Text(
                          'Sleep: ${data['sleepHours']} hrs\n'
                          'Steps: ${data['walkingSteps']}\n'
                          'Water: ${data['waterDrank']} glasses\n'
                          'Height: ${data['height']} cm',
                        ),
                        trailing: Text('Date: ${data['date']}'),
                        onTap: () {
                          // Optional: Add action on item tap
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Back to Home Page'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
