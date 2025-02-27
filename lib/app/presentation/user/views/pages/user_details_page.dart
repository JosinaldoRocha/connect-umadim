import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.lightBgColor,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildImage(),
          SpaceVertical.x2(),
          Center(
            child: Text(
              user.name,
              style: AppText.text()
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SpaceVertical.x2(),
          Container(
            padding: EdgeInsets.all(12).copyWith(top: 0),
            decoration: BoxDecoration(
              color: AppColor.lightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildItem(
                  'Email:',
                  user.email,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildItem(
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    AppText.text().bodyMedium!.copyWith(color: AppColor.black),
              ),
              Text(
                description,
                style: AppText.text().bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center _buildImage() {
    return Center(
      child: ClipOval(
        child: user.photoUrl != null && user.photoUrl!.isNotEmpty
            ? Image.network(
                user.photoUrl!,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              )
            : Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
      ),
    );
  }
}
