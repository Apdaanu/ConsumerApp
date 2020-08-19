part of '../otp_screen.dart';

class OtpInputWidget extends StatefulWidget {
  OtpInputWidget({Key key}) : super(key: key);

  @override
  _OtpInputWidgetState createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  OtpScreenBloc _otpScreenBloc;
  String _otp;
  int _numMinutes;
  int _numSeconds;
  Timer _timer;
  int _startTime = new DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _otpScreenBloc = BlocProvider.of<OtpScreenBloc>(context);
    _timer = _setTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Timer _setTimer() {
    return Timer.periodic(new Duration(milliseconds: 10), (Timer timer) {
      int timeDifference =
          60000 - (new DateTime.now().millisecondsSinceEpoch - _startTime);
      double seconds = timeDifference / 1000;
      double minutes = seconds / 60;
      double leftoverSeconds = seconds % 60;
      setState(() {
        _numSeconds = leftoverSeconds.floor();
        _numMinutes = minutes.floor();
      });
    });
  }

  void _resendOtp() {
    _otpScreenBloc.add(ResendOtpEvent());
    setState(() {
      _startTime = new DateTime.now().millisecondsSinceEpoch;
    });
    _timer = _setTimer();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    return BlocBuilder(
      cubit: _otpScreenBloc,
      builder: (context, state) {
        return Container(
          height: measure.screenHeight * 0.75,
          padding: EdgeInsets.only(bottom: measure.screenHeight * 0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: measure.width * 0.7,
                child: PinCodeTextField(
                  autoFocus: true,
                  textInputType: TextInputType.number,
                  length: 5,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  animationDuration: Duration(milliseconds: 150),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(4),
                    fieldWidth: measure.width * 0.1,
                    fieldHeight: measure.width * 0.1,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: Colors.grey,
                    selectedColor: AppTheme.primaryColor,
                    activeFillColor: Color(0xffc7c7c7),
                    selectedFillColor: AppTheme.primaryColor,
                  ),
                  textStyle: AppTheme.style.copyWith(
                    fontSize: 14 * measure.fontRatio,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black2,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _otp = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 5 + measure.screenHeight * 0.01),
              if (_numMinutes >= 0 && _numSeconds >= 0)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: measure.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            'Resend',
                            style: AppTheme.style.copyWith(
                                color: Colors.grey,
                                fontSize: 12 * measure.fontRatio),
                          ),
                        ),
                        Text(
                          "0$_numMinutes:" +
                              _numSeconds.toString().padLeft(2, '0'),
                          style: AppTheme.style.copyWith(
                              color: Colors.grey,
                              fontSize: 12 * measure.fontRatio),
                        ),
                      ],
                    ),
                  ),
                )
              else
                FlatButton(
                  onPressed: _resendOtp,
                  child: Text(
                    "Resend OTP",
                    style: AppTheme.style.copyWith(
                      color: Colors.grey[500],
                      fontSize: 12 * measure.fontRatio,
                    ),
                  ),
                ),
              SizedBox(height: 5 + measure.screenHeight * 0.01),
              CustomButton(
                height: 40 + measure.screenHeight * 0.01,
                width: measure.width * 0.7,
                onTap: () {
                  _otpScreenBloc.add(VerifyOtpEvent(otp: _otp));
                },
                color: _otpScreenBloc.posting
                    ? Colors.grey[400]
                    : AppTheme.primaryColor,
                child: Center(
                  child: RegularText(
                    text: 'Verify',
                    color: Colors.white,
                    fontSize: AppTheme.regularTextSize,
                  ),
                ),
              ),
              _otpScreenBloc.err
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      width: measure.width * 0.7,
                      child: RegularText(
                        text: _otpScreenBloc.errMsg,
                        color: AppTheme.cartRed,
                        fontSize: AppTheme.smallTextSize,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
