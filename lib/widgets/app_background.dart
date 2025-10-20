import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cor de fundo neutra clara
        Container(color: const Color(0xFFF9F5F0)),

        // Bolhas e círculos decorativos
        Positioned(
          top: -50,
          left: -50,
          child: _buildCircle(120, const Color(0xFFE6D3C1)),
        ),
        Positioned(
          top: 100,
          right: -40,
          child: _buildCircle(80, const Color(0xFFF2B5A9)),
        ),
        Positioned(
          bottom: 150,
          left: -30,
          child: _buildCircle(100, const Color(0xFFB7D7E8)),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: _buildCircle(60, const Color(0xFFF7D6BF)),
        ),
        Positioned(
          top: 200,
          left: 50,
          child: _buildCircle(40, const Color(0xFFB7D7E8)),
        ),

        // Conteúdo da página
        child,
      ],
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}