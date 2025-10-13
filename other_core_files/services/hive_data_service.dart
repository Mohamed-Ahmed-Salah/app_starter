import 'package:attendance/core/utils/util_functions.dart';
import 'package:hive_flutter/adapters.dart';

import '../config/organization_theme_config.dart';

///used for large Map values to recall failed request because of connection problems
class HiveDataService {
  late Box<OrganizationThemeConfig> _themeConfigBox;

  static const String _themeConfigBoxName = 'organizationThemeConfigs';
  static const int CURRENT_MODEL_VERSION = 1;
  bool _hiveInitialized = false;

  // Initialize Hive and register adapters
  Future<void> initialize() async {
    if (_hiveInitialized) return; // skip if already done
    _hiveInitialized = true;

    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapters if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(OrganizationThemeConfigAdapter());
      }

      // Open boxes
      _themeConfigBox = await Hive.openBox<OrganizationThemeConfig>(
        _themeConfigBoxName,
      );

      // Run migration after opening box
      await _migrateDataIfNeeded();

      UtilFunctions.appLog('✅ Hive Storage Service initialized successfully');
    } catch (e) {
      if (e is RangeError && e.message.contains('Not enough bytes available')) {
        UtilFunctions.appLog('Hive data corruption detected. Clearing corrupted data...');
        // Clear corrupted data
        try {
          // await clearCorruptedHiveData();
          // Try opening again after clearing
          // await Hive.openBox<OrganizationThemeConfig>(_themeConfigBoxName);
          UtilFunctions.appLog('🔄 Hive storage reinitialized successfully');
        } catch (clearError) {
          UtilFunctions.appLog('❌ Failed to clear corrupted data: $clearError');
          rethrow;
        }
      }
      UtilFunctions.appLog('❌ Failed to initialize Hive Storage Service: $e');
      rethrow;
    }
  }

  ///this is for migrating from v1 to newer version we will add new data here
  ///should be a switch so we can be able to migrate from 1 to 2 or 1 to 10 with no issues and adding only necessary fields
  Future<void> _migrateConfig(OrganizationThemeConfig oldConfig) async {
    // Create new config with migrated data
    final migratedConfig = OrganizationThemeConfig(
      organizationId: oldConfig.organizationId,
      primaryColor: oldConfig.primaryColor,
      primaryColorSwatch: oldConfig.primaryColorSwatch,
      secondaryColor: oldConfig.secondaryColor,
      logoUrl: oldConfig.logoUrl,
      bannerUrl: oldConfig.bannerUrl,
      companyName: oldConfig.companyName,
      apiVersion: oldConfig.apiVersion,
      fontFamily: oldConfig.fontFamily,
      version: CURRENT_MODEL_VERSION,
    );

    await _themeConfigBox.put(oldConfig.organizationId, migratedConfig);
  }

  // migration method
  Future<void> _migrateDataIfNeeded() async {
    final configs = _themeConfigBox.values.toList();
    bool needsMigration = false;

    for (var config in configs) {
      if (config.version < CURRENT_MODEL_VERSION) {
        needsMigration = true;
        await _migrateConfig(config);
      }
    }

    if (needsMigration) {
      UtilFunctions.appLog('✅ Data migration completed');
    }
  }

  // Save theme configuration for organization
  Future<void> saveThemeConfig(OrganizationThemeConfig config) async {
    try {
      ///We only want to save a single config so we delete then add.
      await clearAllConfigs();
      UtilFunctions.appLog("ℹ️ Saving New Theme");

      await _themeConfigBox.put(config.organizationId, config);
      UtilFunctions.appLog(
        '✅ Theme config saved for organization: ${config.organizationId}',
      );
    } catch (e) {
      UtilFunctions.appLog('⚠️ Failed to save theme config: $e');
      rethrow;
    }
  }

  OrganizationThemeConfig? getThemeConfig(String organizationId) {
    try {
      UtilFunctions.appLog('ℹ️ Fetching organizationId: $organizationId');

      final config = _themeConfigBox.get(organizationId);
      UtilFunctions.appLog("📥 Successfully received configs from local: ${config.toString()}");
      return _themeConfigBox.get(organizationId);
    } catch (e) {
      UtilFunctions.appLog(
        '⚠️ Failed to get theme config for organization $organizationId: $e',
      );
      return null;
    }
  }
  Future<void> getAll() async {
    print(_themeConfigBox.toMap()); // prints all key:value


  }


    Future<void> clearAllConfigs() async {
    try {
      await _themeConfigBox.clear();
      UtilFunctions.appLog('✅ All theme configurations cleared');
    } catch (e) {
      UtilFunctions.appLog('⚠️ Failed to clear all configs: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      await _themeConfigBox.close();
      UtilFunctions.appLog('Hive Storage Service closed');
    } catch (e) {
      UtilFunctions.appLog('Failed to close Hive Storage Service: $e');
    }
  }

  // Add this to your app initialization, before opening the box
  Future<void> clearCorruptedHiveData() async {
    try {
      // Delete the corrupted box file
      await Hive.deleteBoxFromDisk(
        _themeConfigBoxName,
      ); // Replace with your actual box name
      UtilFunctions.appLog('Corrupted Hive data cleared successfully');
    } catch (e) {
      UtilFunctions.appLog('Error clearing Hive data: $e');
    }
  }
}
