import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/routes.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

class RecepieTopBar extends StatefulWidget {
  @override
  RecepieTopBarState createState() => RecepieTopBarState();
}

class RecepieTopBarState extends State<RecepieTopBar> {
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      height: measure.topBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 0),
            color: Color(0x29000000),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: AppTheme.black7,
              size: 20 * measure.fontRatio,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Expanded(
            child: Material(
              color: Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(2),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    homeSearchRoute,
                    arguments: 'recepie',
                  );
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RegularText(
                            text: 'Search recepies...',
                            color: AppTheme.black7,
                            fontSize: AppTheme.regularTextSize,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 18 * measure.fontRatio,
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(2),
                          topRight: Radius.circular(2),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container()
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).pushNamed(createRecepieRoute);
          //   },
          //   child: Container(
          //     padding: EdgeInsets.all(7),
          //     margin: EdgeInsets.only(right: 10),
          //     decoration: BoxDecoration(
          //       gradient: AppTheme.gradient,
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     child: Icon(
          //       Icons.add,
          //       color: Colors.white,
          //       size: 18 * measure.fontRatio,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
