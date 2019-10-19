import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartcycle/AddDevice.dart';
import 'package:smartcycle/SCircularProgress.dart';
import 'package:smartcycle/Utils/AuthUtils.dart';
import 'package:smartcycle/SmartDialog.dart';
import 'package:smartcycle/TutorialsPage.dart';
import 'package:smartcycle/main.dart';
import 'package:smartcycle/model/GoogleProfileDTO.dart';
import 'package:smartcycle/assets.dart';
import 'package:smartcycle/model/InitUserDTO.dart';
import 'package:smartcycle/styles/Styles.dart';
import 'package:smartcycle/ui/auth/auth_login.dart';
import 'package:smartcycle/ui/auth/auth_profile.dart';
import '../../model/GoogleUserDTO.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

BuildContext mContext;

String access_token = "INIT";
bool isUserAvail = false;
bool isAccessTokenAvail = false;
bool isProfileAlreadyLoaded = false;

String userEmail;
String userName;
String userId;
String userProfile;

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<AuthMainData> _initAccessToken;

  Future<AuthMainData> initAccessToken() async {
    String access_token = await AuthUtils().getAccessToken();
    String user_id = await AuthUtils().getUserId();
    if (access_token == null || access_token.isEmpty) return null;
    return AuthMainData(access_token: access_token, user_id: user_id);
  }

  @override
  void initState() {
    super.initState();
    _initAccessToken = initAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FutureBuilder<AuthMainData>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return LoginPage();
          } else {
            return AuthProfile(
              access_token: snapshot.data.access_token,
              user_id: snapshot.data.user_id,
            );
          }
        } else {
          return SCircularProgressWithBtn();
        }
      },
    ));
  } //  @override
//  Widget build(BuildContext context) {
//    if (access_token == null || access_token.length <= 10) {
//      AuthUtils().getAccessToken().then((token) {
//        access_token = token;
//        if (access_token.length >= 8) {
//          isAccessTokenAvail = true;
//        } else {
//          isAccessTokenAvail = false;
//        }
//
//        print("액세스 토큰의 유무 : " + isAccessTokenAvail.toString());
//
//        setState(() {});
//      });
//
//      AuthUtils().getUserId().then((user_id) {
//        userId = user_id;
//      });
//    } else {
//      if (isProfileAlreadyLoaded != true) {}
//    }
//
//    mContext = context;
//    return Scaffold(
//        body: !isAccessTokenAvail
//            ? LoginPage()
//            : AuthProfile(
//          user_id: userId,
//          access_token: access_token,
//        ));
//    //body: LoginPage());
//  }

  @override
  void dispose() {
    access_token = "INIT";
    userId = "";
    isAccessTokenAvail = false;
    isProfileAlreadyLoaded = false;
  }
}

class AuthMainData {
  String access_token;
  String user_id;

  AuthMainData({this.access_token, this.user_id});
}

//Future<String> _openGoogleAuth() async {
//  String data;
//  await launch("https://smartcycle.ljhnas.com/getGoogleAuth").then((value) {});
//  //print(data.toString());
//  return data;
//}

// GET /getGoogleAuth 의 응답 결과 예시
// { "access_token": ya29.Il-PBzH0ujxpeon-TCBdu7eL9fydzpfKJmoGY5rrQTVp29ANANarLREQ6Ipo-iTgnHe_YNOLjrzBvsEe4W74-behloGRib5Z258uVa5lR5TGzTMZ8AkSn7sKLqrQDaKpJw,
// "refresh_token" : 1/VKCgCK35dvRxZVp6xc-0zWizdSbX96enrvp_vHBQOMc,
// "expires_in" : 3600 }
