import 'dart:async';

import 'ffi_mock.dart' if (dart.library.js) 'ffi_web.dart' as impl;

abstract class JavascriptFFI {
  static JavascriptFFI? _instance;

  factory JavascriptFFI() => _instance ??= impl.getInstance();

  bool get isAvailable;

  dynamic getWindow();

  void addEventListener(
      dynamic window, String type, WindowEventListener listener);

  void removeEventListener(
      dynamic window, String type, WindowEventListener listener);

  dynamic getProperty(Object o, Object name);

  dynamic callMethod(Object method, [List? args]);

  dynamic callConstructor(Object constructor, [List? args]);

  dynamic callObjectMethod(Object o, String method, List<Object?> args);

  F allowInterop<F extends Function>(F f);

  Future<T> promiseToFuture<T>(Object jsPromise);

  dynamic jsify(Object object);
}

typedef WindowEventListener = void Function(WindowEvent event);

class WindowEvent {
  WindowEvent();
}

class WindowMessageEvent extends WindowEvent {
  final dynamic source;
  final dynamic data;

  WindowMessageEvent({required this.source, required this.data});
}
