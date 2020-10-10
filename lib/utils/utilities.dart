import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];

    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    //Giving a temporary storage path name
    final tempDir = await getTemporaryDirectory();

    final path = tempDir.path;

    int random = Random().nextInt(1000);

    // Im.Image image = Im.decodeImage(
    //     imageToCompress.readAsBytesSync()); //Just read image in this step
    // //Code for compressing image - we compress it by reducing :-
    // // Height, weight, dimensions, quality
    // Im.copyResize(image, height: 500, width: 500);

    //Encoding image

    // return new File('$path/img_$random.jpg')
    // ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}
