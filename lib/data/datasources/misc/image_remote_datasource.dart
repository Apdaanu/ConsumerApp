import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../core/token/token_provider.dart';

abstract class ImageRemoteDatasource {
  Future<String> uploadImage({
    @required String fileName,
    @required File file,
  });
}

class ImageRemoteDatasourceImpl implements ImageRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;
  final FlutterImageCompress flutterImageCompress;

  ImageRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
    @required this.flutterImageCompress,
  });

  @override
  Future<String> uploadImage({
    String fileName,
    File file,
  }) async {
    final String token = await tokenProvider.getToken();
    final File compressedFile = await compressImage(fileName, file);

    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(Connection.endpoint + '/image/upload'),
    );

    request.files.add(
      http.MultipartFile(
        'image',
        compressedFile.readAsBytes().asStream(),
        compressedFile.lengthSync(),
        filename: fileName,
      ),
    );

    request.headers.addAll({'Authorization': "Bearer $token"});

    return request.send().then((responseStream) async {
      http.Response response = await http.Response.fromStream(responseStream);
      if (responseStream.statusCode == 200) {
        print('[sys] : image uploaded succesfully');
        return json.decode(response.body)['imgurl'];
      } else {
        print('[dbg] : ${response.body}');
        throw ServerException();
      }
    });
  }

  static Future<File> compressImage(String filename, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$filename.jpg',
      quality: 15,
    );
    print('[dbg] : ${image.lengthSync()}');
    print('[dbg] : ${compressedImageFile.lengthSync()}');
    return compressedImageFile;
  }
}
