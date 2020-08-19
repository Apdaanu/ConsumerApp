import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  final onSubmitted;
  final String hintText;
  final bool err;
  final String errMsg;
  final Icon icon;
  final String title;
  final FocusNode focus;
  final TextInputType keyboard;
  final String helperText;

  const InputWidget({
    Key key,
    @required this.title,
    @required this.controller,
    this.focus,
    @required this.onSubmitted,
    this.keyboard,
    this.err,
    this.errMsg,
    this.hintText,
    this.icon,
    this.helperText,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    var borderColor = widget.err != null && widget.err
        ? AppTheme.redCancel
        : AppTheme.primaryColor;
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (term) {
                  widget.onSubmitted(term);
                },
                style:
                    AppTheme.style.copyWith(fontSize: 12 * measure.fontRatio),
                controller: widget.controller,
                focusNode: widget.focus,
                keyboardType: widget.keyboard,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 2,
                      color: borderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 2,
                      color: borderColor,
                    ),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: widget.hintText,
                  helperText: widget.helperText,
                  helperStyle: AppTheme.style.copyWith(color: Colors.grey[500]),
                  hintStyle: AppTheme.style.copyWith(
                    color: Colors.grey[400],
                  ),
                  prefixIcon: widget.icon,
                ),
              ),
            ),
            if (widget.err != null && widget.err)
              Column(
                children: <Widget>[
                  Text(
                    widget.errMsg,
                    style: AppTheme.style.copyWith(
                      color: AppTheme.redCancel,
                      fontSize: 10 * measure.fontRatio,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: measure.bodyHeight * 0.02),
                ],
              )
            else
              Text(""),
            SizedBox(height: measure.bodyHeight * 0.01),
          ],
        ),
        Positioned(
          top: -2,
          left: 10,
          child: Container(
            color: Color(0xfffafafa),
            child: Text(
              "  ${widget.title}  ",
              style: AppTheme.style.copyWith(
                fontSize: 10 * measure.fontRatio,
                fontWeight: FontWeight.w700,
                color: borderColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
