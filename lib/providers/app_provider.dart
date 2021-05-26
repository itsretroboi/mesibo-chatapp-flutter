import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppProvider extends ChangeNotifier {
  //Get Root Path
  String _rootPath = " ";
  String get rootPath => _rootPath;

  set rootPath(String i) {
    _rootPath = i;
    notifyListeners();
  }
  //

  //Request Permissions
  Map<Permission, PermissionStatus> _permissions = {
    Permission.notification: PermissionStatus.denied,
    Permission.storage: PermissionStatus.denied,
  };
  Map<Permission, PermissionStatus> get permissions => _permissions;
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.storage,
    ].request();

    _permissions = statuses;
    print(_permissions);
    notifyListeners();
  }
  //

  //Set Application Orientation
  void setAppOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
  //
}
