import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/views/auth_screen/login_screen.dart';
import 'package:seller_finalproject/views/home_screen/home.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }
  
  var isLoggedin = false;

  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if(user == null && mounted) {
        isLoggedin = false;
      } else {
        isLoggedin = true;
      }
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedin? const Home() : const LoginScreen() ,
     theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: greyColor,
            onPrimary: whiteColor,
            secondary: whiteColor,
            onSecondary: blackColor,
            error: redColor,
            onError: whiteColor,
            background: whiteColor,
            onBackground: blackColor,
            surface: whiteColor,
            onSurface: blackColor,
          ),
          dialogBackgroundColor: whiteColor,
          scaffoldBackgroundColor: whiteColor,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: blackColor),
              elevation: 0.0,
              backgroundColor: Colors.transparent),
          primaryColor: primaryApp,
          fontFamily: regular,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: thinPrimaryApp,
            selectionHandleColor: primaryApp,
            cursorColor: primaryApp,
          )),
      
    );
  }
}
