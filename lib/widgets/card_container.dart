import 'package:alternova_prueba/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: _createCardShape(isDarkMode),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape(bool isDarkMode) => BoxDecoration(
    color: isDarkMode ? Colors.blueGrey[800]  : Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5)
      )
    ]
  );

}