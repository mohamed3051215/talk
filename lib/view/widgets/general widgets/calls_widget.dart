import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fake_data.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/enums/call_state.dart';
import '../../../core/models/call.dart';
import '../general%20widgets/custom_text.dart';

class CallWidget extends StatelessWidget {
  const CallWidget({Key? key, required this.call}) : super(key: key);
  final Call call;

  getStringDate() {
    final DateTime date = call.date;
    final int day = date.day;
    final int month = date.month;
    final int year = date.year;
    final int hour = date.hour;
    final int minute = date.minute;
    final int second = date.second;
    final String result = "$day-$month-$year $hour:$minute:$second";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
          width: Get.width,
          height: 78,
          child: Row(
            children: [
              Container(
                width: 65,
                height: 65,
                child: Stack(children: [
                  CircleAvatar(
                    minRadius: 30,
                    maxRadius: 30,
                    backgroundImage: NetworkImage(call.from.id == mohamed.id
                        ? call.to.image
                        : call.from.image),
                  ),
                  call.from.active
                      ? Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                                border: Border.all(color: lightBlue, width: 3),
                                shape: BoxShape.circle,
                                color: Color(0xff00FF19)),
                          ),
                        )
                      : SizedBox()
                ]),
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width - 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
                          child: CustomText(
                            call.from.id == mohamed.id
                                ? call.to.username
                                : call.from.username,
                            fontFamily: rMedium,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width - 130,
                    child: Row(
                      children: [
                        Container(
                            width: Get.width - 160,
                            child: CustomText(
                              getStringDate(),
                              fontSize: 12,
                              fontFamily: "",
                            )),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              ),
              call.from.id == mohamed.id
                  ? Transform.rotate(
                      angle: pi,
                      child: SvgPicture.asset(
                        "assets/icons/call.svg",
                        color: call.callState == CallState.answered
                            ? Colors.green
                            : Colors.red,
                        width: 20,
                        height: 20,
                      ),
                    )
                  : SvgPicture.asset(
                      "assets/icons/call.svg",
                      color: call.callState == CallState.answered
                          ? Colors.green
                          : Colors.red,
                      width: 20,
                      height: 20,
                    )
            ],
          )),
    );
  }
}
