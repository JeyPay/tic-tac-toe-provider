import 'dart:async';

import 'package:flutter/material.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  late T state;

  BaseProvider(this.state);

  List<StreamSubscription> subscriptions = [];

  @override
  @mustCallSuper
  void dispose() {
    subscriptions.disposeSubscriptions();
    super.dispose();
  }
}

extension DisposeSubscriptionsList on List<StreamSubscription> {
  /// Cancel all subscriptions on a given list.
  void disposeSubscriptions() {
    for (var subscription in this) {
      subscription.cancel();
    }
  }
}

extension AutoDispose on StreamSubscription {
  void store(BaseProvider provider) {
    provider.subscriptions.add(this);
  }
}
