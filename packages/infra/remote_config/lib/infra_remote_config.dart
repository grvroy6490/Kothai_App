library infra_remote_config;

abstract class RemoteConfigClient {
  Future<Map<String, Object?>> fetch();
}
