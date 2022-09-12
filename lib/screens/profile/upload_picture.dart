import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class UploadImage extends StatefulWidget {
  final String? data;
  const UploadImage({Key? key, this.data}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  late String base64Image;
  late String tmpFile;
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  startUpload() {
    // String fileName = tmpFile.path.split('/').last;
    upload();
  }

  upload({String? fileName}) async {
    var token = await UserPreferences.getToken();
    var newToken = {'Authorization': 'Bearer $token'};

    var request = http.MultipartRequest('POST', Uri.parse(Network.uploadImage));
    request.files.add(http.MultipartFile('file',
        File(tmpFile).readAsBytes().asStream(), File(tmpFile).lengthSync(),
        filename: tmpFile.split("/").last));
    request.headers.addAll(newToken);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            tmpFile = _imageFileList![index].path;
            base64Image = base64Encode(
                File(_imageFileList![index].path).readAsBytesSync());
            return Column(
              children: [
                Semantics(
                  label: 'image_picker_example_picked_image',
                  child: kIsWeb
                      ? Image.network(_imageFileList![index].path)
                      : Image.file(File(_imageFileList![index].path)),
                ),
                TextButton(onPressed: startUpload, child: Text("Take pic"))
              ],
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
            alignment: Alignment.centerLeft, child: Text("Take picture")),
      ),
      body: Center(
        child: !kIsWeb
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    default:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                  }
                },
              )
            : _handlePreview(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              backgroundColor: fkBlueText,
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: fkDefaultColor,
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return onPick(500, 800, 70);
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);



// =====================================UploadImage

// static final String uploadEndPoint = '';
//   File? _image;
//   String status = '';
//   late String base64Image;
//   late File tmpFile;
//   String errMessage = "Error uploading image";

//   // getImagefromcamera() {
//   //   var image = ImagePicker.pickImage(source: ImageSource.camera);
//   //   setState(() {
//   //     _image = image;
//   //   });
//   // }

//   Future getImagefromGallery() async {
//     final image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (image == null) return;

//     setState(() {
//       _image = File(image!.path); // won't have any error now
//     });
//   }

//   setStatus(String message) {
//     setState(() {
//       status = message;
//     });
//   }

//   startUpload() {
//     setStatus('Uploading Image...');
//     if (null == tmpFile) {
//       setStatus(errMessage);
//     }
//     String fileName = tmpFile.path.split('/').last;
//     upload(fileName);
//   }

//   upload(String fileName) {
//     Dio().post(" ", data: {
//       'image': base64Image,
//       'name': fileName,
//     }).then((result) {
//       // Navigator.push(context,
//       // MaterialPageRoute(builder: (context) => CandidateRegisterPage()));
//       setStatus(result.statusCode == 200 ? result.data : errMessage);
//     }).catchError((error) {
//       setStatus(error);
//     });
//   }

//   Widget showImage() {
//     late Future<File>? image = _image as Future<File>;
//     return FutureBuilder(
//       future: image,
//       builder: (BuildContext content, AsyncSnapshot<File> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             null != snapshot.data) {
//           // print(snapshot.data);
//           tmpFile = snapshot.data!;
//           base64Image = base64Encode(snapshot.data!.readAsBytesSync());
//           return Flexible(child: Image.file(snapshot.data!, fit: BoxFit.fill));
//         } else if (null != snapshot.error) {
//           return const Text(
//             'Error Picking Image',
//             textAlign: TextAlign.center,
//           );
//         } else {
//           return const Text(
//             'No Image selected',
//             textAlign: TextAlign.center,
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Set a picture"),
//       //   backgroundColor: Color(0xff004D40),
//       // ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.only(top: 0.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 400.0,
//                 child: Center(
//                   // child: _image == null
//                   //     ? Text("No Image is picked")
//                   //     : Image.file(_image, height: 400, fit: BoxFit.contain),
//                   child: showImage(),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 80,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 // FloatingActionButton(
//                 //   onPressed: getImagefromcamera,
//                 //   tooltip: "pickImage",
//                 //   child: Icon(Icons.add_a_photo),
//                 // ),
//                 FloatingActionButton(
//                   onPressed: getImagefromGallery,
//                   tooltip: "Pick Image",
//                   child: Icon(Icons.camera_alt),
//                 ),
//                 FloatingActionButton(
//                   onPressed: startUpload,
//                   tooltip: "Save info",
//                   child: Icon(Icons.save),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
