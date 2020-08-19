// part of '../registration_screen.dart';

// class RegistrationScreenBodyWidget extends StatefulWidget {
//   RegistrationScreenBodyWidget({Key key}) : super(key: key);

//   @override
//   _RegistrationScreenBodyWidgetState createState() =>
//       _RegistrationScreenBodyWidgetState();
// }

// class _RegistrationScreenBodyWidgetState
//     extends State<RegistrationScreenBodyWidget> {
//   //States for form filling
//   RegistrationScreenBloc _registrationScreenBloc;
//   TextEditingController _nameController;
//   TextEditingController _referralController;
//   FocusNode _nameFocus;
//   FocusNode _referralFocus;
//   FocusNode _cityFocus;
//   FocusNode _areaFocus;

//   //States for dropdowns
//   List<dynamic> _places = List<dynamic>();
//   List<dynamic> _areas = List<dynamic>();
//   bool _loadingPlaces = true;
//   String _cityVal;
//   String _areaVal;
//   String _place;

//   @override
//   void initState() {
//     super.initState();
//     _getPlaces();

//     _registrationScreenBloc = BlocProvider.of<RegistrationScreenBloc>(context);
//     _nameController = TextEditingController();
//     _nameFocus = FocusNode();
//     _referralController = TextEditingController();
//     _referralFocus = FocusNode();
//     _cityFocus = FocusNode();
//     _areaFocus = FocusNode();
//     _nameFocus.requestFocus();
//   }

//   void _getPlaces() async {
//     GetPlaces getPlaces = sl<GetPlaces>();
//     final failureOrPlaces = await getPlaces(NoParams());
//     failureOrPlaces.fold(
//       (failure) {
//         switch (failure.code) {
//           case 100:
//             print('[sys] : Server cannot be reached');
//             break;
//           case 300:
//             print('[sys] : Device not connected to the internet');
//             break;
//           default:
//         }
//       },
//       (places) {
//         setState(() {
//           _loadingPlaces = false;
//           _places.addAll(places);
//         });
//       },
//     );
//   }

//   void _selectCity(val) {
//     final areas = _places[_places.indexWhere((place) => place.id == val)].areas;
//     setState(() {
//       _cityVal = val;
//       _areaVal = null;
//       _place = '';
//       _areas = areas;
//     });
//   }

//   void _selectArea(val) {
//     final areaName = _areas[_areas.indexWhere((area) => area.id == val)].name;
//     setState(() {
//       _place = areaName;
//       _areaVal = val;
//     });
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _referralController.dispose();
//     _nameFocus.dispose();
//     _referralFocus.dispose();
//     _cityFocus.dispose();
//     _areaFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Measure measure = MeasureImpl(context);
//     return BlocBuilder(
//       cubit: _registrationScreenBloc,
//       builder: (context, state) {
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: measure.width * 0.1),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: measure.screenHeight * 0.1),
//               InputWidget(
//                 title: "Name",
//                 controller: _nameController,
//                 focus: _nameFocus,
//                 hintText: "Your Name",
//                 onSubmitted: (term) {
//                   print('[dbg] : $term');
//                   _referralFocus.requestFocus();
//                 },
//                 err: state is RegistrationScreenError ? state.nameErr : false,
//                 errMsg: "Please enter your name",
//               ),
//               InputWidget(
//                 title: "Referral Code",
//                 controller: _referralController,
//                 focus: _referralFocus,
//                 onSubmitted: () {
//                   _cityFocus.requestFocus();
//                 },
//                 hintText: "Eg: RC1045",
//               ),
//               CustomDropdown(
//                 objs: _places,
//                 loading: _loadingPlaces,
//                 val: _cityVal,
//                 onChange: _selectCity,
//                 err: state is RegistrationScreenError ? state.cityErr : false,
//                 errMsg: "Please select city",
//                 title: "City",
//               ),
//               CustomDropdown(
//                 objs: _areas,
//                 loading: _loadingPlaces,
//                 val: _areaVal,
//                 onChange: _selectArea,
//                 title: "Area",
//                 err: state is RegistrationScreenError ? state.cityErr : false,
//                 errMsg: "Please select area",
//               ),
//               SubmitBtnRounded(
//                 onPressed: () {
//                   _registrationScreenBloc.add(RegisterUserEvent(
//                     name: _nameController.text,
//                     referralCode: _referralController.text,
//                     cityId: _cityVal,
//                     areaId: _areaVal,
//                     place: _place,
//                   ));
//                 },
//                 loading: false,
//                 color: AppTheme.primaryColor,
//                 value: 'Register',
//                 radius: 4,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
