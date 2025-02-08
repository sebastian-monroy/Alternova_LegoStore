import 'package:flutter/material.dart';



class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          
          _ColorBox(),

          //icono del login
          _HeaderIcon(),


          this.child

        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: Icon(Icons.person_pin_rounded, color: Colors.white, size: 100,),
      ),
    );
  }
}



class _ColorBox extends StatelessWidget {
  const _ColorBox({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      color: isDarkMode ? Colors.blueGrey[900] : Colors.indigo,
    );
  }
}