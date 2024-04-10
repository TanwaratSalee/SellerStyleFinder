import 'package:seller_finalproject/const/const.dart';

Widget loadingIndcator({circleColor = fontGrey}) {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(primaryApp),
    ),
  );
}