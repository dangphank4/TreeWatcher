import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/modules/account/presentation/components/user_avatar.dart';

class UserTitle extends StatelessWidget {
  final String userName;
  final String userEmail;

  const UserTitle({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      padding: EdgeInsets.only(left: 16, top: 20),
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.blue,
        gradient: LinearGradient(
          colors: [Colors.white70, Colors.white12],
          stops: [0, 0.8],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Row(
              children: [
                UserAvatar(
                  imageUrl:
                      'https://static.vecteezy.com/system/resources/previews/000/439/863/original/vector-users-icon.jpg',
                ),
                18.horizontalSpace,
                Container(
                  alignment: Alignment.topLeft,
                  width: 240,
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Styles.h3.smb.copyWith(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        userEmail,
                        style: Styles.large.regular.copyWith(
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
