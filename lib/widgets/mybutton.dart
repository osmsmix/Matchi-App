import 'package:flutter/material.dart';



class mybutton extends StatelessWidget {
  const mybutton({super.key, required this.color,required this.title,required this.onPressed});


  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 100,
          height: 42,
          child: Text(title,
          style: const TextStyle(color: Colors.white),),
          ),
      ),
    );
  }
}