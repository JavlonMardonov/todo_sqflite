import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final Function onTapFunc;
  final Color containerColor;

  const CustomContainer({
    required this.icon,
    required this.onTapFunc,
    required this.containerColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapFunc(),
      child: Container(
        alignment: Alignment.center,
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: containerColor,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
