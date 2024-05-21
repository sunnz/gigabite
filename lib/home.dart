import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DateTime today = DateTime.now();
  final GlobalKey<FormFieldState<DateTime>> selectedEndDateKey = GlobalKey();
  final TextEditingController dataUsedTextController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int? used;
  int result = 0;
  bool enableCalculateButton = false;

  void selectStartDate(DateTime? value) {
    setState(() {
      selectedStartDate = value;
      if (value != null && selectedEndDate == null) {
        selectedEndDate = DateTime(value.year + 1, value.month, value.day);
        selectedEndDateKey.currentState?.didChange(selectedEndDate);
      }
      setEnableCalculateButton();
    });
  }

  void selectEndDate(DateTime? value) {
    setState(() {
      selectedEndDate = value;
      setEnableCalculateButton();
    });
  }

  void handleDataChange(String value) {
    setState(() {
      used = double.tryParse(dataUsedTextController.text.trim())?.ceil();
      setEnableCalculateButton();
    });
  }

  void setEnableCalculateButton() {
    enableCalculateButton =
        selectedStartDate != null && selectedEndDate != null && used != null;
  }

  void handleDataDecrement() {
    setState(() {
      used = (used != null && used! > 1) ? used! - 1 : 1;
      dataUsedTextController.text = "$used";
    });
  }

  void handleDataIncrement() {
    setState(() {
      used = (used != null && used! >= 1) ? used! + 1 : 1;
      dataUsedTextController.text = "$used";
    });
  }

  void handleCalculate() {
    setState(() {
      // print("selectedStartDate: $selectedStartDate");
      // print("selectedEndDate: $selectedEndDate");
      // print("GB: ${dataUsedTextController.text.trim()}");
      DateTime now = DateTime.now();
      int daysPassed = now.difference(selectedStartDate!).inDays;
      double dataPerDay = used! / daysPassed;
      int daysTotal = selectedEndDate!.difference(selectedStartDate!).inDays;
      result = (dataPerDay * daysTotal).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Usage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DateTimeFormField(
                mode: DateTimeFieldPickerMode.date,
                initialPickerDateTime:
                    DateTime(today.year, today.month - 6, today.day),
                decoration: const InputDecoration(
                  labelText: "Start date",
                ),
                dateFormat: DateFormat("dd/MM/yyyy"),
                onChanged: selectStartDate),
            DateTimeFormField(
                key: selectedEndDateKey,
                mode: DateTimeFieldPickerMode.date,
                initialPickerDateTime:
                    DateTime(today.year, today.month + 6, today.day),
                decoration: const InputDecoration(
                  labelText: "End date",
                ),
                dateFormat: DateFormat("dd/MM/yyyy"),
                onChanged: selectEndDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: handleDataDecrement,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: dataUsedTextController,
                    onChanged: handleDataChange,
                    decoration: const InputDecoration(
                      labelText: 'GB used',
                      hintText: 'enter GB used',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: handleDataIncrement,
                ),
              ],
            ),
            ElevatedButton(
                onPressed: enableCalculateButton ? handleCalculate : null,
                child: const Text("Calculate")),
            const Text("GB used on end date:"),
            Text("$result GB"),
          ],
        ),
      ),
    );
  }
}
