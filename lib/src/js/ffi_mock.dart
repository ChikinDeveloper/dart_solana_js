import 'dart:async';

import 'ffi.dart';

JavascriptFFI getInstance() => JavascriptMockFFI._();

class JavascriptMockFFI implements JavascriptFFI {
  JavascriptMockFFI._();

  @override
  bool get isAvailable => false;

  @override
  dynamic getWindow() => throw UnimplementedError('JavascriptFFI_Mock');

  @override
  void addEventListener(
          dynamic window, String type, WindowEventListener listener) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  void removeEventListener(
          dynamic window, String type, WindowEventListener listener) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  F allowInterop<F extends Function>(F f) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  dynamic callMethod(Object method, [List<dynamic>? args]) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  dynamic callConstructor(Object constructor, [List? args]) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  dynamic callObjectMethod(Object o, String method, List<Object?> args) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  dynamic getProperty(Object o, Object name) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  Future<T> promiseToFuture<T>(Object jsPromise) =>
      throw UnimplementedError('JavascriptFFI_Mock');

  @override
  dynamic jsify(Object object) =>
      throw UnimplementedError('JavascriptFFI_Mock');
}
