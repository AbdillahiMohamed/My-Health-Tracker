import 'package:flutter/material.dart';
import 'package:health_app/History.dart';
import 'package:health_app/db_helper.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Health Schedule",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: sleepController,
              label: "Sleep Hours",
              icon: Icons.bedtime_outlined,
              hintText: "Enter your sleep hours",
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: stepsController,
              label: "Walking Steps",
              icon: Icons.directions_walk_outlined,
              hintText: "Enter walking steps",
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: waterController,
              label: "Water Intake (ml)",
              icon: Icons.water_drop_outlined,
              hintText: "Enter water intake in ml",
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: weightController,
              label: "Weight (kg)",
              icon: Icons.monitor_weight_outlined,
              hintText: "Enter your weight",
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: heightController,
              label: "Height (cm)",
              icon: Icons.height_outlined,
              hintText: "Enter your height",
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saveRecord,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveRecord() async {
    final sleep = _parseInt(sleepController.text);
    final steps = _parseInt(stepsController.text);
    final water = _parseInt(waterController.text);
    final weight = _parseInt(weightController.text);
    final height = _parseInt(heightController.text);

    if (sleep == 0 || steps == 0 || water == 0 || weight == 0 || height == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields must be filled with valid numbers!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await DBHelper().insertRecord({
        'sleepHours': sleep,
        'walkingSteps': steps,
        'waterDrank': water,
        'weight': weight,
        'height': height,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Record saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the HistoryScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save record: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
