import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double width;
  final double height;
  final double fontSize;
  final bool isOutlined;
  final Color borderColor;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xff186AA7),
    this.textColor = Colors.white,
    this.borderRadius = 16,
    this.width = double.infinity,
    this.height = 50,
    this.fontSize = 16,
    this.isOutlined = false,
    this.borderColor = const Color(0xff186AA7),
    this.isLoading=false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(

            color: borderColor,
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child:
        isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white),
        )
            :


        Text(
          text,
          style: TextStyle(

            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}