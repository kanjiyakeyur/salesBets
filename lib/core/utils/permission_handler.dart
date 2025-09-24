import 'dart:async';
import 'dart:io';

import 'package:baseproject/core/utils/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'life_cycle_event.dart';
import 'navigator_service.dart';

enum EnPermission { granted, denied, permanentlyDenied, none, limited }

class PermissionHandler {

  Future<EnPermission> _getPermissionStatus(Permission permissionType) async {
    var state = await permissionType.status;
    return _convertStatus(state);
  }

  Future<EnPermission> _requestPermission(Permission permissionType) async {
    var state = await permissionType.request();
    return _convertStatus(state);
  }

  Future<bool> checkPermissionAndRequest(Permission permissionType) async {
    var permissionStatus = await _getPermissionStatus(permissionType);
    // print("1 permissionStatus: ------------- $permissionType");
    // print(permissionStatus);
    if (permissionStatus == EnPermission.denied) {
      permissionStatus = await _requestPermission(permissionType);
      // print("2");
      // print(permissionStatus);
      // if(permissionStatus == EnPermission.permanentlyDenied){
      //   permissionStatus = await openAppSettingsOfApp(permissionType);
      //   print("3");
      //   print(permissionStatus);
      // }
    } else if (permissionStatus == EnPermission.permanentlyDenied) {
      // Handle permanently denied case, e.g., show a dialog to guide the user to settings
      // or open app settings directly.
      permissionStatus = await openAppSettingsOfApp(permissionType);
    } else if (permissionStatus == EnPermission.granted) {
      // Permission is already granted, no action needed.
    }

    return permissionStatus == EnPermission.granted || permissionStatus == EnPermission.limited ;
  }

  Future checkAllPermissions(List<Permission> permissionTypes) async {
    for (var permissionType in permissionTypes) {
      await checkPermissionAndRequest(permissionType);
    }
  }

  Future<EnPermission> openAppSettingsOfApp(Permission permissionType) async {
    var currentContext = NavigatorService.navigatorKey.currentContext;
    if(currentContext == null) {
      return EnPermission.none;
    }

    final completer = Completer<void>();
    final handler = LifecycleEventHandler(onResume: () {
      if (!completer.isCompleted) completer.complete();
    });
    WidgetsBinding.instance.addObserver(handler);

    await showDialog(context: currentContext, builder: (context){
      return AlertDialog(
        title: Text('Permission Required'),
        content: Text('${permissionType.toString()} permission is permanently denied. Please enable it in settings.'),
        actions: [
          TextButton(
            onPressed: () async {
              await openAppSettings();
              // Wait for the app to return from settings
              await completer.future;
              // print("----- App returned from settings");
              Navigator.of(context).pop();
              // ✨ App is back in focus
            },
            child: Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'),
          ),
        ],
      );
    });



    WidgetsBinding.instance.removeObserver(handler);
    var permissionStatus = await _getPermissionStatus(permissionType);
    // print("----- App Dialog closed : $permissionStatus");
    return permissionStatus;
  }

  EnPermission _convertStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return EnPermission.granted;
      case PermissionStatus.denied:
        return EnPermission.denied;
      case PermissionStatus.permanentlyDenied:
        return EnPermission.permanentlyDenied;
      case PermissionStatus.limited:
        return EnPermission.limited;
      default:
        return EnPermission.none;
    }
  }
}