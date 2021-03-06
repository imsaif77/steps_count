// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../ui/buysell/buysell_view.dart';
import '../ui/dashboard/dashboard_view.dart';
import '../ui/login/login_view.dart';
import '../ui/newdashboard/newdashboard_view.dart';
import '../ui/share/share_view.dart';
import '../ui/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/start-up-view';
  static const String loginView = '/login-view';
  static const String dashboardView = '/dashboard-view';
  static const String newDashboardView = '/';
  static const String shareView = '/share-view';
  static const String buySellView = '/buy-sell-view';
  static const all = <String>{
    startUpView,
    loginView,
    dashboardView,
    newDashboardView,
    shareView,
    buySellView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.dashboardView, page: DashboardView),
    RouteDef(Routes.newDashboardView, page: NewDashboardView),
    RouteDef(Routes.shareView, page: ShareView),
    RouteDef(Routes.buySellView, page: BuySellView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    DashboardView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const DashboardView(),
        settings: data,
      );
    },
    NewDashboardView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const NewDashboardView(),
        settings: data,
      );
    },
    ShareView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const ShareView(),
        settings: data,
      );
    },
    BuySellView: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const BuySellView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginView arguments holder class
class LoginViewArguments {
  final Key? key;
  LoginViewArguments({this.key});
}
