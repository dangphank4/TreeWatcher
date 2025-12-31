import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;        // URL hoặc path local
  final bool isNetwork;         // true nếu là network, false nếu asset
  final double size;            // kích thước avatar
  final Color borderColor;      // màu border
  final double borderWidth;     // độ dày border
  final Color backgroundColor;  // màu nền nếu ảnh không load

  const UserAvatar({
    Key? key,
    required this.imageUrl,
    this.isNetwork = true,
    this.size = 80,
    this.borderColor = Colors.white,
    this.borderWidth = 2,
    this.backgroundColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: isNetwork
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.person, size: size * 0.6),
        )
            : Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
