import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class Storage {

  DateFormat dateFormat = DateFormat("yyyy-MM-dd-HH:mm:ss");

  FirebaseStorage _storage = FirebaseStorage.instance;
  
    Future uploadPic(File file, String uid) async {
      //Create a reference to the location you want to upload to in firebase
      Reference reference = _storage.ref().child('/covers/' + uid + dateFormat.format(DateTime.now()) + '.jpg');

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(file);

      // Waits till the file is uploaded then stores the download url
      var dowurl = await (await uploadTask).ref.getDownloadURL();
      return dowurl.toString();
   }

}
