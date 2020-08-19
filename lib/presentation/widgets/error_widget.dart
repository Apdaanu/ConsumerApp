import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/theme/theme.dart';

class CustomErrorWidget extends StatefulWidget {
  final int errCode;

  const CustomErrorWidget({
    Key key,
    @required this.errCode,
  }) : super(key: key);

  @override
  _CustomErrorWidgetState createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  bool _showWidget = true;

  String _errorMessage(int code) {
    switch (code) {
      case SERVER_FAILURE_CODE:
        return "We are not able to connect to our servers at the moment";
        break;
      case AUTH_FAILURE_CODE:
        return "Oops! Please login again";
        break;
      case CONNECTION_FAILURE_CODE:
        return "Device is not connected to the internet";
        break;
      default:
        return "Something went wrong";
    }
  }

  void _hideWidget() {
    setState(() {
      _showWidget = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    if (_showWidget)
      return GestureDetector(
        onTap: _hideWidget,
        child: Container(
          height: measure.screenHeight,
          width: measure.width,
          alignment: Alignment.center,
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: Container(
            width: measure.width * 0.7,
            padding: EdgeInsets.symmetric(
              horizontal: measure.width * 0.04,
              vertical: measure.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              _errorMessage(widget.errCode),
              style: AppTheme.style,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    else
      return Container();
  }
}
