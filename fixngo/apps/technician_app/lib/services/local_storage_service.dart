import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _jobsCacheKey = 'cached_jobs';
  static const String _dashboardCacheKey = 'cached_dashboard';
  static const String _notificationsCacheKey = 'cached_notifications';
  static const String _profileCacheKey = 'cached_profile';
  static const String _offlineActionsKey = 'offline_actions';
  static const String _lastSyncKey = 'last_sync_timestamp';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> cacheJobs(List<dynamic> jobs) async {
    final prefs = await _prefs;
    await prefs.setString(_jobsCacheKey, jsonEncode(jobs));
  }

  Future<List<dynamic>> getCachedJobs() async {
    final prefs = await _prefs;
    final data = prefs.getString(_jobsCacheKey);
    if (data == null) return [];
    return jsonDecode(data) as List<dynamic>;
  }

  Future<void> cacheDashboard(Map<String, dynamic> dashboard) async {
    final prefs = await _prefs;
    await prefs.setString(_dashboardCacheKey, jsonEncode(dashboard));
  }

  Future<Map<String, dynamic>?> getCachedDashboard() async {
    final prefs = await _prefs;
    final data = prefs.getString(_dashboardCacheKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> cacheNotifications(List<dynamic> notifications) async {
    final prefs = await _prefs;
    await prefs.setString(_notificationsCacheKey, jsonEncode(notifications));
  }

  Future<List<dynamic>> getCachedNotifications() async {
    final prefs = await _prefs;
    final data = prefs.getString(_notificationsCacheKey);
    if (data == null) return [];
    return jsonDecode(data) as List<dynamic>;
  }

  Future<void> cacheProfile(Map<String, dynamic> profile) async {
    final prefs = await _prefs;
    await prefs.setString(_profileCacheKey, jsonEncode(profile));
  }

  Future<Map<String, dynamic>?> getCachedProfile() async {
    final prefs = await _prefs;
    final data = prefs.getString(_profileCacheKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> addOfflineAction(Map<String, dynamic> action) async {
    final prefs = await _prefs;
    final data = prefs.getString(_offlineActionsKey);
    final actions = data != null ? (jsonDecode(data) as List<dynamic>) : [];
    actions.add({...action, 'timestamp': DateTime.now().toIso8601String()});
    await prefs.setString(_offlineActionsKey, jsonEncode(actions));
  }

  Future<List<dynamic>> getPendingOfflineActions() async {
    final prefs = await _prefs;
    final data = prefs.getString(_offlineActionsKey);
    if (data == null) return [];
    return jsonDecode(data) as List<dynamic>;
  }

  Future<void> clearOfflineActions() async {
    final prefs = await _prefs;
    await prefs.remove(_offlineActionsKey);
  }

  Future<void> updateLastSync() async {
    final prefs = await _prefs;
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  Future<DateTime?> getLastSync() async {
    final prefs = await _prefs;
    final data = prefs.getString(_lastSyncKey);
    if (data == null) return null;
    return DateTime.parse(data);
  }

  Future<bool> isOfflineMode() async {
    final lastSync = await getLastSync();
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync).inMinutes > 5;
  }
}
