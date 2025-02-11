import 'dart:ui';

import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/happy_birthday_widget.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';
import '../../../../data/models/user_model.dart';
import '../../../../widgets/image/profile_image_widget.dart';

class HomeAppBarWidget extends ConsumerStatefulWidget {
  const HomeAppBarWidget({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends ConsumerState<HomeAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final isBirthday = (widget.user.birthDate?.day == now.day &&
        widget.user.birthDate!.month == now.month);

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: kIsWeb ? 12 : 48,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: AppColor.lightBgColor,
        image: isBirthday
            ? DecorationImage(
                opacity: 0.3,
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/confetti.png'),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SpaceHorizontal.x1(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isBirthday ? 'Happy Birthday 🎉' : 'A paz do Senhor ✋',
                style: AppText.text().titleSmall,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _getUserFunction(),
                    style: AppText.text().titleSmall!.copyWith(fontSize: 14),
                  ),
                  Text(
                    getFirstAndSecondName(widget.user.name),
                    style: AppText.text().titleMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          if (isBirthday)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (context) => Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        content: HappyBirthdayWidget(),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    Lottie.asset(
                      'assets/animations/received_message.json',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 5,
                      child: Text('🎂'),
                    ),
                  ],
                ),
              ),
            ),
          ProfileImageWidget(
            image: widget.user.photoUrl,
            size: 52,
          ),
        ],
      ),
    );
  }

  String _getUserFunction() {
    if (widget.user.umadimFunction.title == FunctionType.leader ||
        widget.user.umadimFunction.title == FunctionType.regent) {
      return '${widget.user.umadimFunction.title.text} ';
    }

    return (widget.user.localFunction.title == FunctionType.leader ||
            widget.user.localFunction.title == FunctionType.regent)
        ? '${widget.user.localFunction.title.text} '
        : '';
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  String getFirstAndSecondName(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0]} ${names[1]}';
    }
    return names[0];
  }
}
