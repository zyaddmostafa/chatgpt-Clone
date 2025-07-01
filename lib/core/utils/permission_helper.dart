import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestMicrophonePermission() async {
    try {
      PermissionStatus status = await Permission.microphone.status;

      if (status == PermissionStatus.granted) {
        log('Microphone permission already granted');
        return true;
      }

      if (status == PermissionStatus.denied) {
        log('Requesting microphone permission');
        status = await Permission.microphone.request();
      }

      if (status == PermissionStatus.granted) {
        log('Microphone permission granted');
        return true;
      } else if (status == PermissionStatus.permanentlyDenied) {
        log('Microphone permission permanently denied - opening settings');
        await openAppSettings();
        return false;
      } else {
        log('Microphone permission denied');
        return false;
      }
    } catch (e) {
      log('Error requesting microphone permission: $e');
      return false;
    }
  }

  static Future<bool> requestCameraPermission() async {
    try {
      PermissionStatus status = await Permission.camera.status;

      if (status == PermissionStatus.granted) {
        log('Camera permission already granted');
        return true;
      }

      if (status == PermissionStatus.denied) {
        log('Requesting camera permission');
        status = await Permission.camera.request();
      }

      if (status == PermissionStatus.granted) {
        log('Camera permission granted');
        return true;
      } else if (status == PermissionStatus.permanentlyDenied) {
        log('Camera permission permanently denied - opening settings');
        await openAppSettings();
        return false;
      } else {
        log('Camera permission denied');
        return false;
      }
    } catch (e) {
      log('Error requesting camera permission: $e');
      return false;
    }
  }

  static Future<bool> requestStoragePermission() async {
    try {
      PermissionStatus status = await Permission.photos.status;

      if (status == PermissionStatus.granted) {
        log('Storage permission already granted');
        return true;
      }

      if (status == PermissionStatus.denied) {
        log('Requesting storage permission');
        status = await Permission.photos.request();
      }

      if (status == PermissionStatus.granted) {
        log('Storage permission granted');
        return true;
      } else if (status == PermissionStatus.permanentlyDenied) {
        log('Storage permission permanently denied - opening settings');
        await openAppSettings();
        return false;
      } else {
        log('Storage permission denied');
        return false;
      }
    } catch (e) {
      log('Error requesting storage permission: $e');
      return false;
    }
  }
}
