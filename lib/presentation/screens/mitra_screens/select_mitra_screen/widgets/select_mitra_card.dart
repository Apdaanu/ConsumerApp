import 'package:flutter/material.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../domain/entities/mitra/mitra.dart';
import '../../../../widgets/regular_text.dart';

class SelectMitraCard extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final Mitra mitra;
  final bool boxshadow;
  final onTap;

  const SelectMitraCard({
    Key key,
    this.bgColor,
    this.textColor,
    @required this.mitra,
    this.onTap,
    this.boxshadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap(mitra);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10 + measure.width * 0.01,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: mitra.active ? bgColor ?? Color(0xffefefef) : Colors.grey[50],
          borderRadius: BorderRadius.circular(2),
          boxShadow: mitra.active
              ? this.boxshadow == false
                  ? []
                  : <BoxShadow>[
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 0),
                        color: Color(0x29000000),
                      ),
                    ]
              : [],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: Image.network(mitra.profilePhoto ?? '').image,
              radius: 20,
              backgroundColor: Colors.grey[100],
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LimitedBox(
                  maxWidth: measure.width * 0.5,
                  child: Row(
                    children: <Widget>[
                      RegularText(
                        text: mitra.name,
                        color: mitra.active ? textColor ?? AppTheme.black2 : Colors.grey,
                        fontSize: AppTheme.smallTextSize,
                      ),
                      SizedBox(width: 10),
                      mitra.businessName != null && mitra.businessName != ''
                          ? RegularText(
                              text: "( ${mitra.businessName} )",
                              color: mitra.active ? textColor ?? AppTheme.black2 : Colors.grey,
                              fontSize: AppTheme.extraSmallTextSize,
                              fontWeight: FontWeight.w600,
                            )
                          : Container(),
                    ],
                  ),
                ),
                RegularText(
                  text: mitra.mob,
                  color: mitra.active ? textColor ?? AppTheme.black2 : Colors.grey,
                  fontSize: AppTheme.smallTextSize,
                ),
              ],
            ),
            Expanded(child: Container()),
            mitra.active
                ? Column(
                    children: <Widget>[
                      RegularText(
                        text: mitra.customers.toString(),
                        color: textColor ?? AppTheme.black2,
                        fontSize: AppTheme.smallTextSize,
                      ),
                      RegularText(
                        text: "Customers",
                        color: textColor ?? AppTheme.black2,
                        fontSize: AppTheme.extraSmallTextSize,
                      ),
                    ],
                  )
                : RegularText(
                    text: 'Inactive',
                    color: Colors.grey,
                    fontSize: AppTheme.smallTextSize,
                  ),
          ],
        ),
      ),
    );
  }
}
