part of '../phone_screen.dart';

class MobInputWidget extends StatefulWidget {
  MobInputWidget({Key key}) : super(key: key);

  @override
  _MobInputWidgetState createState() => _MobInputWidgetState();
}

class _MobInputWidgetState extends State<MobInputWidget> {
  PhoneScreenBloc _phoneScreenBloc;

  @override
  void initState() {
    super.initState();
    _phoneScreenBloc = BlocProvider.of<PhoneScreenBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    return BlocBuilder(
      cubit: _phoneScreenBloc,
      builder: (context, state) {
        return Container(
          height: measure.screenHeight,
          width: measure.width * 0.8,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: measure.width * 0.15,
                    height: 40 + measure.screenHeight * 0.01,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: state is PhoneError ? 0.5 : 0.3,
                        color: state is PhoneError
                            ? AppTheme.cartRed
                            : Color(0xff707070),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: RegularText(
                      text: '+91',
                      color: AppTheme.black2,
                      fontSize: AppTheme.regularTextSize,
                    ),
                  ),
                  Container(
                    width: measure.width * 0.6,
                    height: 40 + measure.screenHeight * 0.01,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: state is PhoneError ? 0.5 : 0.3,
                        color: state is PhoneError
                            ? AppTheme.cartRed
                            : Color(0xff707070),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      controller: _phoneScreenBloc.mobController,
                      // style: style,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Mobile Number",
                        border: InputBorder.none,
                      ),
                      style: AppTheme.style.copyWith(
                        fontSize: AppTheme.regularTextSize * measure.fontRatio,
                        color: AppTheme.black2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5 + measure.screenHeight * 0.01),
              SizedBox(height: 5 + measure.screenHeight * 0.01),
              CustomButton(
                height: 40 + measure.screenHeight * 0.01,
                width: measure.width * 0.8,
                onTap: () {
                  if (state is Loading) {
                    return;
                  }
                  _phoneScreenBloc.add(SendOtpEvent());
                },
                color: state.runtimeType == Loading
                    ? Colors.grey[500]
                    : AppTheme.primaryColor,
                child: Center(
                  child: RegularText(
                    text: 'Login or Register',
                    color: Colors.white,
                    fontSize: AppTheme.regularTextSize,
                  ),
                ),
              ),
              // RaisedButton(
              //   onPressed: () {
              //     if (state is Loading) {
              //       return;
              //     }
              //     _phoneScreenBloc.add(SendOtpEvent(_input.text));
              //   },
              //   color: state.runtimeType == Loading
              //       ? Colors.grey[500]
              //       : AppTheme.primaryColor,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20.0),
              //   ),
              //   child: Text(
              //     'Login or Register',
              //     style: AppTheme.style.copyWith(color: Colors.white),
              //   ),
              // ),
              SizedBox(height: measure.screenHeight * 0.015),
              Container(
                child: Text(
                  state.runtimeType == PhoneError
                      ? "Please enter 10 digit mobile number"
                      : "",
                  style: AppTheme.style.copyWith(color: AppTheme.redCancel),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
