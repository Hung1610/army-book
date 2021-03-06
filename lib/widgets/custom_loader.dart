import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:army_book/utils/index.dart';

Widget _getLoaderType(int type) {
  Widget _defaultLoader;

  switch (type) {
    case 0:
      _defaultLoader = SpinKitRipple(
        color: Colors.blueGrey,
      );
      break;
    case 1:
      _defaultLoader = SpinKitChasingDots(
        color: Colors.blueGrey,
      );
      break;
    case 2:
      _defaultLoader = SpinKitCubeGrid(
        color: Colors.blueGrey,
      );
      break;
    case 3:
      _defaultLoader = SpinKitFadingCube(
        color: Colors.blueGrey,
      );
      break;
    default:
      _defaultLoader = SpinKitDoubleBounce(
        color: Colors.blueGrey,
      );
  }
  return _defaultLoader;
}

Widget _mainLoader(double heightFromTop, String loaderText, int loaderType) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: heightFromTop,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _getLoaderType(loaderType),
      ),
      SizedBox(height: 15),
      Center(
        child: Text(
          loaderText,
          style: TextStyle(
            color: mainColor,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    ],
  );
}

/// spinkit loader type
/// 0 - SpinKitRipple
/// 1 - SpinKitChasingDots
/// 2 -  SpinKitCubeGrid
/// 3 - SpinKitFadingCube
/// default: SpinKitDoubleBounce
Widget customLoader({
  double heightFromTop: 50,
  String loaderText: 'loading...',
  int loaderType: 6,
  bool isInitLoader: false,
}) {
  return isInitLoader
      ? MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hatchpro Hatcheries',
          theme: colorTheme,
          home: _InitLoader(
            heightFromTop: heightFromTop,
            loaderText: loaderText,
            loaderType: loaderType,
          ),
        )
      : _mainLoader(heightFromTop, loaderText, loaderType);
}

class _InitLoader extends StatelessWidget {
  final double? heightFromTop;
  final String? loaderText;
  final int? loaderType;

  const _InitLoader(
      {Key? key, this.heightFromTop, this.loaderText, this.loaderType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Center(
          child: _mainLoader(heightFromTop!, loaderText!, 1),
        ),
      ),
    );
  }
}
