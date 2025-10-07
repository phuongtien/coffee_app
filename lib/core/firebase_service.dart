// core/firebase_service.dart - Firebase operations
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/game_table.dart';

class FirebaseService {
  static FirebaseDatabase? _database;
  static DatabaseReference? _tablesRef;
  static final Completer<void> _readyCompleter = Completer<void>();
  static int _serverTimeOffsetMillis = 0;

  static Future<void> get ready => _readyCompleter.future;

  static void init([FirebaseApp? app]) {
    try {
      _database = FirebaseDatabase.instanceFor(
        app: app ?? Firebase.app(),
        databaseURL: 'https://coffee-billboard-app-default-rtdb.asia-southeast1.firebasedatabase.app',
      );

      _database!.setLoggingEnabled(kDebugMode);
      _tablesRef = _database!.ref('tables');

      final offsetRef = _database!.ref('.info/serverTimeOffset');
      offsetRef.onValue.listen((event) {
        final val = event.snapshot.value;
        if (val is int) {
          _serverTimeOffsetMillis = val;
        } else if (val is double) {
          _serverTimeOffsetMillis = val.toInt();
        }
        debugPrint('Firebase serverTimeOffset: $_serverTimeOffsetMillis ms');
      });

      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
      debugPrint('FirebaseService initialized');
    } catch (e) {
      debugPrint('FirebaseService.init error: $e');
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.completeError(e);
      }
    }
  }

  static int serverNowMillis() {
    return DateTime.now().millisecondsSinceEpoch + _serverTimeOffsetMillis;
  }

  static Future<void> saveTable(GameTable table) async {
    await ready;
    try {
      await _tablesRef!.child(table.id.toString()).set(table.toJson());
    } catch (e) {
      debugPrint('FirebaseService.saveTable error: $e');
    }
  }

  static Future<void> saveTables(List<GameTable> tables) async {
    await ready;
    try {
      final Map<String, dynamic> data = {};
      for (var table in tables) {
        data[table.id.toString()] = table.toJson();
      }
      await _tablesRef!.set(data);
    } catch (e) {
      debugPrint('FirebaseService.saveTables error: $e');
    }
  }

  static Future<List<GameTable>> loadTables() async {
    await ready;
    try {
      final snapshot = await _tablesRef!.get();
      if (!snapshot.exists) return [];
      return _parseTablesFromSnapshot(snapshot.value);
    } catch (e) {
      debugPrint('FirebaseService.loadTables error: $e');
      return [];
    }
  }

  static Stream<List<GameTable>> watchTables() async* {
    await ready;
    await for (final event in _tablesRef!.onValue) {
      try {
        yield _parseTablesFromSnapshot(event.snapshot.value);
      } catch (e) {
        debugPrint('FirebaseService.watchTables error: $e');
        yield <GameTable>[];
      }
    }
  }

  static List<GameTable> _parseTablesFromSnapshot(dynamic value) {
    if (value == null) return <GameTable>[];

    final List<GameTable> list = [];

    try {
      if (value is Map) {
        for (final entry in value.entries) {
          final raw = entry.value;
          if (raw == null) continue;

          final Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(raw);

          if (map['id'] == null) {
            final key = entry.key;
            final parsedId = int.tryParse(key.toString());
            map['id'] = parsedId ?? key;
          }

          if (map['ratePerHour'] is String) {
            map['ratePerHour'] = int.tryParse(map['ratePerHour']) ?? 0;
          }
          if (map['accumulatedSeconds'] is String) {
            map['accumulatedSeconds'] = int.tryParse(map['accumulatedSeconds']) ?? 0;
          }
          if (map['occupied'] is String) {
            final s = (map['occupied'] as String).toLowerCase();
            map['occupied'] = (s == 'true' || s == '1');
          }

          try {
            list.add(GameTable.fromJson(map));
          } catch (e) {
            debugPrint('GameTable.fromJson error for entry ${entry.key}: $e');
          }
        }
      } else if (value is List) {
        for (final raw in value) {
          if (raw == null) continue;
          try {
            final map = Map<dynamic, dynamic>.from(raw);
            list.add(GameTable.fromJson(map));
          } catch (e) {
            debugPrint('Parse list item error: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('ParseTables top-level error: $e');
    }

    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }
}