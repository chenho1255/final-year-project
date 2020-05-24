import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medapp1/notification/set_Notification.dart';

import 'package:path_provider/path_provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'dart:async';
import 'notification/notification_data.dart';
import 'notification/userInfo.dart';
import 'notification/show_notification.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),

));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {

    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = '';
  String resultER="";
  String dataRead="";
  String qrResult;

  Future _scanQR() async {
    try {
      final qrResult = await BarcodeScanner.scan();
      //decode(qrResult);
      var mydata= jsonDecode(qrResult);
      if (mydata[0]['PPSN'] == null|| mydata[0]['Hour'] == null
          ||mydata[0]['Minute'] == null){
        return false;
      }
      setState(() {
        result = qrResult;
        //writeContent(); //save data from scanner
        resultER = "";
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          resultER = "Camera permission was denied\n$ex";
          result = "";
        });
      } else {
        setState(() {
          resultER = "Unknown Error $ex";
          result = "";
        });
      }
    } on FormatException catch (ex) {
      setState(() {
        resultER = "please scan in the correct information";
        result = "";
      });
    } catch (ex) {
      setState(() {
        resultER = "Unknown Error $ex";
        result = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Medical App"),
      ),

      body: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              resultER+ "\n" +result,
              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            //new Text(_user[0].name),

            new RaisedButton(
                child:  Text('save'),
                onPressed: writeContent

            ),

        // check is the intermation save
            /*new RaisedButton(
                child: Text(
                  "read",
                  //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                onPressed: readcontent
            ),*/
            new RaisedButton(
                child:  Text(
                    "notification"),
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => notification()
                      )
                  );
                }),

            new RaisedButton(
                child:  Text(
                    "Set Notiftication"),
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => setNotification()
                      )
                  );
                }),
          ]

      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: _scanQR
      ),




      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }


//====================================================================
  //new read and wirte
  Future<File> writeContent() async {

      if(result ==""){
        print("Fail to Save");
        setState(() {
          resultER= "Fail to Save";

        });
      }
      else{
        final result1 = result;
        final file = await _localFile;
        print("loook at me file path "+file.toString());
        // Write the file
        print("save successful");
        setState(() {
          resultER = "Save Successful";
          result="";
        });
        return file.writeAsString(result1);
      }


  }
  Future<File> get _localFile async {
    final path = await _localPath;
    print("loook at me"+'$path/data.json');
    return File('$path/data.json');

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print("loook at me"+directory.path);
    return directory.path;
  }

  Future<String> readcontent() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();
      print(contents);
      dataRead = contents;
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

  Future<String>decode(String qrResult) async{
    print ("test qr code scanner ");
    print(qrResult);

    final key = Key.fromUtf8('This is a Key123');
    final iv = IV.fromUtf8('This is an IV456');


    print("test");
    final encrypter = Encrypter(AES(key, mode: AESMode.cfb64 ));

    final text = base64Decode(qrResult).toString();

    print("test2");
    print(text.toString());

    print("test3");
    //print(test2);

    print('test4');

    print("test5");
    //stop running at
    final decrypted = encrypter.decrypt64(text, iv: iv);
    print(""+decrypted);
    //final test2 = json.decode(decrypted);

    print(decrypted);

    print("test6");

    print("chack decrypted");
  }
}

