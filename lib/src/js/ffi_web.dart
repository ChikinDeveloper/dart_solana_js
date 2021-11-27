import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

import 'ffi.dart';

JavascriptFFI getInstance() => JavascriptWebFFI._();

class JavascriptWebFFI implements JavascriptFFI {
  final Map<String, Map> _registeredListeners = {};

  JavascriptWebFFI._();

  @override
  bool get isAvailable => true;

  @override
  dynamic getWindow() => html.window;

  @override
  void addEventListener(
      dynamic window, String type, WindowEventListener listener) {
    void internalListener(html.Event event) {
      if (event is html.MessageEvent) {
        listener(WindowMessageEvent(source: event.source, data: event.data));
      } else {
        listener(WindowEvent());
      }
    }

    window.addEventListener(type, internalListener);
    if (_registeredListeners.containsKey(type)) {
      _registeredListeners[type]![listener] = internalListener;
    } else {
      _registeredListeners[type] = {listener: internalListener};
    }
  }

  @override
  void removeEventListener(
      dynamic window, String type, WindowEventListener listener) {
    final internalListener = _registeredListeners[type]?[listener];
    if (internalListener == null) return;
    window.removeEventListener(type, internalListener);
    _registeredListeners[type]?.remove(listener);
  }

  @override
  F allowInterop<F extends Function>(F f) => js.allowInterop(f);

  @override
  dynamic callMethod(Object method, [List<dynamic>? args]) =>
      js.context.callMethod(method, args);

  @override
  dynamic callConstructor(Object constructor, [List? args]) =>
      js_util.callConstructor(constructor, args);

  @override
  dynamic callObjectMethod(Object o, String method, List<Object?> args) =>
      js_util.callMethod(o, method, args);

  @override
  dynamic getProperty(Object o, Object name) => js_util.getProperty(o, name);

  @override
  Future<T> promiseToFuture<T>(Object jsPromise) =>
      js_util.promiseToFuture(jsPromise);

  @override
  dynamic jsify(Object object) => js_util.jsify(object);
}
