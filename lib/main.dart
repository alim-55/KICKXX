import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:kickxx/signin_screen.dart';
import 'HomePage.dart';
import 'package:kickxx/BottomNavigation.dart';
import 'firebase_options.dart';
import 'notification_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
      null,//'resource://drawable/app_icon.png',
      [
        NotificationChannel(
          channelGroupKey: "basic_Channel_group",
          channelKey: "basic_channel",
          channelName: "Basic Notification",
          channelDescription: "Basic Notification Channel",
          //defaultColor: Colors.deepPurple,
        )

      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: "basic_Channel_group",
          channelGroupName: "Basic Group",
        )
      ]
  );
  bool isAllowedToSendNotification=
  await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToSendNotification){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  var islogin=false;
  var auth=FirebaseAuth.instance;
  checkifLogin()async{
    auth.authStateChanges().listen((User? user) {
      if(user!= null &&mounted){
        setState(() {
          islogin=true;

        });
      }
    });
  }
  void initState(){
    checkifLogin();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogin ? HomeWithBottomNavigation() : SignInScreen(),
    );
  }
}

class HomeWithBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigation(),
    );
  }
}


/*class MyApp extends  StatefulWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}
*/