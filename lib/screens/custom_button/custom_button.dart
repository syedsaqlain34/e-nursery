import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:plant_project/core/text.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.isShowForwardIcon = false,
      this.isTimeCounterShow = false,
      this.prefixIcon,
      this.buttonColor,
      this.textColor,
      this.timer,
      this.isShowBorder = true,
      this.prefixIconColor,
      this.child,
      this.isLoading = false});

  final String title;
  final Function()? onTap;
  final bool isShowForwardIcon;
  final bool isTimeCounterShow;
  final String? prefixIcon;
  final Color? buttonColor;
  final Color? textColor;
  final String? timer;
  final bool isShowBorder;
  final Color? prefixIconColor;
  final Widget? child;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor ?? kBluePrimary,
          border: isShowBorder
              ? Border.all(
                  color: buttonColor ?? kBluePrimary,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (child != null)
              child!
            else
              Row(
                children: [
                  if (prefixIcon != null)
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      // child: SvgPicture.asset(
                      //   prefixIcon!,
                      //   color: prefixIconColor,
                      // ),
                    ),
                  isLoading!
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          title,
                          style: kInterSemibold.copyWith(
                            color: textColor ?? kWhite,
                            fontSize: 16.sp,
                          ),
                        ),
                  if (isTimeCounterShow)
                    Text(
                      timer == "30" ? "" : "0:$timer",
                      style: kInterRegular.copyWith(
                        color: kBlack,
                        fontSize: 16.sp,
                      ),
                    ),
                ],
              ),
            if (!isLoading!)
              if (isShowForwardIcon) ...[
                SizedBox(width: 10.w),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: kWhite,
                  size: 20,
                ),
              ],
          ],
        ),
      ),
    );
  }
}
