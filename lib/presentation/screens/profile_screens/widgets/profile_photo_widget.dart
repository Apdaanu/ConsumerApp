import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';

class ProfilePhotoWidget extends StatefulWidget {
  final double size;
  final bool edit;

  const ProfilePhotoWidget({
    Key key,
    this.size,
    this.edit,
  }) : super(key: key);

  @override
  _ProfilePhotoWidgetState createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  UserDetailsBloc _userDetailsBloc;
  ImagePicker picker;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    picker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return BlocBuilder(
      cubit: _userDetailsBloc,
      builder: (context, state) => Stack(
        children: <Widget>[
          Padding(
            padding: widget.edit == true ? EdgeInsets.all(10) : EdgeInsets.zero,
            child: Container(
              height: widget.size ?? 100 + measure.width * 0.05,
              width: widget.size ?? 100 + measure.width * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image:
                      Image.network(_userDetailsBloc.userDetails.profilePhoto)
                          .image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          widget.edit == true
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      await _getImage();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0),
                              color: Color(0x29000000),
                            ),
                          ]),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _cropImage(pickedFile);
  }

  Future<void> _cropImage(imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: AppTheme.primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        activeControlsWidgetColor: AppTheme.primaryColor,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 50,
    );

    if (croppedFile != null) {
      _userDetailsBloc.add(UserDetailsChangePhoto(croppedFile));
    }
  }
}
