import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smartcycle/Utils/SCircularProgress.dart';
import 'package:smartcycle/Utils/SmartCycleServer.dart';
import 'package:smartcycle/Utils/TabletDetector.dart';
import 'package:smartcycle/model/DoYouKnowDTO.dart';
import 'package:smartcycle/ui/doyouknow/doyouknow_card.dart';

class MainDoYouKnow extends StatefulWidget {
  @override
  _MainDoYouKnowState createState() => _MainDoYouKnowState();
}

class _MainDoYouKnowState extends State<MainDoYouKnow> {
  Future<DoYouKnows> _getDoYouKnow;

  @override
  void initState() {
    _getDoYouKnow = SmartCycleServer()
        .getDoYouKnow()
        .timeout(const Duration(seconds: 10));
  }

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return FutureBuilder<DoYouKnows>(
      future: _getDoYouKnow,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print("DoYouKnow 에러 " + snapshot.error.toString());
            return Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text("서버에 접근할 수 없었습니다."),
                  Text("이 문제가 계속해서 발생하면 문의해주세요."),
                  RaisedButton(
                    child: Text("재시도"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      _getDoYouKnow = SmartCycleServer()
                          .getDoYouKnow()
                          .timeout(const Duration(seconds: 10));
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          } else {
            var doYouKnow = new List<Widget>();

            for (var doyouknow in snapshot.data.datas) {
              doYouKnow.add(DoYouKnowCard(
                doYouKnow: doyouknow,
              ));
            }
            return TabletDetector.isTablet(queryData)
                ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.datas.length,
                itemBuilder: (BuildContext context, int index) {
                  return new DoYouKnowCard(
                    doYouKnow: snapshot.data.datas[index],
                  );
                })
                : CarouselSlider(
                height: 400.0,
                enlargeCenterPage: true,
                autoPlay: true,
                initialPage: 0,
                viewportFraction: 0.8,
                autoPlayInterval: const Duration(seconds: 8),
                items: snapshot.data.datas.map((i) {
                  return DoYouKnowCard(
                    doYouKnow: i,
                  );
                }).toList());
          }
        } else {
          return SCircularProgress();
        }
      },
    );
  }

//  List<Widget> _doYouKnowCard(DoYouKnows doYouKnows) {
//    return doYouKnow;
//  }
}
