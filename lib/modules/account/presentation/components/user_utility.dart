import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';

class UserUtility extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback? onPress;
  final Color color1;
  final Color color2;
  final Color color3;

  UserUtility({
    super.key,
    required this.icon,
    required this.title,
    this.onPress,
    this.color1 = Colors.white70,
    this.color2 = Colors.white24,
    this.color3 =  Colors.greenAccent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color1, color2, color3],
            stops: [0, 0.15, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black26,
              ),
              child: icon,
            ),
            12.horizontalSpace,
            Text(
              title,
              style: Styles.large.regular.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
