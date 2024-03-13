import 'package:nativebrik_bridge/channel/nativebrik_bridge_platform_interface.dart';
import 'package:nativebrik_bridge/utils/random.dart';

enum RemoteConfigPhase {
  failed,
  notFound,
  completed,
}

/// A remote config that can be fetched from nativebrik.
///
/// - **NativebrikBridge** must be initialized before using this class.
/// - Dispose the variant after using it not to leak resources.
///
/// ```dart
/// final config = RemoteConfig("ID OR CUSTOM ID");
/// final variant = await config.fetch();
/// final phase = variant.phase;
/// final value = await variant.get("KEY");
/// await variant.dispose();
/// ```
///
class RemoteConfig {
  final String id;
  final _channelId = generateRandomString(32);
  RemoteConfig(this.id);

  Future<RemoteConfigVariant> fetch() async {
    var phase = await NativebrikBridgePlatform.instance
        .connectRemoteConfig(id, _channelId);
    return RemoteConfigVariant._(_channelId, phase ?? RemoteConfigPhase.failed);
  }
}

class RemoteConfigVariant {
  final String channelId;
  final RemoteConfigPhase phase;
  RemoteConfigVariant._(this.channelId, this.phase);

  Future<String?> get(String key) async {
    return await NativebrikBridgePlatform.instance
        .getRemoteConfigValue(channelId, key);
  }

  Future<int?> getAsInt(String key) async {
    var value = await get(key);
    return value != null ? int.tryParse(value) : null;
  }

  Future<double?> getAsDouble(String key) async {
    var value = await get(key);
    return value != null ? double.tryParse(value) : null;
  }

  Future<bool?> getAsBool(String key) async {
    var value = await get(key);
    return value != null ? value == "TRUE" : null;
  }

  Future<void> dispose() async {
    await NativebrikBridgePlatform.instance.disconnectEmbedding(channelId);
  }
}
