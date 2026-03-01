import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'unit_converter_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculator_app/colors.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60), // reduce/increase height
            child: AppBar(
              flexibleSpace: _buildCustomTabBar(),
            ),
          ),

          body: TabBarView(children: [
            CalculatorScreen(),
            UnitConverterScreen()
          ] ),
        ));
  }
}


Widget _buildCustomTabBar() {
  return SafeArea(
    child: Container(
      margin: const EdgeInsets.all(9), // spacing from screen edges
      decoration: BoxDecoration(
        color: olive, // background capsule color
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        labelStyle:  GoogleFonts.raleway(
          fontSize: 18, // bigger text
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.raleway(
          fontSize: 16,
        ),
        indicator: BoxDecoration(
          color: wood,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: white,
        unselectedLabelColor: beige,
        tabs: const [
          Tab(text: "Calculator"),
          Tab(text: "Unit Converter"),
        ],
      ),
    ),
  );
}