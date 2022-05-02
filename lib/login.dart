import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:m_drvie_web/controller/drive_home_controller.dart';
import 'package:m_drvie_web/data/model/user_model.dart';

import 'constants.dart';
import 'find.dart';
import 'firstlogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController();
  final psController = TextEditingController();

  final driveHomeController = Get.put(DriveHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onSubmitted: (String s) {},
                        controller: idController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'ID',
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      TextField(
                        onSubmitted: (String s) {
                          setState(() {
                            Get.dialog(const Center(
                              child: CircularProgressIndicator(),
                            ));
                            post(idController.text, psController.text)
                                .then((value) {
                              Get.back();
                              if (getFirst()) {
                                Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => FirstLogin(
                                                  name: driveHomeController
                                                      .userModel.name,
                                                )),
                                        (route) => false)
                                    .then((value) => setState(() {}));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "로그인 성공!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                                Get.toNamed('/drive');
                              }
                            }).catchError((onError) {
                              print(onError);
                              Get.back();
                              Fluttertoast.showToast(
                                  msg: "로그인 실패! : 아이디 또는 비밀번호를 확인해주세요.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            });
                          });
                        },
                        controller: psController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return const Find(
                                  what: 'id',
                                );
                              }));
                            },
                            child: Text("아이디 찾기"),
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return const Find(what: "pwd");
                              }));
                            },
                            child: Text("비밀번호 초기화"),
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: kSelectColor,
                    padding: EdgeInsets.only(left: 40.0, right: 40.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      Get.dialog(const Center(
                        child: CircularProgressIndicator(),
                      ));
                      setState(() {
                        post(idController.text, psController.text)
                            .then((value) {
                          Get.back();
                          if (getFirst()) {
                            Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => FirstLogin(
                                              name: driveHomeController
                                                  .userModel.name,
                                            )),
                                    (route) => false)
                                .then((value) => setState(() {}));
                          } else {
                            Fluttertoast.showToast(
                                msg: "로그인 성공!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                fontSize: 16.0);
                            Get.toNamed('/drive');
                          }
                        }).catchError((onError) {
                          print(onError);
                          Get.back();
                          Fluttertoast.showToast(
                              msg: "로그인 실패! : 아이디 또는 비밀번호를 확인해주세요.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        });
                      });
                    },
                    child: Text(
                      "로그인",
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
      ),
    );
  }

  bool getFirst() {
    if (driveHomeController.userModel.isFirst == "False") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> post(String id, String password) async {
    print(id);
    var url =
        Uri.parse('https://www.official-emmaus.com/g5/bbs/app_login_check.php');
    var result =
        await http.post(url, body: {"mb_id": id, "mb_password": password});
    //print(result.body);
    //0 : name / 1 : isFirst / 2 : cell / 3 : team / 4 : term / 5 : special / 6 : normal

    print(result);
    Map<String, dynamic> body = json.decode(result.body);
    if (body['cell'] != null) {
      driveHomeController.isLogin = true;
      driveHomeController.userModel = UserModel(
          id: id,
          name: body["name"],
          cell: body["cell"],
          team: body["team"],
          term: body["term"],
          isFirst: body["isFirst"],
          special: int.parse(body["special"]),
          normal: (int.parse(body["normal"]) + 3));
      return true;
    } else {
      return false;
    }
  }
}
