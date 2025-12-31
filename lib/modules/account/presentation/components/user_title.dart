import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_images.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/modules/account/presentation/components/user_avatar.dart';

class UserTitle extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userGender;

  const UserTitle({super.key, required this.userName, required this.userEmail, required this.userGender});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                8.horizontalSpace,
                UserAvatar(
                  isNetwork: false,
                  imageUrl: userGender == 'male' ? AppImages.maleImg : AppImages.femaleImg
                ),
                18.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          userName,
                          style: Styles.h3.smb.copyWith(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          userEmail,
                          style: Styles.large.regular.copyWith(
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
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
