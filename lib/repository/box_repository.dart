import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class BoxRepository<T> {

  final String _boxName;
  Box<T>? _box;

  BoxRepository(this._boxName);

  @protected
  Future<Box<T>> getBox() async {
    _box ??= await Hive.openBox(_boxName);

    return _box!;
  }
}