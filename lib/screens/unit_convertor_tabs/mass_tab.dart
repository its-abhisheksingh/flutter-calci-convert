import 'package:calculator_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class MassTab extends StatefulWidget {
  const MassTab({super.key});

  @override
  State<MassTab> createState() => _MassTabState();
}

class _MassTabState extends State<MassTab> {

  final TextEditingController _inputController = TextEditingController();
  String _resultMessage = "Result will be shown here";

  bool _hasConverted = false;

  final List<String> _massUnits = [
    'Kilograms',
    'Grams',
    'Milligrams',
    'Pounds',
    'Ounces',
    'Tonnes'
  ];

  String? _fromUnit;
  String? _toUnit;

  @override
  void initState() {
    super.initState();
    _fromUnit = _massUnits[0];
    _toUnit = _massUnits[1];
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

    double valueInKg;

    // --- CONVERT TO BASE UNIT (KILOGRAMS) ---
    switch (_fromUnit) {
      case 'Grams':
        valueInKg = inputValue / 1000;
        break;
      case 'Milligrams':
        valueInKg = inputValue / 1000000;
        break;
      case 'Pounds':
        valueInKg = inputValue * 0.453592;
        break;
      case 'Ounces':
        valueInKg = inputValue * 0.0283495;
        break;
      case 'Tonnes':
        valueInKg = inputValue * 1000;
        break;
      case 'Kilograms':
      default:
        valueInKg = inputValue;
        break;
    }

    double finalResult;

    // --- CONVERT FROM KG TO TARGET ---
    switch (_toUnit) {
      case 'Grams':
        finalResult = valueInKg * 1000;
        break;
      case 'Milligrams':
        finalResult = valueInKg * 1000000;
        break;
      case 'Pounds':
        finalResult = valueInKg / 0.453592;
        break;
      case 'Ounces':
        finalResult = valueInKg / 0.0283495;
        break;
      case 'Tonnes':
        finalResult = valueInKg / 1000;
        break;
      case 'Kilograms':
      default:
        finalResult = valueInKg;
        break;
    }

    setState(() {
      _hasConverted = true;
      _resultMessage =
      '$inputValue $_fromUnit\nis equal to\n${finalResult.toStringAsFixed(3)} $_toUnit';
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

            // --- INPUT FIELD ---
            TextField(
              controller: _inputController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*')),
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

            // --- DROPDOWN ROW ---
            Row(
              children: [
                Expanded(
                  child: buildDropdown(_fromUnit, (newValue) {
                    setState(() => _fromUnit = newValue);
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward),
                ),
                Expanded(
                  child: buildDropdown(_toUnit, (newValue) {
                    setState(() => _toUnit = newValue);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // --- CONVERT BUTTON ---
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

            // --- RESULT BOX ---
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
          items: _massUnits.map((String unit) {
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