import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const String defaultIdentifier = 'logistic_app_event_bus';

class Bus {
  Bus(String tag) {
    _tag = tag;
    _subject = PublishSubject<dynamic>();
  }

  Bus.create() {
    _subject = PublishSubject<dynamic>();
    _tag = defaultIdentifier;
  }

  PublishSubject<dynamic>? _subject;
  String? _tag;

  PublishSubject<dynamic>? get subject => _subject;

  String? get tag => _tag;
}

class RxBus {
  factory RxBus() {
    return _singleton;
  }

  RxBus._internal();
  static final RxBus _singleton = RxBus._internal();

  static final List<Bus> _list = <Bus>[];

  static RxBus get singleton => _singleton;

  Stream<T> register<T>({String? tag}) {
    if (tag != null && tag == defaultIdentifier) {
      throw FlutterError("EventBus register tag Can't be $defaultIdentifier");
    }

    Bus? eventBus;

    if (_list.isNotEmpty && tag != null) {
      for (final Bus bus in _list) {
        if (bus.tag == tag) {
          eventBus = bus;
          break;
        }
      }

      if (eventBus == null) {
        eventBus = Bus(tag);
        _list.add(eventBus);
      }
    } else {
      eventBus = tag == null ? Bus.create() : Bus(tag);
      _list.add(eventBus);
    }

    if (T == dynamic) {
      if (eventBus.subject != null) {
        return eventBus.subject!.stream as Stream<T>;
      }
    } else {
      if (eventBus.subject != null) {
        return eventBus.subject!.stream
            .where((dynamic event) => event is T)
            .cast<T>();
      }
    }

    throw FlutterError('EventBus subject is null!');
  }

  void post(dynamic event, {String? tag}) {
    for (final Bus bus in _list) {
      if (tag != null && tag != defaultIdentifier && bus.tag == tag) {
        bus.subject?.sink.add(event);
      } else if ((tag == null || tag == defaultIdentifier) &&
          bus.tag == defaultIdentifier) {
        bus.subject?.sink.add(event);
      }
    }
  }

  void destroy({String? tag}) {
    final List<Bus> toRemove = <Bus>[];

    for (final Bus rxBus in _list) {
      if (tag != null && tag != defaultIdentifier && rxBus.tag == tag) {
        rxBus.subject?.close();
        toRemove.add(rxBus);
      } else if ((tag == null || tag == defaultIdentifier) &&
          rxBus.tag == defaultIdentifier) {
        rxBus.subject?.close();
        toRemove.add(rxBus);
      }
    }

    for (int i = 0; i < toRemove.length; i++) {
      _list.remove(toRemove[i]);
    }
  }
}
