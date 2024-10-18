// lib/widgets/logo_widget.dart
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;

  const LogoWidget({Key? key, this.size = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/textile_erp_black.png', // Make sure to add your logo image in the assets folder
      width: size,
      height: size,
      fit: BoxFit.contain, // Ensure the image scales appropriately
    );
  }
}
