import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:greenly/pages/collection/models/commute_assumption_model.dart';
import 'package:greenly/pages/collection/models/food_assumption_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum Frequency {
  daily,
  weekly,
  monthly,
  yearly;

  // --- TODO: Find a better way to handle invalid strings
  static Frequency from(String val) {
    try {
      return Frequency.values.byName(val.trim().toLowerCase());
    } catch (e) {
      // --- This is not optimal
      return Frequency.weekly;
    }
  }
}

extension FrequencyExtensions on Frequency {
  int get count {
    switch (this) {
      case Frequency.daily:
        return 1;
      case Frequency.weekly:
        return Frequency.daily.count * 7;
      case Frequency.monthly:
        return Frequency.weekly.count * 4;
      case Frequency.yearly:
        return Frequency.monthly.count * 12;
    }
  }

  String get name {
    switch (this) {
      case Frequency.daily:
        return 'daily';
      case Frequency.weekly:
        return 'weekly';
      case Frequency.monthly:
        return 'monthly';
      case Frequency.yearly:
        return 'yearly';
    }
  }
}

abstract class Assumption<T> {
  String label();
  T value();
  Frequency frequency();
  int count();
  Widget toWidget();
  Map<String, Object?> toMap();
  double ghgValue();
}

class AssumptionsModel extends ChangeNotifier {
  final List<Assumption> _assumptions = [];

  bool _isLoading = false;
  bool _hasInitialized = false;

  AssumptionsModel() {
    _innitProvider();
  }

  bool get loading => _isLoading;
  bool get initialized => _hasInitialized;

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Assumption> get items =>
      UnmodifiableListView(_assumptions);

  /// All the assumptions of a specific type T
  UnmodifiableListView<T> getAssumptionsPerType<T extends Assumption>() =>
      UnmodifiableListView(_assumptions.whereType<T>());

  /// Add [assumption] to assumptions.
  void add(Assumption assumption) async {
    _assumptions.add(assumption);
    // Notifies listeners of list changes
    notifyListeners();
    switch (assumption) {
      case TransportAssumption _:
        _addTransportAssumptoDB(assumption);
      case FoodAssumption _:
        _addFoodAssumptoBD(assumption);
    }
  }

  /// Removes all the [assumption]s from the list.
  void removeAll() {
    _assumptions.clear();
    // Notifies listeners of list changes
    notifyListeners();
  }

  // --- Logic

  Future<void> _innitProvider() async {
    if (_hasInitialized) return;

    _isLoading = true;
    notifyListeners();

    await _fetchExistingTransportAssumps();
    notifyListeners();

    await _fetchExistingFoodAssumps();
    notifyListeners();

    _hasInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _addTransportAssumptoDB<T>(TransportAssumption<T> assump) async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    await supabase.from('transport_assumption').insert(assump.toMap());
  }

  Future<void> _addFoodAssumptoBD<T>(FoodAssumption<T> assump) async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    await supabase.from('food_assumption').insert(assump.toMap());
  }

  Future<void> _fetchExistingTransportAssumps() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    var assumptions = await supabase.from('transport_assumption').select();

    var transportAssumps = assumptions
        .map((assum) => TransportAssumption.fromMap(assum))
        .toList();

    _assumptions.addAll(transportAssumps);
  }

  Future<void> _fetchExistingFoodAssumps() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    var assumptions = await supabase.from('food_assumption').select();

    var transportAssumps = assumptions
        .map((assum) => FoodAssumption.fromMap(assum))
        .toList();

    _assumptions.addAll(transportAssumps);
  }
}
