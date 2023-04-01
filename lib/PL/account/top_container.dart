import 'package:abukhaledapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TopContainer extends StatefulWidget {

final  String? image_url,name,email,userId;


TopContainer({this.image_url,this.name,this.email,this.userId});

@override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider user = Provider.of<UserProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20.0),
        InkWell(
            onTap: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  onPressPhotoButton(context, user);
                }
              } on SocketException catch (_) {
                Fluttertoast.showToast(
                    msg: "تأكد من إتصالك بالإنترنت",
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: user.isImageLoading == true
                    ? Container(
                        width: width * .2,
                        height: height * 0.1,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        color: widget.image_url == ""
                            ? Colors.transparent
                            : Colors.grey,
                        width: height * .16,
                        height: height * .16,
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              )
                            : widget.image_url == ""
                                ? Icon(
                                    Icons.account_circle,
                                    size: height * .17,
                                  )
                                : Image.network(
                          widget.image_url!,
                                    fit: BoxFit.cover,
                                  ),
                      ))),
        SizedBox(height: 4.0),
        Text(
          widget.name!,
          style: TextStyle(
            fontSize: height * .02,
          ),
        ),
        Text(
          widget.email!,
          style: TextStyle(
            fontSize: height * .02,
            color: Colors.grey[700],
          ),
        ),        SizedBox(height: 20.0),

      ],
    );
  }

  onPressPhotoButton(BuildContext context, UserProvider user) {
    return showDialog(
        context: context,
        builder: (con) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SimpleDialog(
              title: Text(
                "تعديل صورة الملف الشخصي",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                SimpleDialogOption(
                  child: Text("التقاط بالكاميرا"),
                  onPressed: () async {
                    Navigator.pop(context);
                    final  pickedImage= await ImagePicker().getImage(
                        source: ImageSource.camera,
                        maxHeight: 680.0,
                        maxWidth: 970.0);
                    File? image =File(pickedImage!.path);
                    if (!await user.updateProfilePicture(
                        imageFile: image, userId: widget.userId!))
                      Fluttertoast.showToast(msg:user.error!);
                    else {
                      setState(() {
                        _imageFile = image;
                      });

                      Fluttertoast.showToast(msg: "تم تحديث الصورة بنجاح ");
                    }
                  },
                ),
                SimpleDialogOption(
                  child: Text("إختيار من المعرض"),
                  onPressed: () async {
                    Navigator.pop(context);
                    final pickedImage = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (!await user.updateProfilePicture(
                        imageFile: File(pickedImage!.path), userId: widget.userId!))
                      Fluttertoast.showToast(msg: user.error!);
                    else {
                      setState(() {
                        _imageFile = File(pickedImage.path);
                      });

                      Fluttertoast.showToast(msg: "تم تحديث الصورة بنجاح ");
                    }
                  },
                ),
                SimpleDialogOption(
                  child: Text("إلغاء"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }
}
