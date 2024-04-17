import 'package:seller_finalproject/const/const.dart';

Widget loadingIndicator({circleColor = greyColor}) {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(primaryApp),
    ),
  );
}