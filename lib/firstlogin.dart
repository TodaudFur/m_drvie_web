import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:m_drvie_web/controller/drive_home_controller.dart';

import 'constants.dart';

class FirstLogin extends StatefulWidget {
  const FirstLogin({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  _FirstLoginState createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
  final emController = TextEditingController();
  final psController = TextEditingController();
  final cpsController = TextEditingController();

  final driveHomeController = Get.find<DriveHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            SystemChrome.setEnabledSystemUIOverlays([]);
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 15.0, top: 10.0),
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.arrow_left),
                        onPressed: () {
                          Get.offAllNamed('/drive');
                        },
                      ),
                    )),
                Expanded(
                  flex: 95,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(30.0),
                      alignment: Alignment.topCenter,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "images/logo_em_3.png",
                            height: 70.0,
                            color: kSelectColor,
                          ),
                          Divider(
                            color: Colors.white,
                            height: 40.0,
                          ),
                          Text(
                            "초기 회원정보 변경",
                            style: TextStyle(
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.w900,
                                fontSize: 18.0,
                                color: Colors.black),
                          ),
                          Text(
                            "안전한 사용을 위하여, 회원정보를 변경하여 주시기 바랍니다!\n" +
                                "아래에 비밀번호와 이메일을 입력해주시기 바랍니다.\n",
                            style: TextStyle(
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.w900,
                                fontSize: 10.0,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                onSubmitted: (String s) {},
                                controller: psController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '새 비밀번호',
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              TextField(
                                onSubmitted: (String s) {},
                                controller: cpsController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '비밀번호 확인',
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              TextField(
                                onSubmitted: (String s) {},
                                controller: emController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'E-Mail',
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            height: 40.0,
                          ),
                          RaisedButton(
                            color: kSelectColor,
                            padding: EdgeInsets.only(left: 40.0, right: 40.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              setState(() {
                                if (psController.text == cpsController.text) {
                                  firstChange(
                                          psController.text, emController.text)
                                      .then((value) {
                                    Fluttertoast.showToast(
                                        msg: "회원정보가 변경되었습니다. 다시 로그인해주세요!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16.0);

                                    Get.offAllNamed('/drive');
                                  }).catchError((onError) {
                                    print(onError);
                                    Fluttertoast.showToast(
                                        msg: "회원정보가 변경이 실패하였습니다! 다시 입력해주세요!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16.0);
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "비밀번호가 서로 다릅니다.\n다시 입력해주세요",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                }
                                SystemChrome.setEnabledSystemUIOverlays([]);
                              });
                            },
                            child: Text(
                              "변경",
                              style: TextStyle(
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.0,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  firstChange(String password, String email) async {
    print(password);
    print(email);
    var url = Uri.parse(
        'https://www.official-emmaus.com/g5/bbs/emmaus_password_process.php');
    var result = await http.post(url,
        body: {"mb_name": widget.name, "password": password, "email": email});

    print(result.body);
  }
}
