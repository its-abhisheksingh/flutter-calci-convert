import 'package:calculator_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class LengthTab extends StatefulWidget {
  const LengthTab({super.key});

  @override
  State<LengthTab> createState() => _LengthTabState();
}

class _LengthTabState extends State<LengthTab> {
  // --- STATE VARIABLES ---
  final TextEditingController _inputController = TextEditingController();
  String _resultMessage = "Result will be shown here";


  bool _hasConverted = false;

  final List<String> _lengthUnits = [
    'Meters',
    'Centimeters',
    'Kilometers',
    'Miles',
    'Feet',
    'Inches'
  ];

  String? _fromUnit;
  String? _toUnit;

  @override
  void initState() {
    super.initState();
    _fromUnit = _lengthUnits[0];
    _toUnit = _lengthUnits[1];
  }

  // --- CONVERSION LOGIC ---
  void _performConversion() {

    //  DISMISS KEYBOARD WHEN BUTTON PRESSED
    FocusScope.of(context).unfocus();

    double? inputValue = double.tryParse(_inputController.text);

    if (inputValue == null) {
      setState(() {
        _hasConverted = false; // RESET STATE IF INVALID
        _resultMessage = "Please enter a valid number";
      });
      return;
    }

    double valueInMeters;

    switch (_fromUnit) {
      case 'Centimeters':
        valueInMeters = inputValue / 100;
        break;
      case 'Kilometers':
        valueInMeters = inputValue * 1000;
        break;
      case 'Miles':
        valueInMeters = inputValue * 1609.34;
        break;
      case 'Feet':
        valueInMeters = inputValue * 0.3048;
        break;
      case 'Inches':
        valueInMeters = inputValue * 0.0254;
        break;
      case 'Meters':
      default:
        valueInMeters = inputValue;
        break;
    }

    double finalResult;

    switch (_toUnit) {
      case 'Centimeters':
        finalResult = valueInMeters * 100;
        break;
      case 'Kilometers':
        finalResult = valueInMeters / 1000;
        break;
      case 'Miles':
        finalResult = valueInMeters / 1609.34;
        break;
      case 'Feet':
        finalResult = valueInMeters / 0.3048;
        break;
      case 'Inches':
        finalResult = valueInMeters / 0.0254;
        break;
      case 'Meters':
      default:
        finalResult = valueInMeters;
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

    //  TAP OUTSIDE TO CLOSE KEYBOARD
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView( //  PREVENTS OVERFLOW WHEN KEYBOARD OPENS
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
              onChanged: (value) {
                // RESET BUTTON COLOR WHEN USER TYPES AGAIN
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

                foregroundColor: _hasConverted ? white : white  ,
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

  // --- DROPDOWN BUILDER ---
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
          items: _lengthUnits.map((String unit) {
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