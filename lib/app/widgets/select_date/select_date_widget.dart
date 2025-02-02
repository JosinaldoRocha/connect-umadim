import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/style/app_colors.dart';
import '../../core/style/app_text.dart';

class SelectDateWidget extends StatefulWidget {
  const SelectDateWidget({
    super.key,
    required this.date,
    required this.onTap,
    required this.hintText,
    required this.onClean,
    // required this.label,
  });

  final DateTime? date;
  final Function() onTap;
  final String hintText;
  final Function() onClean;
  // final String label;

  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (widget.date != null)
        //   Padding(
        //     padding: const EdgeInsets.only(left: 12),
        //     child: Text(
        //       widget.label,
        //       style: AppText.text()
        //           .bodySmall!
        //           .copyWith(color: AppColor.primary, fontSize: 12),
        //     ),
        //   ),
        InkWell(
          onTap: widget.onTap,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColor.lightGrey,
              borderRadius: BorderRadius.circular(50),
              border: widget.date == null
                  ? Border.all(color: AppColor.error)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.date == null
                        ? widget.hintText
                        : DateFormat('dd/MM/yyyy').format(widget.date!),
                    style: AppText.text().bodyMedium!.copyWith(
                          color: AppColor.primaryGrey,
                        ),
                  ),
                  widget.date != null
                      ? InkWell(
                          onTap: widget.onClean,
                          child: const Icon(Icons.close_rounded),
                        )
                      : Icon(
                          Icons.calendar_month_rounded,
                          color: AppColor.primaryGrey,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
