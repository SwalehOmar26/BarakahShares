import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class MemorySecureStore implements SecureStore {
  final Map<String, String> _values = {};

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }
}

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

/// Uses secure storage when the platform plugin is available and keeps an
/// in-memory copy so the demonstration still runs if the plugin is missing.
class ResilientSecureStore implements SecureStore {
  ResilientSecureStore(this._inner);

  final SecureStore _inner;
  final Map<String, String> _memory = {};

  static const _timeout = Duration(seconds: 2);

  @override
  Future<String?> read(String key) async {
    try {
      final stored = await _inner.read(key).timeout(_timeout);
      if (stored != null) _memory[key] = stored;
      return stored ?? _memory[key];
    } on Object {
      return _memory[key];
    }
  }

  @override
  Future<void> write(String key, String value) async {
    _memory[key] = value;
    try {
      await _inner.write(key, value).timeout(_timeout);
    } on Object {
      // The memory copy remains available for this session.
    }
  }

  @override
  Future<void> delete(String key) async {
    _memory.remove(key);
    try {
      await _inner.delete(key).timeout(_timeout);
    } on Object {
      // Ignore plugin failures during sign-out on unsupported hosts.
    }
  }
}
