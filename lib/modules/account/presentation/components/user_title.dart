import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_images.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/modules/account/presentation/components/user_avatar.dart';

class UserTitle extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userGender;

  const UserTitle({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userGender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.blue,
        gradient: LinearGradient(
          colors: [Colors.white70, Colors.green.shade900],
          stops: [0.2, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          20.verticalSpace,
          UserAvatar(
            isNetwork: false,
            imageUrl: userGender == context.localization.male
                ? AppImages.maleImg
                : AppImages.femaleImg,
            borderColor: Colors.green,
            size: 120,
          ),
          30.verticalSpace,

          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Text(
              userName,
              style: Styles.h3.smb.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Text(
              userEmail,
              style: Styles.large.regular.copyWith(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
