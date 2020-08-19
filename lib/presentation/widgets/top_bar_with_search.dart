import 'package:flutter/material.dart';

import '../../core/constants/measure.dart';
import '../../core/theme/theme.dart';

class CustomTopBarWithSearch extends StatefulWidget {
  final String title;
  final onSearch;
  const CustomTopBarWithSearch({
    Key key,
    @required this.title,
    @required this.onSearch,
  }) : super(key: key);

  @override
  _CustomTopBarWithSearchState createState() => _CustomTopBarWithSearchState();
}

class _CustomTopBarWithSearchState extends State<CustomTopBarWithSearch> {
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      height: measure.topBarHeight,
      width: measure.width,
      padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0, 0),
            color: Color(0x29000000),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(40),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(40),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.keyboard_backspace,
                  color: AppTheme.black5,
                  size: 22 * measure.fontRatio,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            width: measure.width * 0.7,
            child: TextField(
              focusNode: _focusNode,
              onChanged: (value) {
                widget.onSearch(value);
              },
              cursorColor: Colors.grey,
              cursorWidth: 1,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  bottom: 0,
                  left: 0,
                  right: 0,
                ),
                hintText: widget.title,
                hintStyle: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: AppTheme.regularTextSize * measure.fontRatio,
                  color: AppTheme.black5,
                ),
              ),
              style: TextStyle(
                fontFamily: "Open Sans",
                fontSize: AppTheme.regularTextSize * measure.fontRatio,
              ),
            ),
          ),
          Expanded(child: Container()),
          Material(
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              onTap: () {
                _focusNode.requestFocus();
              },
              borderRadius: BorderRadius.circular(40),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.search,
                  color: AppTheme.black5,
                  size: 22 * measure.fontRatio,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
