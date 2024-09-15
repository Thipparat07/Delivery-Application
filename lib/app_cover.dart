import 'package:flutter/material.dart';

class AppCover extends StatelessWidget {
  const AppCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0C1C8D),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // จัด Column ให้อยู่ตรงกลางแนวตั้ง
            children: [
              Image.asset(
                'asset/images/logo.png', 
                width: 223, 
                height: 230,
              ),
              Transform.translate(
                offset: const Offset(0, -40), 
                child: const Text(
                  'Delivery Application',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFE400),
                    fontFamily: 'Aleo'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
