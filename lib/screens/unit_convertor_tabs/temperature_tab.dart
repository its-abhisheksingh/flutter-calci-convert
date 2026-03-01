import 'package:calculator_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class TemperatureTab extends StatefulWidget {
  const TemperatureTab({super.key});

  @override
  State<TemperatureTab> createState() => _TemperatureTabState();
}

class _TemperatureTabState extends State<TemperatureTab> {

  final TextEditingController _inputController = TextEditingController();
  String _resultMessage = "Result will be shown here";
  bool _hasConverted = false;

  final List<String> _tempUnits = [
    'Celsius',
    'Fahrenheit',
    'Kelvin'
  ];

  String? _fromUnit;
  String? _toUnit;

  @override
  void initState() {
    super.initState();
    _fromUnit = _tempUnits[0];
    _toUnit = _tempUnits[1];
  }

  void _performConversion() {

    FocusScope.of(context).unfocus();

    double? inputValue = double.tryParse(_inputController.text);

    if (inputValue == null) {
      setState(() {
        _hasConverted = false;
        _resultMessage = "Please enter a valid number";
      });
      return;
    }

    double result = inputValue;

    // --- FORMULA BASED CONVERSION ---
    if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
      result = (inputValue * 9 / 5) + 32;
    } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
      result = inputValue + 273.15;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
      result = (inputValue - 32) * 5 / 9;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
      result = (inputValue - 32) * 5 / 9 + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
      result = inputValue - 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
      result = (inputValue - 273.15) * 9 / 5 + 32;
    }

    setState(() {
      _hasConverted = true;
      _resultMessage =
      '$inputValue $_fromUnit\nis equal to\n${result.toStringAsFixed(2)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            TextField(
              controller: _inputController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (_) {
                setState(() {
                  _hasConverted = false;
                });
              },
              decoration: InputDecoration(
                labelText: "Enter Value",
                labelStyle: GoogleFonts.outfit(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: buildDropdown(_fromUnit, (value) {
                    setState(() => _fromUnit = value);
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward),
                ),
                Expanded(
                  child: buildDropdown(_toUnit, (value) {
                    setState(() => _toUnit = value);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 35),

            ElevatedButton(
              onPressed: _performConversion,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasConverted ? wood : olive,
                foregroundColor: white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
              ),
              child: const Text(
                "Convert",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 35),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: softSand,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _resultMessage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(String? value, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: softSand,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: _tempUnits.map((unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(
                unit,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}