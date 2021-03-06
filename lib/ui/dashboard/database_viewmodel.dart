import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:steps_count/api/database_api.dart';
import 'package:steps_count/app/app.locator.dart';
import 'package:steps_count/app/app.logger.dart';
import 'package:steps_count/app/app.router.dart';
import 'package:steps_count/services/user_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:steps_count/main.dart';

class DashboardViewModel extends BaseViewModel {
  final log = getLogger('DashboardViewModel');
  final userService = locator<UserService>();
  final navigationService = locator<NavigationService>();
  final _databaseApiService = locator<DatabaseApi>();
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String status = '?';
  double percentage = 0;
  String profilepic = '';
  late Timer timer;
  int timehour = 0;
  int start = 300, steps = 0;
  List intervals = [
    {
      "steps": 0,
    }
  ];
  List<FlSpot> data = [];
  void onStepCount(StepCount event) {
    print(event);
    setSteps(steps + 1);
    print(((event.steps / 10000) * 100).toDouble());
  }

  void setSteps(int step) {
    steps = step;
    notifyListeners();
  }

  void setStatus(String statuses) {
    status = statuses;
    notifyListeners();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setStatus(event.status);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          data.add(FlSpot(1, (start + 3).toDouble()));
          steps = 0;
          start = 300;

          notifyListeners();
          _databaseApiService.updateSteps(
            user: userService.currentUser!,
            steps: {
              "$start minutes": "${steps.toString()}",
            },
          );
          log.v('Database updated');
          startTimer();
        } else {
          start--;
          timehour = timehour + 5;
          notifyListeners();
        }
      },
    );
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setStatus("Pedestrian Status not available");
    print(status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setSteps(-1);
  }

  void initPlatformState() async {
    var status = await Permission.activityRecognition.isGranted;
    if (status) {
      print('permission granted');
    } else {
      Permission.activityRecognition.request();
    }
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  Future<void> logout() async {
    await userService.logout;
    log.v('Successfully Logged out');
    runStartupLogic();
  }

  Future<void> runStartupLogic() async {
    setBusy(true);
    if (userService.hasLoggedInUser || userService.currentUser != null) {
      log.v('We have a user session on disk. Sync the user profile ...');
      await userService.syncUserAccount();
      log.v('User sync complete. User profile');
      setBusy(false);
      navigationService.replaceWith(Routes.dashboardView);
    } else {
      log.v('No user on disk, navigate to the LoginView');
      setBusy(false);
      navigationService.replaceWith(Routes.loginView);
    }
  }

  testapi() {
    scheduleAlarm(DateTime.now());
  }

  void setProfilePic() {
    profilepic = userService.currentUser!.photourl!;
    notifyListeners();
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Office', "alarmInfo.title", platformChannelSpecifics);
  }
}
