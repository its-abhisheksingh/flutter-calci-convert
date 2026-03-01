import 'package:calculator_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculator_app/screens/unit_convertor_tabs/length_tab.dart';
import 'package:calculator_app/screens/unit_convertor_tabs/mass_tab.dart';
import 'package:calculator_app/screens/unit_convertor_tabs/temperature_tab.dart';
import 'package:calculator_app/screens/unit_convertor_tabs/time_tab.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: GestureDetector( //  DISMISS KEYBOARD WHEN TAPPING ANYWHERE
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: white,

          resizeToAvoidBottomInset: true, // PREVENT OVERFLOW WHEN KEYBOARD IS OPEN

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75),
            child: AppBar(

              flexibleSpace: _measurementCategoryTabBar(),
            ),
          ),

          body: TabBarView(
            children: [
              LengthTab(),

              MassTab(),
              TemperatureTab(),
              TimeTab(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _measurementCategoryTabBar() {
  return SafeArea(
    child: Container(
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: sage,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 14),
        labelStyle: GoogleFonts.raleway(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.raleway(
          fontSize: 16,
        ),
        indicator: BoxDecoration(
          color: softSand,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: olive,
        unselectedLabelColor: charcoal,
        tabs: const [
          Tab(text: "Length"),
          Tab(text: "Mass"),
          Tab(text: "Temperature"),
          Tab(text: "Time"),
        ],
      ),
    ),
  );
}