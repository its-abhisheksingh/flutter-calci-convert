import 'package:calculator_app/colors.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  //variables
  //functions
  String display = "0"; // what the user sees
  String equation = "0"; // secondary display for calculation history
  double firstNum = 0; // first number entered
  String operator = ""; // +, -, ×, ÷

  // A helper function to format numbers nicely (e.g., 16.0 becomes "16")
  String formatResult(double number) {
    if (number % 1 == 0) {
      return number.toInt().toString();
    }
    return number.toString();
  }

  // Function that handles button press
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // clear everything
        display = "0";
        equation = "0";
        firstNum = 0;
        operator = "";
      }
      else if (buttonText == "+" || buttonText == "-" || buttonText == "×" ||
          buttonText == "÷") {
        // save the first number and operator
        firstNum = double.parse(display);
        operator = buttonText;
        //Build the equation string and reset the main display
        equation = "${formatResult(firstNum)} $operator";
        display = "0";
      }
      else if (buttonText == "=") {
        // calculate result using switch
        double secondNum = double.parse(display);
        double result = 0;

        // Update the equation to show the full calculation
        equation =
        "${formatResult(firstNum)} $operator ${formatResult(secondNum)} =";

        switch (operator) {
          case "+":
            result = firstNum + secondNum;
            break;
          case "-":
            result = firstNum - secondNum;
            break;
          case "×":
            result = firstNum * secondNum;
            break;
          case "÷":
            if (secondNum != 0) {
              result = firstNum / secondNum;
            } else {
              display = "Error"; // division by zero
              equation = "Cannot divide by zero";
              return;
            }
            break;
          default:
            result = secondNum;
        }

        display = result.toString();
        // Reset for the next calculation
        firstNum = 0;
        secondNum = 0;
        operator = "";
      } else {
        // number is pressed

        // THE FIX: Add this check at the very top of the block.
        if (buttonText == "." && display.contains(".")) {
          // If the user presses "." but there's already one, do nothing.
          return; // This exits the function immediately.
        }

        // Handle number input for both displays
        if (display == "0") {
          display = buttonText; //This checks if you're starting a new number.
          // If the display is "0" and you press 7, it replaces "0" with "7".

          if (operator ==
              "") // helps identifying that this is firstNum and not secondNum
              {
            equation = buttonText; // If starting fresh, equation should match
          }
        } else {
          display = display +
              buttonText; // If the display is not "0" (e.g., it's "7")
          // And you press 8 , it simply adds the new digit to the end, making the display "78"
        }
        // Build the equation string as the user types the second number
        if (operator != "" && !equation.contains("=")) {
          equation = "${formatResult(firstNum)} $operator $display";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          // DISPLAY SECTION
          Expanded(
            flex: 2, // ADDED FLEX CONTROL
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    equation,
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    display,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BUTTON GRID
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5), // SPACE AT BOTTOM
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...[
                    "7", "8", "9", "÷",
                    "4", "5", "6", "×",
                    "1", "2", "3", "-",
                    ".", "0", "C", "+",
                    "="
                  ].map((btn) => GestureDetector(
                    onTap: () => buttonPressed(btn),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: btn == "=" ? wood : olive,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          btn,
                          style: TextStyle(
                            fontSize: 30,
                            color: btn == "=" ? white : beige,
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}